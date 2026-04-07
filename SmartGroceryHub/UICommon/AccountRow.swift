//
//  AccountRow.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct AccountRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.primary)
                .frame(width: 36, height: 36)
                .background(AppColors.primarySurface)
                .cornerRadius(AppRadius.xs)
            
            Text(title)
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Image(systemName: AppIcons.forward)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(.vertical, AppSpacing.md)
        .padding(.horizontal, AppSpacing.lg)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(AppColors.divider),
            alignment: .bottom
        )
    }
}

#Preview {
    AccountRow(title: "Đơn hàng của tôi", icon: "bag")
        .padding()
}
