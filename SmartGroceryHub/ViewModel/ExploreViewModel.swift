//
//  ExploreViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {
    
    @Published var txtSearch: String = ""
    @Published var typeArr: [TypeModel] = []
    
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var isLoading = false
    
    var firebaseService: FirebaseServiceProvider
    
    var filteredTypes: [TypeModel] {
        guard !txtSearch.isEmpty else { return typeArr }
        return typeArr.filter { $0.name.localizedCaseInsensitiveContains(txtSearch) }
    }
    
    var leftColumnItems: [TypeModel] {
        stride(from: 0, to: filteredTypes.count, by: 2).map { filteredTypes[$0] }
    }
    
    var rightColumnItems: [TypeModel] {
        stride(from: 1, to: filteredTypes.count, by: 2).map { filteredTypes[$0] }
    }
    
    init(firebaseService: FirebaseServiceProvider = FirebaseService.shared) {
        self.firebaseService = firebaseService
        serviceCallList()
    }
    
    func serviceCallList() {
        isLoading = true
        Task {
            do {
                let types = try await self.firebaseService.fetchTypes()
                self.typeArr = types
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
                self.isLoading = false
            }
        }
    }
}
