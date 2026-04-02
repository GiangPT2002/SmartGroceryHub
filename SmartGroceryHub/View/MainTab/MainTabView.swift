//
//  MainTabView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 19/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var homeVM = HomeViewModel.shared
    @Namespace var animation
    
    var body: some View {
        ZStack {
            
            if(homeVM.selectTab == 0) {
            }else if(homeVM.selectTab == 1) {
            }else if(homeVM.selectTab == 2) {
            }
            
            TabView(selection: $homeVM.selectTab){
                HomeView().tag(0)
                ExploreView().tag(1)
                CartView().tag(2)
                ExploreView().tag(3)
                AccountView().tag(4)
            }
            .onAppear{
                UIScrollView.appearance().isScrollEnabled = false
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: homeVM.selectTab) { newValue in
                debugPrint("Sel Tab : \(newValue)")
            }
            
            VStack{
                
                Spacer()
                
                HStack(spacing: 0){
                    
                    TabButton(title: "Trang chủ", icon: "store_tab", isSelect: homeVM.selectTab == 0, animation: animation) {
                        DispatchQueue.main.async { withAnimation { homeVM.selectTab = 0 } }
                    }
                    
                    TabButton(title: "Khám phá", icon: "explore_tab", isSelect: homeVM.selectTab == 1, animation: animation) {
                        DispatchQueue.main.async { withAnimation { homeVM.selectTab = 1 } }
                    }
                    
                    TabButton(title: "Giỏ hàng", icon: "cart_tab", isSelect: homeVM.selectTab == 2, animation: animation) {
                        DispatchQueue.main.async { withAnimation { homeVM.selectTab = 2 } }
                    }
                    
                    TabButton(title: "Yêu thích", icon: "fav_tab", isSelect: homeVM.selectTab == 3, animation: animation) {
                        DispatchQueue.main.async { withAnimation { homeVM.selectTab = 3 } }
                    }
                    
                    TabButton(title: "Tài khoản", icon: "account_tab", isSelect: homeVM.selectTab == 4, animation: animation) {
                        DispatchQueue.main.async { withAnimation { homeVM.selectTab = 4 } }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 5)
                .background(.ultraThinMaterial)
                .cornerRadius(35)
                .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.white.opacity(0.3), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, .bottomInsets + 10)
                
            }
            
        }.navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
