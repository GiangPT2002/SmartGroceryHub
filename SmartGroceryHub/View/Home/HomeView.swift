//
//  HomeView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel.shared
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "F8F9FA").ignoresSafeArea() 
            
            if homeVM.isLoading && homeVM.offerArr.isEmpty {
                ProgressView("Đang tải dữ liệu...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // MARK: - Search Results Mode
                        if homeVM.isSearching {
                            searchResultsSection
                        } else {
                            // MARK: - Normal Home Content
                            normalHomeContent
                        }
                    }
                    .padding(.bottom, .bottomInsets + 120)
                }
                .refreshable {
                    homeVM.serviceCallList()
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
                .safeAreaInset(edge: .top) {
                    VStack(spacing: 15) {
                        // Header Logo & Location
                        HStack {
                            Image("app_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            Spacer()
                            
                            HStack(spacing: 5) {
                                Image("location")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                
                                Text(locationManager.currentAddress)
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .foregroundColor(.darkGray)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Color.clear.frame(width: 30, height: 30)
                        }
                        .padding(.horizontal, 20)
                        
                        // Search Bar
                        SearchTextField(placholder: "Tìm kiếm sản phẩm", txt: $homeVM.txtSearch)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea(.all, edges: .top)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                    )
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
    
    // MARK: - Search Results Section
    
    @ViewBuilder
    var searchResultsSection: some View {
        let results = homeVM.allFilteredProducts
        
        VStack(spacing: 15) {
            HStack {
                Text("Kết quả tìm kiếm")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.primaryText)
                Spacer()
                Text("\(results.count) sản phẩm")
                    .font(.customfont(.medium, fontSize: 15))
                    .foregroundColor(.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if results.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.placeholder)
                    Text("Không tìm thấy sản phẩm")
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundColor(.secondaryText)
                    Text("Thử tìm kiếm với từ khóa khác")
                        .font(.customfont(.medium, fontSize: 15))
                        .foregroundColor(.placeholder)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ], spacing: 15) {
                    ForEach(results, id: \.id) { pObj in
                        ProductCell(pObj: pObj) {
                            CartViewModel.shared.addToCart(product: pObj)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Normal Home Content
    
    @ViewBuilder
    var normalHomeContent: some View {
        Image("banner_top")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
            .clipped()
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.top, 20)
            .padding(.horizontal, 20)
        
        if !homeVM.offerArr.isEmpty {
            VStack(spacing: 15) {
                SectionTitleAll(title: "Ưu đãi độc quyền", titleAll: "Xem tất cả") { }
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.offerArr, id: \.id){ pObj in
                            ProductCell(pObj: pObj) { 
                                CartViewModel.shared.addToCart(product: pObj)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .padding(.bottom, 5)
                }
            }
        }
        
        // Best Sellers Section
        if !homeVM.bestArr.isEmpty {
            VStack(spacing: 15) {
                SectionTitleAll(title: "Bán chạy nhất", titleAll: "Xem tất cả") { }
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.bestArr, id: \.id){ pObj in
                            ProductCell(pObj: pObj) { 
                                CartViewModel.shared.addToCart(product: pObj)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .padding(.bottom, 5)
                }
            }
        }
        
        // Categories Section
        if !homeVM.typeArr.isEmpty {
            VStack(spacing: 15) {
                SectionTitleAll(title: "Gian hàng", titleAll: "Xem tất cả") { }
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.typeArr, id: \.id){ tObj in
                            CategoryCell(tObj: tObj) { }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .padding(.bottom, 5)
                }
            }
        }
        
        // All Products Section
        if !homeVM.listArr.isEmpty {
            VStack(spacing: 15) {
                SectionTitleAll(title: "Sản phẩm khác", titleAll: "Xem tất cả") { }
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.listArr, id: \.id){ pObj in
                            ProductCell(pObj: pObj) { 
                                CartViewModel.shared.addToCart(product: pObj)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
