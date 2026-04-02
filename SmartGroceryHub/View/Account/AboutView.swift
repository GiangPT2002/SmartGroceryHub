//
//  AboutView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Giới thiệu")
                        .font(.customfont(.bold, fontSize: 22))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 25, height: 25)
                }
                .padding(.top, .topInsets + 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // App Logo & Version
                        VStack(spacing: 15) {
                            Image("app_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            
                            Text("Smart Grocery Hub")
                                .font(.customfont(.bold, fontSize: 24))
                                .foregroundColor(.primaryText)
                            
                            Text("Phiên bản 1.0.0")
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundColor(.secondaryText)
                        }
                        .padding(.top, 40)
                        
                        // Description
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Về ứng dụng")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.primaryText)
                            
                            Text("Smart Grocery Hub là ứng dụng mua sắm thực phẩm thông minh, giúp bạn dễ dàng khám phá, lựa chọn và đặt mua các sản phẩm tươi ngon với giá tốt nhất.")
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundColor(.secondaryText)
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        // Features
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Tính năng nổi bật")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.primaryText)
                            
                            FeatureRow(icon: "cart.fill", title: "Giỏ hàng thông minh", color: Color(hex: "53B175"))
                            FeatureRow(icon: "heart.fill", title: "Danh sách yêu thích", color: Color(hex: "E74C3C"))
                            FeatureRow(icon: "magnifyingglass", title: "Tìm kiếm nhanh chóng", color: Color(hex: "3498DB"))
                            FeatureRow(icon: "bag.fill", title: "Theo dõi đơn hàng", color: Color(hex: "F39C12"))
                            FeatureRow(icon: "lock.shield.fill", title: "Thanh toán bảo mật", color: Color(hex: "9B59B6"))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        // Developer
                        VStack(spacing: 10) {
                            Text("Phát triển bởi")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(.secondaryText)
                            
                            Text("Phạm Trường Giang")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.primaryApp)
                            
                            Text("© 2025 Smart Grocery Hub")
                                .font(.customfont(.medium, fontSize: 13))
                                .foregroundColor(.placeholder)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct FeatureRow: View {
    var icon: String
    var title: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(color)
                .cornerRadius(10)
            
            Text(title)
                .font(.customfont(.medium, fontSize: 16))
                .foregroundColor(.primaryText)
            
            Spacer()
        }
    }
}

#Preview {
    AboutView()
}
