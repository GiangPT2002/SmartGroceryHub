//
//  AccountView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @State private var showLogoutConfirm = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // User Profile Header
                    VStack(spacing: AppSpacing.md) {
                        // Avatar with gradient ring
                        ZStack {
                            Circle()
                                .fill(
                                    AngularGradient(
                                        colors: [AppColors.primary, AppColors.accent, AppColors.info, AppColors.primary],
                                        center: .center
                                    )
                                )
                                .frame(width: 84, height: 84)
                            
                            Circle()
                                .fill(AppColors.surface)
                                .frame(width: 78, height: 78)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(AppColors.primary)
                        }
                        
                        VStack(spacing: AppSpacing.xxs) {
                            HStack(spacing: AppSpacing.xs) {
                                Text(mainVM.userObj.username.isEmpty ? "Người dùng mới" : mainVM.userObj.username)
                                    .font(AppTypography.title2(.bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                NavigationLink(destination: ProfileEditView()) {
                                    Image(systemName: AppIcons.edit)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 26, height: 26)
                                        .background(AppColors.primary)
                                        .cornerRadius(AppRadius.xs)
                                }
                            }
                            
                            Text(mainVM.userObj.email.isEmpty ? "Chưa cung cấp email" : mainVM.userObj.email)
                                .font(AppTypography.callout())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        // Stats
                        HStack(spacing: 0) {
                            StatItem(value: "\(orderVM.totalOrders)", label: "Đơn hàng", icon: "bag.fill")
                            
                            Divider().frame(height: 30)
                            
                            StatItem(value: "\(favoritesVM.count)", label: "Yêu thích", icon: "heart.fill")
                        }
                        .padding(.vertical, AppSpacing.sm)
                        .background(AppColors.primarySurface)
                        .cornerRadius(AppRadius.md)
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    .padding(.top, .topInsets + AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.surface)
                    .cornerRadius(AppRadius.xxl, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: AppShadow.subtle.color, radius: AppShadow.subtle.radius, x: 0, y: 2)
                    
                    // Menu Options
                    VStack(spacing: 0) {
                        NavigationLink(destination: OrderHistoryView()) {
                            AccountRow(title: "Đơn hàng", icon: "bag")
                        }
                        
                        NavigationLink(destination: ProfileEditView()) {
                            AccountRow(title: "Thông tin cá nhân", icon: "person.text.rectangle")
                        }
                        
                        AccountRow(title: "Địa chỉ giao hàng", icon: "map")
                        AccountRow(title: "Phương thức thanh toán", icon: "creditcard")
                        AccountRow(title: "Mã khuyến mãi", icon: "ticket")
                        AccountRow(title: "Thông báo", icon: "bell")
                        AccountRow(title: "Trợ giúp", icon: "questionmark.circle")
                        
                        NavigationLink(destination: AboutView()) {
                            AccountRow(title: "Giới thiệu", icon: "info.circle")
                        }
                    }
                    .background(AppColors.surface)
                    .cornerRadius(AppRadius.lg)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.xl)
                    .shadow(color: AppShadow.subtle.color, radius: AppShadow.subtle.radius, x: 0, y: 2)
                    
                    // Log Out Button
                    Button {
                        showLogoutConfirm = true
                    } label: {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: AppIcons.logout)
                            Text("Đăng xuất")
                        }
                        .font(AppTypography.headline(.bold))
                        .foregroundColor(AppColors.error)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(AppColors.error.opacity(0.08))
                        .cornerRadius(AppRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.lg)
                                .stroke(AppColors.error.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.xxl)
                    .padding(.bottom, .bottomInsets + 120)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            orderVM.fetchOrders()
        }
        .confirmationDialog(
            "Đăng xuất",
            isPresented: $showLogoutConfirm,
            titleVisibility: .visible
        ) {
            Button("Đăng xuất", role: .destructive) {
                mainVM.signOut()
            }
            Button("Hủy", role: .cancel) { }
        } message: {
            Text("Bạn có chắc muốn đăng xuất khỏi tài khoản?")
        }
    }
}

// MARK: - Stat Item

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primary)
            Text(value)
                .font(AppTypography.title3(.bold))
                .foregroundColor(AppColors.textPrimary)
                .contentTransition(.numericText())
            Text(label)
                .font(AppTypography.caption(.medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
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
        .environmentObject(MainViewModel())
        .environmentObject(OrderViewModel())
        .environmentObject(FavoritesViewModel())
}
