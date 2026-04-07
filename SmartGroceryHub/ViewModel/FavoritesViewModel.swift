//
//  FavoritesViewModel.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class FavoritesViewModel: ObservableObject {
    
    @Published var favoriteItems: [ProductModel] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    
    var isEmpty: Bool {
        favoriteItems.isEmpty
    }
    
    var count: Int {
        favoriteItems.count
    }
    
    init() {
        fetchFavorites()
    }
    
    // MARK: - Check if product is favorited
    
    func isFavorite(product: ProductModel) -> Bool {
        return favoriteItems.contains(where: { $0.id == product.id })
    }
    
    // MARK: - Toggle Favorite
    
    func toggleFavorite(product: ProductModel) {
        AppHaptics.impact(.medium)
        if isFavorite(product: product) {
            removeFavorite(product: product)
        } else {
            addFavorite(product: product)
        }
    }
    
    // MARK: - Add Favorite
    
    private func addFavorite(product: ProductModel) {
        // Add locally first for instant UI feedback
        if !favoriteItems.contains(where: { $0.id == product.id }) {
            withAnimation(AppAnimation.spring) {
                favoriteItems.append(product)
            }
        }
        
        // Sync to Firestore
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "product_id": product.id,
            "name": product.name,
            "image": product.image,
            "price": product.price,
            "offer_price": product.offerPrice as Any,
            "is_offer": product.isOffer,
            "unit_name": product.unitName,
            "unit_value": product.unitValue,
            "detail": product.detail,
            "nutrition_weight": product.nutritionWeight,
            "avg_rating": product.avgRating,
            "cat_id": product.catId,
            "brand_id": product.brandId,
            "type_id": product.typeId,
            "cat_name": product.catName,
            "type_name": product.typeName,
            "is_best_sell": product.isBestSell,
            "added_at": FieldValue.serverTimestamp()
        ]
        
        db.collection("favorites").document(userId)
            .collection("items").document(product.id)
            .setData(data) { error in
                if let error = error {
                    print("Error adding favorite: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Remove Favorite
    
    func removeFavorite(product: ProductModel) {
        AppHaptics.impact(.light)
        withAnimation(AppAnimation.spring) {
            favoriteItems.removeAll { $0.id == product.id }
        }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("favorites").document(userId)
            .collection("items").document(product.id)
            .delete { error in
                if let error = error {
                    print("Error removing favorite: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Fetch Favorites from Firestore
    
    func fetchFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        db.collection("favorites").document(userId)
            .collection("items")
            .order(by: "added_at", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor in
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    self?.favoriteItems = documents.map { doc in
                        ProductModel(id: doc.documentID, data: doc.data())
                    }
                }
            }
    }
}
