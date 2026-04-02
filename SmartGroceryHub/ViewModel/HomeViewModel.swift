//
//  HomeViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 23/2/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    static var shared: HomeViewModel = HomeViewModel()
    
    @Published var selectTab: Int = 0
    @Published var txtSearch: String = ""
    
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    @Published var offerArr: [ProductModel] = []
    @Published var bestArr: [ProductModel] = []
    @Published var listArr: [ProductModel] = []
    @Published var typeArr: [TypeModel] = []
    
    
    init(){
        serviceCallList()
    }
    
    // MARK: - Firestore: Fetch Home Data
    
    func serviceCallList() {
        isLoading = true
        
        Task {
            do {
                async let offers = FirebaseService.shared.fetchOfferProducts()
                async let bestSellers = FirebaseService.shared.fetchBestSellProducts()
                async let allProducts = FirebaseService.shared.fetchAllProducts()
                async let types = FirebaseService.shared.fetchTypes()
                
                let (fetchedOffers, fetchedBest, fetchedAll, fetchedTypes) = try await (offers, bestSellers, allProducts, types)
                
                await MainActor.run {
                    self.offerArr = fetchedOffers
                    self.bestArr = fetchedBest
                    self.listArr = fetchedAll
                    self.typeArr = fetchedTypes
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
}
