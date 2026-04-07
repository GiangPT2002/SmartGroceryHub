//
//  CategoryCell.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryCell: View {
    var tObj: TypeModel
    var didAddCart: (() -> ())?
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            WebImage(url: URL(string: tObj.image))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 65, height: 65)
                .padding(.leading, AppSpacing.md)
            
            Text(tObj.name)
                .font(AppTypography.headline(.bold))
                .foregroundColor(AppColors.textPrimary)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 240, height: 95)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(tObj.surfaceColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(tObj.borderColor, lineWidth: 1)
        )
        .shadow(color: tObj.color.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CategoryCell(tObj: TypeModel(id: "preview_1", data: [
        "type_name": "Trái cây nhập",
        "image": "",
        "color": "F8A44C"
    ]))
}
