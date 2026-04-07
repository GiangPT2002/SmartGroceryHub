//
//  HomeViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 23/2/25.
//

import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    // MARK: - View State
    
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var viewState: ViewState = .idle
    @Published var txtSearch: String = ""
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var offerArr: [ProductModel] = []
    @Published var bestArr: [ProductModel] = []
    @Published var listArr: [ProductModel] = []
    @Published var typeArr: [TypeModel] = []
    
    private var searchCancellable: AnyCancellable?
    @Published var debouncedSearch: String = ""
    
    // MARK: - Filtered results for search
    
    var isSearching: Bool {
        !debouncedSearch.isEmpty
    }
    
    var allFilteredProducts: [ProductModel] {
        guard isSearching else { return [] }
        let query = debouncedSearch.lowercased()
        var seen = Set<String>()
        var results: [ProductModel] = []
        
        for p in listArr + offerArr + bestArr {
            if p.name.lowercased().contains(query) && !seen.contains(p.id) {
                seen.insert(p.id)
                results.append(p)
            }
        }
        return results
    }
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var firebaseService: FirebaseServiceProvider
    
    init(firebaseService: FirebaseServiceProvider = FirebaseService.shared) {
        self.firebaseService = firebaseService
        
        // Debounce search — 300ms delay
        searchCancellable = $txtSearch
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.debouncedSearch = value
            }
        
        serviceCallList()
    }
    
    // MARK: - Firestore: Fetch Home Data
    
    func serviceCallList() {
        viewState = .loading
        
        Task {
            do {
                async let offers = self.firebaseService.fetchOfferProducts()
                async let bestSellers = self.firebaseService.fetchBestSellProducts()
                async let allProducts = self.firebaseService.fetchAllProducts()
                async let types = self.firebaseService.fetchTypes()
                
                let (fetchedOffers, fetchedBest, fetchedAll, fetchedTypes) = try await (offers, bestSellers, allProducts, types)
                
                self.offerArr = fetchedOffers
                self.bestArr = fetchedBest
                self.listArr = fetchedAll
                self.typeArr = fetchedTypes
                self.viewState = .loaded
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
}
