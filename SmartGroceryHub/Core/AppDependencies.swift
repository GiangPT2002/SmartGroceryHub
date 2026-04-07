//
//  AppDependencies.swift
//  SmartGroceryHub
//
//  Central dependency container — replaces all singletons.
//

import SwiftUI

@MainActor
class AppState: ObservableObject {
    // ViewModels — owned by AppState, injected via environment
    let mainVM: MainViewModel
    let homeVM: HomeViewModel
    let cartVM: CartViewModel
    let exploreVM: ExploreViewModel
    let favoritesVM: FavoritesViewModel
    let orderVM: OrderViewModel
    
    // App-wide UI state
    @Published var selectedTab: Int = 0
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastIcon: String = "checkmark.circle.fill"
    @Published var toastColor: Color = AppColors.success
    
    init(firebaseService: FirebaseServiceProvider = FirebaseService.shared) {
        self.mainVM = MainViewModel(firebaseService: firebaseService)
        self.homeVM = HomeViewModel(firebaseService: firebaseService)
        self.cartVM = CartViewModel()
        self.exploreVM = ExploreViewModel(firebaseService: firebaseService)
        self.favoritesVM = FavoritesViewModel()
        self.orderVM = OrderViewModel()
    }
    
    // MARK: - Toast
    
    func showToast(_ message: String, icon: String = "checkmark.circle.fill", color: Color = AppColors.success) {
        toastMessage = message
        toastIcon = icon
        toastColor = color
        withAnimation(AppAnimation.spring) {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(AppAnimation.standard) {
                self.showToast = false
            }
        }
    }
    
    // MARK: - Greeting
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Chào buổi sáng"
        case 12..<17: return "Chào buổi chiều"
        case 17..<21: return "Chào buổi tối"
        default: return "Xin chào"
        }
    }
}
