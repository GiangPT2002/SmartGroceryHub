//
//  AboutView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xxl) {
                    
                    // App Icon & Name
                    VStack(spacing: AppSpacing.md) {
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(AppRadius.lg)
                            .shadow(color: AppShadow.elevated.color, radius: AppShadow.elevated.radius, x: 0, y: 4)
                        
                        Text("Smart Grocery Hub")
                            .font(AppTypography.title1(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Phiên bản 2.0.0")
                            .font(AppTypography.callout(.medium))
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.xxs)
                            .background(AppColors.surfaceSecondary)
                            .cornerRadius(AppRadius.pill)
                    }
                    .padding(.top, AppSpacing.xxl)
                    
                    // Features
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Tính năng nổi bật")
                            .font(AppTypography.title3(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        FeatureRow(icon: "cart.fill", title: "Mua sắm thông minh", description: "Tìm kiếm và đặt hàng nhanh chóng", color: AppColors.primary)
                        FeatureRow(icon: "bolt.fill", title: "Giao hàng nhanh", description: "Nhận hàng tận nơi trong vài giờ", color: AppColors.accent)
                        FeatureRow(icon: "lock.shield.fill", title: "Bảo mật cao", description: "Dữ liệu được mã hóa an toàn", color: AppColors.info)
                        FeatureRow(icon: "heart.fill", title: "Cá nhân hóa", description: "Gợi ý sản phẩm theo sở thích", color: AppColors.error)
                    }
                    .padding(AppSpacing.lg)
                    .background(AppColors.surface)
                    .cornerRadius(AppRadius.lg)
                    .shadow(color: AppShadow.subtle.color, radius: AppShadow.subtle.radius, x: 0, y: 2)
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Developer Info
                    VStack(spacing: AppSpacing.md) {
                        Text("Phát triển bởi")
                            .font(AppTypography.callout(.medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("Phạm Trường Giang")
                            .font(AppTypography.title2(.bold))
                            .foregroundStyle(AppColors.primaryGradient)
                        
                        Text("© 2025 - 2026 Smart Grocery Hub")
                            .font(AppTypography.caption(.medium))
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .padding(.bottom, AppSpacing.huge)
                }
            }
        }
        .navigationTitle("Giới thiệu")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: AppIcons.back)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .cornerRadius(AppRadius.sm)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTypography.subheadline(.bold))
                    .foregroundColor(AppColors.textPrimary)
                Text(description)
                    .font(AppTypography.footnote(.medium))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
