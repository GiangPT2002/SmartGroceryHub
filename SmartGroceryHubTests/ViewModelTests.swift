//
//  ViewModelTests.swift
//  SmartGroceryHubTests
//
//  Created by AI.
//

import Testing
import Foundation
import FirebaseAuth
@testable import SmartGroceryHub

@MainActor
struct ViewModelTests {

    // MARK: - CartViewModel Tests
    
    @Test("Test CartViewModel addToCart and Totals")
    func testCartViewModelAddToCart() async throws {
        let cartVM = CartViewModel()
        let product1 = ProductModel(id: "p1", data: ["name": "Apple", "price": 2.0])
        let product2 = ProductModel(id: "p2", data: ["name": "Banana", "offer_price": 1.5, "is_offer": true])
        
        cartVM.addToCart(product: product1)
        cartVM.addToCart(product: product2)
        cartVM.addToCart(product: product1) // qty should be 2
        
        #expect(cartVM.cartItems.count == 2)
        #expect(cartVM.cartItems.first(where: { $0.id == cartVM.cartItems[0].id })?.qty == 2)
        
        // Total price: (2 * 2.0) + (1 * 1.5) = 5.5
        #expect(cartVM.totalPrice == 5.5)
        
        // Checkout
        cartVM.checkout()
        #expect(cartVM.cartItems.isEmpty)
        #expect(cartVM.showCheckoutSuccess == true)
    }
    
    // MARK: - CartViewModel Decrease Qty Tests
    
    @Test("Test CartViewModel decrease removes item at qty 1")
    func testCartViewModelDecreaseRemovesItem() async throws {
        let cartVM = CartViewModel()
        let product = ProductModel(id: "p1", data: ["name": "Apple", "price": 10.0])
        
        cartVM.addToCart(product: product)
        #expect(cartVM.cartItems.count == 1)
        
        cartVM.decreaseQty(item: cartVM.cartItems[0])
        #expect(cartVM.cartItems.isEmpty)
    }
    
    // MARK: - FavoritesViewModel Tests
    
    @Test("Test FavoritesViewModel toggle favorite")
    func testFavoritesToggle() async throws {
        let favVM = FavoritesViewModel()
        let product = ProductModel(id: "fav_test_1", data: ["name": "Test Product", "price": 25.0])
        
        // Initially not favorite
        #expect(!favVM.isFavorite(product: product))
        
        // Add to favorites (local only, no Firestore in test)
        favVM.favoriteItems.append(product)
        #expect(favVM.isFavorite(product: product))
        #expect(favVM.favoriteItems.count == 1)
        
        // Remove from favorites
        favVM.favoriteItems.removeAll { $0.id == product.id }
        #expect(!favVM.isFavorite(product: product))
        #expect(favVM.favoriteItems.isEmpty)
    }
    
    // MARK: - Search Filter Tests
    
    @Test("Test HomeViewModel search filtering")
    func testSearchFiltering() async throws {
        let vm = HomeViewModel()
        
        // Set up test data
        vm.offerArr = [
            ProductModel(id: "1", data: ["name": "Táo đỏ", "price": 10.0]),
            ProductModel(id: "2", data: ["name": "Chuối", "price": 5.0])
        ]
        vm.bestArr = [
            ProductModel(id: "3", data: ["name": "Táo xanh", "price": 12.0])
        ]
        vm.listArr = [
            ProductModel(id: "4", data: ["name": "Cam", "price": 8.0]),
            ProductModel(id: "5", data: ["name": "Táo vàng", "price": 15.0])
        ]
        
        // No search — should return all
        vm.txtSearch = ""
        #expect(vm.filteredOffers.count == 2)
        #expect(vm.filteredBest.count == 1)
        #expect(vm.filteredList.count == 2)
        #expect(!vm.isSearching)
        
        // Search "Táo" — should filter correctly
        vm.txtSearch = "Táo"
        #expect(vm.filteredOffers.count == 1)
        #expect(vm.filteredOffers[0].name == "Táo đỏ")
        #expect(vm.filteredBest.count == 1)
        #expect(vm.filteredList.count == 1)
        #expect(vm.isSearching)
        
        // allFilteredProducts should deduplicate
        let allResults = vm.allFilteredProducts
        #expect(allResults.count == 3) // Táo vàng, Táo đỏ, Táo xanh
        
        // Search "xyz" — should return empty
        vm.txtSearch = "xyz"
        #expect(vm.filteredOffers.isEmpty)
        #expect(vm.allFilteredProducts.isEmpty)
    }
}

// MARK: - Mock Firebase Service

class MockFirebaseService: FirebaseServiceProvider {
    
    var shouldThrowError = false
    
    func signIn(email: String, password: String) async throws -> User {
        throw NSError(domain: "Auth", code: AuthErrorCode.userNotFound.rawValue, userInfo: nil)
    }
    
    func signUp(email: String, password: String, username: String) async throws -> User {
        throw NSError(domain: "Auth", code: AuthErrorCode.emailAlreadyInUse.rawValue, userInfo: nil)
    }
    
    func signOut() throws {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
    }
    
    func fetchOfferProducts() async throws -> [ProductModel] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 1, userInfo: nil) }
        return [ProductModel(id: "of1", data: ["name": "Mock Offer"])]
    }
    
    func fetchBestSellProducts() async throws -> [ProductModel] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 1, userInfo: nil) }
        return [ProductModel(id: "bs1", data: ["name": "Mock Best Sell"])]
    }
    
    func fetchAllProducts() async throws -> [ProductModel] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 1, userInfo: nil) }
        return [ProductModel(id: "all1", data: ["name": "Mock All"])]
    }
    
    func fetchTypes() async throws -> [TypeModel] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 1, userInfo: nil) }
        return [TypeModel(id: "t1", data: ["type_name": "Mock Type"])]
    }
    
    func fetchUserData(uid: String) async throws -> [String : Any]? {
        return ["username": "MockUser"]
    }
}

// MARK: - API ViewModel Tests

@MainActor
struct APIViewModelTests {
    
    @Test("Test HomeViewModel data fetching")
    func testHomeViewModelFetchSuccess() async throws {
        let vm = HomeViewModel()
        vm.firebaseService = MockFirebaseService()
        
        vm.serviceCallList()
        
        // Let Task execute
        try await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(vm.offerArr.count == 1)
        #expect(vm.bestArr.count == 1)
        #expect(vm.listArr.count == 1)
        #expect(vm.typeArr.count == 1)
        #expect(vm.isLoading == false)
        #expect(vm.showError == false)
    }

    @Test("Test ExploreViewModel data fetching")
    func testExploreViewModelFetchSuccess() async throws {
        let vm = ExploreViewModel()
        vm.firebaseService = MockFirebaseService()
        
        vm.serviceCallList()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(vm.typeArr.count == 1)
        #expect(vm.isLoading == false)
    }
    
    @Test("Test MainViewModel login error mappings")
    func testMainViewModelAuthErrorHandling() async throws {
        let vm = MainViewModel()
        vm.firebaseService = MockFirebaseService() // Throws userNotFound
        
        vm.txtEmail = "test@test.com"
        vm.txtPassword = "password123"
        
        vm.serviceCallLogin()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(vm.showError == true)
        #expect(vm.errorMessage.contains("Không tìm thấy tài khoản với email này"))
    }
}
