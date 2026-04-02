//
//  AccountView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct AccountView: View {
    
    @StateObject var mainVM = MainViewModel.shared
    
    var body: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea() // Premium soft background
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // User Profile Header
                    HStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.primaryApp)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(mainVM.userObj.username.isEmpty ? "Người dùng mới" : mainVM.userObj.username)
                                    .font(.customfont(.bold, fontSize: 24))
                                    .foregroundColor(.primaryText)
                                
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.primaryApp)
                            }
                            
                            Text(mainVM.userObj.email.isEmpty ? "Chưa cung cấp email" : mainVM.userObj.email)
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(.secondaryText)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, .topInsets + 20)
                    .padding(.bottom, 30)
                    .background(Color.white)
                    .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Menu Options
                    VStack(spacing: 0) {
                        AccountRow(title: "Đơn hàng", icon: "bag")
                        AccountRow(title: "Thông tin cá nhân", icon: "person.text.rectangle")
                        AccountRow(title: "Địa chỉ giao hàng", icon: "map")
                        AccountRow(title: "Phương thức thanh toán", icon: "creditcard")
                        AccountRow(title: "Mã khuyến mãi", icon: "ticket")
                        AccountRow(title: "Thông báo", icon: "bell")
                        AccountRow(title: "Trợ giúp", icon: "questionmark.circle")
                        AccountRow(title: "Giới thiệu", icon: "info.circle")
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                    
                    // Log Out Button
                    Button {
                        mainVM.signOut()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Đăng xuất")
                        }
                        .font(.customfont(.bold, fontSize: 18))
                        .foregroundColor(.primaryApp)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.primaryApp.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, .bottomInsets + 100)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

// Helper to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    AccountView()
}
