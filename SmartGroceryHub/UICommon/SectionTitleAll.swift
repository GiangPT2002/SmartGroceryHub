//
//  SectionTitleAll.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI

struct SectionTitleAll: View {
    
    var title: String = "Title"
    var titleAll: String = "Xem tất cả"
    var icon: String? = nil
    var didTap: (() -> ())?
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.primaryGradient)
            }
            
            Text(title)
                .font(AppTypography.title2(.bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button {
                didTap?()
            } label: {
                HStack(spacing: 4) {
                    Text(titleAll)
                        .font(AppTypography.subheadline(.semibold))
                    Image(systemName: AppIcons.forward)
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(AppColors.primary)
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    SectionTitleAll(title: "Ưu đãi", icon: "flame.fill")
        .padding(20)
}
