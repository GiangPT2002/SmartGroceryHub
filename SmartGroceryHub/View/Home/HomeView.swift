//
//  HomeView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var appState: AppState
    @StateObject var locationManager = LocationManager()
    @State private var showContent = false
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.background.ignoresSafeArea()
            
            if homeVM.isLoading && homeVM.offerArr.isEmpty {
                // Skeleton Loading
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.xl) {
                        // Banner skeleton
                        ShimmerPlaceholder(height: 140, radius: AppRadius.lg)
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.lg)
                        
                        // Products skeleton
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            ShimmerPlaceholder(width: 180, height: 24)
                                .padding(.horizontal, AppSpacing.lg)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.md) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        ProductCellSkeleton()
                                    }
                                }
                                .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            ShimmerPlaceholder(width: 150, height: 24)
                                .padding(.horizontal, AppSpacing.lg)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.md) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        ProductCellSkeleton()
                                    }
                                }
                                .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                    }
                    .padding(.bottom, .bottomInsets + 120)
                }
                .safeAreaInset(edge: .top) { headerView }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.xl) {
                        if homeVM.isSearching {
                            searchResultsSection
                        } else {
                            normalHomeContent
                        }
                    }
                    .padding(.bottom, .bottomInsets + 120)
                }
                .refreshable {
                    homeVM.serviceCallList()
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
                .safeAreaInset(edge: .top) { headerView }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            withAnimation(AppAnimation.smooth) {
                showContent = true
            }
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    var headerView: some View {
        VStack(spacing: AppSpacing.sm) {
            // Greeting + Location
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.greeting)
                        .font(AppTypography.footnote(.medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(appState.mainVM.userObj.username.isEmpty ? "Khám phá ngay!" : appState.mainVM.userObj.username)
                        .font(AppTypography.title3(.bold))
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: AppIcons.location)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primary)
                    
                    Text(locationManager.currentAddress)
                        .font(AppTypography.caption(.medium))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xxs + 2)
                .background(AppColors.primarySurface)
                .cornerRadius(AppRadius.pill)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // Search
            SearchTextField(placholder: "Tìm kiếm sản phẩm", txt: $homeVM.txtSearch)
                .padding(.horizontal, AppSpacing.lg)
        }
        .padding(.top, 10)
        .padding(.bottom, AppSpacing.md)
        .floatingHeader()
    }
    
    // MARK: - Search Results
    
    @ViewBuilder
    var searchResultsSection: some View {
        let results = homeVM.allFilteredProducts
        
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Kết quả tìm kiếm")
                    .font(AppTypography.title2(.bold))
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text("\(results.count) sản phẩm")
                    .font(AppTypography.callout())
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
            
            if results.isEmpty {
                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(AppColors.textTertiary)
                    Text("Không tìm thấy sản phẩm")
                        .font(AppTypography.headline(.bold))
                        .foregroundColor(AppColors.textSecondary)
                    Text("Thử tìm kiếm với từ khóa khác")
                        .font(AppTypography.callout())
                        .foregroundColor(AppColors.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, AppSpacing.huge)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: AppSpacing.md),
                    GridItem(.flexible(), spacing: AppSpacing.md)
                ], spacing: AppSpacing.md) {
                    ForEach(results, id: \.id) { pObj in
                        ProductCell(pObj: pObj) {
                            cartVM.addToCart(product: pObj)
                            appState.showToast("Đã thêm vào giỏ hàng!", icon: "cart.fill.badge.plus")
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
    
    // MARK: - Normal Home Content
    
    @ViewBuilder
    var normalHomeContent: some View {
        // Banner
        Image("banner_top")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
            .clipped()
            .cornerRadius(AppRadius.lg)
            .shadow(color: AppShadow.card.color, radius: AppShadow.card.radius, x: 0, y: AppShadow.card.y)
            .padding(.top, AppSpacing.lg)
            .padding(.horizontal, AppSpacing.lg)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        
        // Offers Section
        if !homeVM.offerArr.isEmpty {
            VStack(spacing: AppSpacing.md) {
                SectionTitleAll(title: "Ưu đãi độc quyền", titleAll: "Xem tất cả", icon: "flame.fill") { }
                    .padding(.horizontal, AppSpacing.lg)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: AppSpacing.md) {
                        ForEach(homeVM.offerArr, id: \.id) { pObj in
                            ProductCell(pObj: pObj) {
                                cartVM.addToCart(product: pObj)
                                appState.showToast("Đã thêm vào giỏ hàng!", icon: "cart.fill.badge.plus")
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.xs)
                    .padding(.bottom, AppSpacing.xxs)
                }
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 30)
            .animation(AppAnimation.smooth.delay(0.1), value: showContent)
        }
        
        // Best Sellers Section
        if !homeVM.bestArr.isEmpty {
            VStack(spacing: AppSpacing.md) {
                SectionTitleAll(title: "Bán chạy nhất", titleAll: "Xem tất cả", icon: "star.fill") { }
                    .padding(.horizontal, AppSpacing.lg)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: AppSpacing.md) {
                        ForEach(homeVM.bestArr, id: \.id) { pObj in
                            ProductCell(pObj: pObj) {
                                cartVM.addToCart(product: pObj)
                                appState.showToast("Đã thêm vào giỏ hàng!", icon: "cart.fill.badge.plus")
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.xs)
                    .padding(.bottom, AppSpacing.xxs)
                }
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 30)
            .animation(AppAnimation.smooth.delay(0.2), value: showContent)
        }
        
        // Categories Section
        if !homeVM.typeArr.isEmpty {
            VStack(spacing: AppSpacing.md) {
                SectionTitleAll(title: "Gian hàng", titleAll: "Xem tất cả", icon: "square.grid.2x2.fill") { }
                    .padding(.horizontal, AppSpacing.lg)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: AppSpacing.md) {
                        ForEach(homeVM.typeArr, id: \.id) { tObj in
                            CategoryCell(tObj: tObj) { }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.xs)
                    .padding(.bottom, AppSpacing.xxs)
                }
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 30)
            .animation(AppAnimation.smooth.delay(0.3), value: showContent)
        }
        
        // All Products Section
        if !homeVM.listArr.isEmpty {
            VStack(spacing: AppSpacing.md) {
                SectionTitleAll(title: "Sản phẩm khác", titleAll: "Xem tất cả", icon: "bag.fill") { }
                    .padding(.horizontal, AppSpacing.lg)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: AppSpacing.md) {
                        ForEach(homeVM.listArr, id: \.id) { pObj in
                            ProductCell(pObj: pObj) {
                                cartVM.addToCart(product: pObj)
                                appState.showToast("Đã thêm vào giỏ hàng!", icon: "cart.fill.badge.plus")
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.xs)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 30)
            .animation(AppAnimation.smooth.delay(0.4), value: showContent)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
        .environmentObject(HomeViewModel())
        .environmentObject(CartViewModel())
}
