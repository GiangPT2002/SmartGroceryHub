//
//  CartViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

class CartViewModel: ObservableObject {
    static let shared = CartViewModel()
    
    @Published var cartItems: [CartItemModel] = []
    @Published var showCheckoutSuccess: Bool = false
    
    var totalPrice: Double {
        cartItems.reduce(0) { total, item in
            let price = item.product.offerPrice ?? item.product.price
            return total + (price * Double(item.qty))
        }
    }
    
    func addToCart(product: ProductModel) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].qty += 1
        } else {
            cartItems.append(CartItemModel(product: product))
        }
    }
    
    func removeFromCart(item: CartItemModel) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    func increaseQty(item: CartItemModel) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].qty += 1
        }
    }
    
    func decreaseQty(item: CartItemModel) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].qty > 1 {
                cartItems[index].qty -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func checkout() {
        if !cartItems.isEmpty {
            cartItems.removeAll()
            showCheckoutSuccess = true
        }
    }
}
