//
//  ExploreViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    static var shared: ExploreViewModel = ExploreViewModel()
    
    @Published var txtSearch: String = ""
    @Published var typeArr: [TypeModel] = []
    
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var isLoading = false
    
    var firebaseService: FirebaseServiceProvider = FirebaseService.shared
    
    init() {
        serviceCallList()
    }
    
    func serviceCallList() {
        isLoading = true
        Task {
            do {
                let types = try await self.firebaseService.fetchTypes()
                await MainActor.run {
                    self.typeArr = types
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
