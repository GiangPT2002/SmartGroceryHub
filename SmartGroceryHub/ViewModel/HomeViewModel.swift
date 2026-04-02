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
    
    // MARK: - Filtered results for search
    
    var filteredOffers: [ProductModel] {
        guard !txtSearch.isEmpty else { return offerArr }
        return offerArr.filter { $0.name.localizedCaseInsensitiveContains(txtSearch) }
    }
    
    var filteredBest: [ProductModel] {
        guard !txtSearch.isEmpty else { return bestArr }
        return bestArr.filter { $0.name.localizedCaseInsensitiveContains(txtSearch) }
    }
    
    var filteredList: [ProductModel] {
        guard !txtSearch.isEmpty else { return listArr }
        return listArr.filter { $0.name.localizedCaseInsensitiveContains(txtSearch) }
    }
    
    var isSearching: Bool {
        !txtSearch.isEmpty
    }
    
    var allFilteredProducts: [ProductModel] {
        guard isSearching else { return [] }
        var results: [ProductModel] = []
        let query = txtSearch.lowercased()
        for p in listArr where p.name.lowercased().contains(query) {
            if !results.contains(where: { $0.id == p.id }) {
                results.append(p)
            }
        }
        for p in offerArr where p.name.lowercased().contains(query) {
            if !results.contains(where: { $0.id == p.id }) {
                results.append(p)
            }
        }
        for p in bestArr where p.name.lowercased().contains(query) {
            if !results.contains(where: { $0.id == p.id }) {
                results.append(p)
            }
        }
        return results
    }
    
    var firebaseService: FirebaseServiceProvider = FirebaseService.shared
    
    init(){
        serviceCallList()
    }
    
    // MARK: - Firestore: Fetch Home Data
    
    func serviceCallList() {
        isLoading = true
        
        Task {
            do {
                async let offers = self.firebaseService.fetchOfferProducts()
                async let bestSellers = self.firebaseService.fetchBestSellProducts()
                async let allProducts = self.firebaseService.fetchAllProducts()
                async let types = self.firebaseService.fetchTypes()
                
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
