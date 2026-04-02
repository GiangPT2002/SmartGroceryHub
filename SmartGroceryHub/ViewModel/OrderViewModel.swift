//
//  OrderViewModel.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    static let shared = OrderViewModel()
    
    @Published var orders: [OrderModel] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    
    // MARK: - Place Order from Cart
    
    func placeOrder(cartItems: [CartItemModel], totalPrice: Double) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let itemsData: [[String: Any]] = cartItems.map { item in
            [
                "name": item.product.name,
                "image": item.product.image,
                "price": item.product.offerPrice ?? item.product.price,
                "qty": item.qty,
                "product_id": item.product.id
            ]
        }
        
        let orderData: [String: Any] = [
            "user_id": userId,
            "items": itemsData,
            "total_price": totalPrice,
            "item_count": cartItems.count,
            "status": "Đã đặt hàng",
            "created_at": FieldValue.serverTimestamp()
        ]
        
        db.collection("orders").document(userId)
            .collection("items")
            .addDocument(data: orderData) { error in
                if let error = error {
                    print("Error placing order: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Fetch Orders
    
    func fetchOrders() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        db.collection("orders").document(userId)
            .collection("items")
            .order(by: "created_at", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    self?.orders = documents.map { doc in
                        OrderModel(id: doc.documentID, data: doc.data())
                    }
                }
            }
    }
}
