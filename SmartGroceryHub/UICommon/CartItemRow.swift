//
//  CartItemRow.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartItemRow: View {
    @EnvironmentObject var cartVM: CartViewModel
    var itemId: String
    
    private var item: CartItemModel? {
        cartVM.cartItems.first(where: { $0.id == itemId })
    }
    
    var body: some View {
        if let item = item {
            HStack(spacing: AppSpacing.md) {
                // Product image
                WebImage(url: URL(string: item.product.image))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .background(AppColors.surfaceSecondary)
                    .cornerRadius(AppRadius.md)
                
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    HStack {
                        Text(item.product.name)
                            .font(AppTypography.subheadline(.bold))
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(AppAnimation.spring) {
                                cartVM.removeFromCart(item: item)
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppColors.textTertiary)
                                .frame(width: 28, height: 28)
                                .background(AppColors.surfaceSecondary)
                                .cornerRadius(AppRadius.xs)
                        }
                    }
                    
                    Text(item.product.unitLabel)
                        .font(AppTypography.footnote())
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack {
                        // Quantity Controller
                        HStack(spacing: AppSpacing.sm) {
                            Button {
                                withAnimation(AppAnimation.quick) {
                                    cartVM.decreaseQty(item: item)
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(item.qty > 1 ? AppColors.primary : AppColors.textTertiary)
                                    .frame(width: 32, height: 32)
                                    .background(AppColors.surface)
                                    .cornerRadius(AppRadius.sm)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.sm)
                                            .stroke(AppColors.border, lineWidth: 1)
                                    )
                            }
                            
                            Text("\(item.qty)")
                                .font(AppTypography.callout(.bold))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(minWidth: 24)
                                .contentTransition(.numericText())
                            
                            Button {
                                withAnimation(AppAnimation.quick) {
                                    cartVM.increaseQty(item: item)
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(AppColors.primary)
                                    .cornerRadius(AppRadius.sm)
                            }
                        }
                        
                        Spacer()
                        
                        // Total price for this item
                        let unitPrice = item.product.displayPrice
                        Text("\(Int(unitPrice * Double(item.qty)))đ")
                            .font(AppTypography.headline(.bold))
                            .foregroundColor(AppColors.textPrimary)
                            .contentTransition(.numericText())
                    }
                    .padding(.top, AppSpacing.xxs)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppRadius.lg)
            .shadow(color: AppShadow.card.color, radius: AppShadow.card.radius, x: 0, y: AppShadow.card.y)
        }
    }
}
