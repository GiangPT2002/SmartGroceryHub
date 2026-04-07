//
//  MainTabView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 19/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var cartVM: CartViewModel
    @Namespace var animation
    
    var body: some View {
        ZStack {
            // Tab Content
            TabView(selection: $appState.selectedTab) {
                HomeView().tag(0)
                ExploreView().tag(1)
                CartView().tag(2)
                FavoritesView().tag(3)
                AccountView().tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Floating Tab Bar
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    TabButton(
                        title: "Trang chủ",
                        icon: "store_tab",
                        isSelect: appState.selectedTab == 0,
                        animation: animation
                    ) {
                        withAnimation(AppAnimation.spring) { appState.selectedTab = 0 }
                    }
                    
                    TabButton(
                        title: "Khám phá",
                        icon: "explore_tab",
                        isSelect: appState.selectedTab == 1,
                        animation: animation
                    ) {
                        withAnimation(AppAnimation.spring) { appState.selectedTab = 1 }
                    }
                    
                    TabButton(
                        title: "Giỏ hàng",
                        icon: "cart_tab",
                        isSelect: appState.selectedTab == 2,
                        badgeCount: cartVM.itemCount,
                        animation: animation
                    ) {
                        withAnimation(AppAnimation.spring) { appState.selectedTab = 2 }
                    }
                    
                    TabButton(
                        title: "Yêu thích",
                        icon: "fav_tab",
                        isSelect: appState.selectedTab == 3,
                        animation: animation
                    ) {
                        withAnimation(AppAnimation.spring) { appState.selectedTab = 3 }
                    }
                    
                    TabButton(
                        title: "Tài khoản",
                        icon: "account_tab",
                        isSelect: appState.selectedTab == 4,
                        animation: animation
                    ) {
                        withAnimation(AppAnimation.spring) { appState.selectedTab = 4 }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 5)
                .background(.ultraThinMaterial)
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: 8)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, .bottomInsets + 10)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(CartViewModel())
}
