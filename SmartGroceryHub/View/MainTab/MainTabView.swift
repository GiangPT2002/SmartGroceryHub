//
//  MainTabView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 19/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var homeVM = HomeViewModel.shared
    
    var body: some View {
        VStack{
            
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
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: homeVM.selectTab) { newValue in
                debugPrint("Sel tab \(newValue)")
            }
            
            HStack{
                
                TabButton(title: "Trang chủ",
                          icon: "store_tab",
                          isSelect: homeVM.selectTab == 0)
                {
                    print("Button tab")
                    DispatchQueue.main.async {
                        withAnimation {
                            homeVM.selectTab = 0
                        }
                    }
                }
                
                TabButton(title: "Khám phá",
                          icon: "explore_tab",
                          isSelect: homeVM.selectTab == 1)
                {
                    DispatchQueue.main.async {
                        withAnimation {
                            homeVM.selectTab = 1
                        }
                    }
                }
                
                TabButton(title: "Giỏ hàng",
                          icon: "cart_tab",
                          isSelect: homeVM.selectTab == 2)
                {
                    DispatchQueue.main.async {
                        withAnimation {
                            homeVM.selectTab = 2
                        }
                    }
                }
                
                TabButton(title: "Yêu thích",
                          icon: "fav_tab",
                          isSelect: homeVM.selectTab == 3)
                {
                    DispatchQueue.main.async {
                        withAnimation {
                            homeVM.selectTab = 3
                        }
                    }
                }
                
                TabButton(title: "Tài khoản",
                          icon: "account_tab",
                          isSelect: homeVM.selectTab == 4)
                {
                    DispatchQueue.main.async {
                        withAnimation {
                            homeVM.selectTab = 4
                        }
                    }
                }
                
                
            }
            .padding(.top, 10)
            .padding(.bottom, .bottomInsets)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: -2)
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    MainTabView()
}
