//
//  CartViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class CartViewModel: ObservableObject {
    
    @Published var cartItems: [CartItemModel] = []
    @Published var showCheckoutSuccess: Bool = false
    
    private let db = Firestore.firestore()
    
    var totalPrice: Double {
        cartItems.reduce(0) { total, item in
            let price = item.product.displayPrice
            return total + (price * Double(item.qty))
        }
    }
    
    var formattedTotal: String {
        "\(Int(totalPrice))đ"
    }
    
    var itemCount: Int {
        cartItems.count
    }
    
    var totalQuantity: Int {
        cartItems.reduce(0) { $0 + $1.qty }
    }
    
    var isEmpty: Bool {
        cartItems.isEmpty
    }
    
    init() {
        loadCart()
    }
    
    func addToCart(product: ProductModel) {
        AppHaptics.impact(.light)
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            withAnimation(AppAnimation.spring) {
                cartItems[index].qty += 1
            }
        } else {
            withAnimation(AppAnimation.spring) {
                cartItems.append(CartItemModel(product: product))
            }
        }
        saveCart()
    }
    
    func addToCartWithQty(product: ProductModel, qty: Int) {
        AppHaptics.impact(.medium)
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            withAnimation(AppAnimation.spring) {
                cartItems[index].qty += qty
            }
        } else {
            var item = CartItemModel(product: product)
            item.qty = qty
            withAnimation(AppAnimation.spring) {
                cartItems.append(item)
            }
        }
        saveCart()
    }
    
    func removeFromCart(item: CartItemModel) {
        AppHaptics.impact(.medium)
        withAnimation(AppAnimation.spring) {
            cartItems.removeAll { $0.id == item.id }
        }
        saveCart()
    }
    
    func increaseQty(item: CartItemModel) {
        AppHaptics.impact(.light)
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            withAnimation(AppAnimation.quick) {
                cartItems[index].qty += 1
            }
            saveCart()
        }
    }
    
    func decreaseQty(item: CartItemModel) {
        AppHaptics.impact(.light)
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].qty > 1 {
                withAnimation(AppAnimation.quick) {
                    cartItems[index].qty -= 1
                }
            } else {
                withAnimation(AppAnimation.spring) {
                    cartItems.remove(at: index)
                }
            }
            saveCart()
        }
    }
    
    func checkout(orderVM: OrderViewModel) {
        if !cartItems.isEmpty {
            AppHaptics.notification(.success)
            orderVM.placeOrder(cartItems: cartItems, totalPrice: totalPrice)
            
            withAnimation(AppAnimation.smooth) {
                cartItems.removeAll()
            }
            clearCartFromFirestore()
            showCheckoutSuccess = true
        }
    }
    
    // MARK: - Firestore Cart Persistence
    
    private func saveCart() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let cartData: [[String: Any]] = cartItems.map { item in
            [
                "product_id": item.product.id,
                "name": item.product.name,
                "image": item.product.image,
                "price": item.product.price,
                "offer_price": item.product.offerPrice as Any,
                "is_offer": item.product.isOffer,
                "unit_name": item.product.unitName,
                "unit_value": item.product.unitValue,
                "detail": item.product.detail,
                "nutrition_weight": item.product.nutritionWeight,
                "avg_rating": item.product.avgRating,
                "cat_id": item.product.catId,
                "brand_id": item.product.brandId,
                "type_id": item.product.typeId,
                "cat_name": item.product.catName,
                "type_name": item.product.typeName,
                "is_best_sell": item.product.isBestSell,
                "qty": item.qty
            ]
        }
        
        db.collection("carts").document(userId).setData([
            "items": cartData,
            "updated_at": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error saving cart: \(error.localizedDescription)")
            }
        }
    }
    
    func loadCart() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("carts").document(userId).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading cart: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data(),
                  let itemsData = data["items"] as? [[String: Any]] else { return }
            
            Task { @MainActor in
                self.cartItems = itemsData.compactMap { itemData in
                    let productId = itemData["product_id"] as? String ?? ""
                    guard !productId.isEmpty else { return nil }
                    
                    let product = ProductModel(id: productId, data: itemData)
                    var cartItem = CartItemModel(product: product)
                    cartItem.qty = itemData["qty"] as? Int ?? 1
                    return cartItem
                }
            }
        }
    }
    
    private func clearCartFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("carts").document(userId).delete()
    }
}
