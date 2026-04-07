//
//  ToastView.swift
//  SmartGroceryHub
//
//  Non-intrusive toast notification overlay.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var icon: String = "checkmark.circle.fill"
    var color: Color = AppColors.success
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(message)
                .font(AppTypography.callout(.semibold))
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(color.opacity(0.3), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 5)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, 10)
    }
}

#Preview {
    VStack(spacing: 15) {
        ToastView(message: "Đã thêm vào giỏ hàng!", icon: "cart.fill", color: AppColors.success)
        ToastView(message: "Đã xoá khỏi danh sách yêu thích", icon: "heart.slash.fill", color: AppColors.error)
    }
    .padding(.top, 50)
    .background(AppColors.background)
}
