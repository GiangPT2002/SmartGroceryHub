//
//  ProductCell.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCell: View {
    
    var pObj: ProductModel
    var didAddCart: (() -> ())?
    @State private var showAddedFeedback = false
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            
            // Tappable area for navigation
            NavigationLink(destination: ProductDetailView(product: pObj)) {
                VStack(spacing: AppSpacing.xs) {
                    ZStack(alignment: .topLeading) {
                        WebImage(url: URL(string: pObj.image))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: 100, height: 90)
                            .padding(.top, AppSpacing.md)
                        
                        // Discount badge
                        if let discount = pObj.discountPercentage {
                            Text("-\(discount)%")
                                .font(AppTypography.caption(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.error.opacity(0.9))
                                .cornerRadius(AppRadius.xs)
                                .padding(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer(minLength: 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pObj.name)
                            .font(AppTypography.subheadline(.bold))
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(pObj.unitLabel)
                            .font(AppTypography.footnote())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer(minLength: 0)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if pObj.hasDiscount {
                        Text(pObj.formattedPrice)
                            .font(AppTypography.headline(.bold))
                            .foregroundColor(AppColors.primary)
                        Text(pObj.formattedOriginalPrice)
                            .font(AppTypography.caption(.medium))
                            .foregroundColor(AppColors.textTertiary)
                            .strikethrough(color: AppColors.textTertiary)
                    } else {
                        Text(pObj.formattedPrice)
                            .font(AppTypography.headline(.bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                
                Spacer()
                
                // Add to cart button
                Button {
                    didAddCart?()
                    withAnimation(AppAnimation.bouncy) {
                        showAddedFeedback = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation { showAddedFeedback = false }
                    }
                } label: {
                    Image(systemName: showAddedFeedback ? "checkmark" : "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(
                            showAddedFeedback
                            ? AppColors.success
                            : AppColors.primary
                        )
                        .cornerRadius(AppRadius.md)
                        .scaleEffect(showAddedFeedback ? 1.15 : 1.0)
                        .shadow(
                            color: (showAddedFeedback ? AppColors.success : AppColors.primary).opacity(0.3),
                            radius: 6, x: 0, y: 3
                        )
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.md)
        }
        .frame(width: 170, height: 250)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadow.card.color, radius: AppShadow.card.radius, x: 0, y: AppShadow.card.y)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.border.opacity(0.5), lineWidth: 0.5)
        )
    }
}

#Preview {
    ProductCell(pObj: ProductModel(id: "preview_1", data: [
        "name": "Táo đỏ tươi",
        "detail": "Apples contain key nutrients.",
        "unit_name": "kg",
        "unit_value": "1",
        "price": 45000,
        "offer_price": 35000,
        "is_offer": true,
        "image": ""
    ]))
    .padding()
    .background(AppColors.background)
}
