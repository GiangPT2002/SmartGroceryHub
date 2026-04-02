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
                        
                        Spacer().frame(height: 155)
                        
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
                                    .padding(.bottom, 30) // Extra bottom padding for tab bar
                                }
                            }
                        }
                    }
                    .padding(.bottom, .bottomInsets + 60)
                }
                .refreshable {
                    // Pull to refresh feature
                    homeVM.serviceCallList()
                    // Add slight delay for animation smoothness if it loads too fast
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
            }
            
            // Premium Floating Blur Header
            VStack(spacing: 15) {
                // Header Logo & Location
                HStack {
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Image("location") // Ensure this asset exists
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text(locationManager.currentAddress)
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.darkGray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Invisible view for symmetry spacing
                    Color.clear.frame(width: 30, height: 30)
                }
                .padding(.horizontal, 20)
                
                // Search Bar integrated into Header
                SearchTextField(placholder: "Tìm kiếm sản phẩm", txt: $homeVM.txtSearch)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 15)
            .padding(.top, .topInsets + 5)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(.all, edges: .top)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
            )
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

#Preview {
    HomeView()
}
