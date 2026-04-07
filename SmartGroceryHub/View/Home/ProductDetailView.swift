//
//  ProductDetailView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 20/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var appState: AppState
    
    var product: ProductModel
    @State private var qty: Int = 1
    @State private var showNutrition: Bool = false
    @State private var showDescription: Bool = true
    @State private var addedToCart: Bool = false
    @State private var isFavorite: Bool = false
    @State private var imageOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: - Hero Image Section
                    ZStack(alignment: .topLeading) {
                        LinearGradient(
                            colors: [AppColors.surfaceSecondary, AppColors.background],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 320)
                        .cornerRadius(AppRadius.xxl, corners: [.bottomLeft, .bottomRight])
                        
                        WebImage(url: URL(string: product.image))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .padding(.top, 80)
                        
                        // Navigation buttons
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: AppIcons.back)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(width: 44, height: 44)
                                    .glassMorphism(radius: AppRadius.md)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: AppSpacing.sm) {
                                Button {
                                    // Share
                                } label: {
                                    Image(systemName: AppIcons.share)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.textPrimary)
                                        .frame(width: 44, height: 44)
                                        .glassMorphism(radius: AppRadius.md)
                                }
                                
                                Button {
                                    withAnimation(AppAnimation.bouncy) {
                                        isFavorite.toggle()
                                        favoritesVM.toggleFavorite(product: product)
                                    }
                                } label: {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(isFavorite ? AppColors.error : AppColors.textPrimary)
                                        .frame(width: 44, height: 44)
                                        .glassMorphism(radius: AppRadius.md)
                                        .scaleEffect(isFavorite ? 1.1 : 1.0)
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, .topInsets + 10)
                    }
                    
                    // MARK: - Product Info
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        
                        // Name & Rating
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text(product.name)
                                    .font(AppTypography.title1(.bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text(product.unitLabel)
                                    .font(AppTypography.body())
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Rating
                            if product.avgRating > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: AppIcons.star)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.accent)
                                    Text("\(product.avgRating)")
                                        .font(AppTypography.subheadline(.bold))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xxs + 2)
                                .background(AppColors.accentLight)
                                .cornerRadius(AppRadius.pill)
                            }
                        }
                        
                        // Price Section
                        HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                            if product.hasDiscount, let offerPrice = product.offerPrice {
                                Text("\(Int(offerPrice))đ")
                                    .font(AppTypography.title1(.bold))
                                    .foregroundColor(AppColors.primary)
                                
                                Text(product.formattedOriginalPrice)
                                    .font(AppTypography.body())
                                    .foregroundColor(AppColors.textTertiary)
                                    .strikethrough(color: AppColors.textTertiary)
                                
                                if let discount = product.discountPercentage {
                                    Text("-\(discount)%")
                                        .font(AppTypography.caption(.bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, AppSpacing.sm)
                                        .padding(.vertical, AppSpacing.xxs)
                                        .background(AppColors.error.opacity(0.85))
                                        .cornerRadius(AppRadius.xs)
                                }
                            } else {
                                Text(product.formattedPrice)
                                    .font(AppTypography.title1(.bold))
                                    .foregroundColor(AppColors.primary)
                            }
                            
                            Spacer()
                        }
                        
                        Divider().padding(.vertical, AppSpacing.xxs)
                        
                        // Quantity Stepper
                        HStack {
                            Text("Số lượng")
                                .font(AppTypography.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            HStack(spacing: AppSpacing.lg) {
                                Button {
                                    if qty > 1 {
                                        AppHaptics.impact(.light)
                                        withAnimation(AppAnimation.quick) { qty -= 1 }
                                    }
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(qty > 1 ? AppColors.primary : AppColors.textTertiary)
                                        .frame(width: 40, height: 40)
                                        .background(AppColors.surface)
                                        .cornerRadius(AppRadius.sm)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.sm)
                                                .stroke(AppColors.border, lineWidth: 1)
                                        )
                                }
                                
                                Text("\(qty)")
                                    .font(AppTypography.title3(.bold))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(minWidth: 32)
                                    .contentTransition(.numericText())
                                
                                Button {
                                    AppHaptics.impact(.light)
                                    withAnimation(AppAnimation.quick) { qty += 1 }
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(AppColors.primary)
                                        .cornerRadius(AppRadius.sm)
                                        .shadow(color: AppColors.primary.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        
                        Divider().padding(.vertical, AppSpacing.xxs)
                        
                        // Description
                        DisclosureGroup(isExpanded: $showDescription) {
                            Text(product.detail.isEmpty ? "Sản phẩm tươi ngon, chất lượng cao, được tuyển chọn kỹ lưỡng." : product.detail)
                                .font(AppTypography.callout())
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(4)
                                .padding(.top, AppSpacing.xs)
                        } label: {
                            Text("Mô tả sản phẩm")
                                .font(AppTypography.headline())
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .tint(AppColors.textPrimary)
                        
                        Divider().padding(.vertical, AppSpacing.xxs)
                        
                        // Nutrition
                        DisclosureGroup(isExpanded: $showNutrition) {
                            VStack(spacing: AppSpacing.sm) {
                                nutritionRow(label: "Khối lượng", value: product.nutritionWeight.isEmpty ? "N/A" : product.nutritionWeight)
                                nutritionRow(label: "Đơn vị", value: product.unitLabel)
                                nutritionRow(label: "Đánh giá", value: "\(product.avgRating)/5 ⭐")
                            }
                            .padding(.top, AppSpacing.xs)
                        } label: {
                            Text("Thông tin dinh dưỡng")
                                .font(AppTypography.headline())
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .tint(AppColors.textPrimary)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.xl)
                    .padding(.bottom, 130)
                }
            }
            
            // MARK: - Add to Cart Button
            VStack {
                Spacer()
                
                Button {
                    withAnimation(AppAnimation.bouncy) {
                        cartVM.addToCartWithQty(product: product, qty: qty)
                        addedToCart = true
                        appState.showToast("Đã thêm \(qty) sản phẩm vào giỏ!", icon: "cart.fill.badge.plus")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { addedToCart = false }
                    }
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        if addedToCart {
                            Image(systemName: AppIcons.success)
                                .font(.system(size: 22))
                            Text("Đã thêm vào giỏ!")
                                .font(AppTypography.headline(.bold))
                        } else {
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 20))
                            Text("Thêm vào giỏ")
                                .font(AppTypography.headline(.bold))
                            
                            Spacer()
                            
                            let unitPrice = product.displayPrice
                            Text("\(Int(unitPrice * Double(qty)))đ")
                                .font(AppTypography.subheadline(.bold))
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xxs + 2)
                                .background(Color.black.opacity(0.15))
                                .cornerRadius(AppRadius.sm)
                                .contentTransition(.numericText())
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(.horizontal, AppSpacing.lg)
                    .background(
                        addedToCart
                        ? AppColors.success
                        : AppColors.primary
                    )
                    .cornerRadius(AppRadius.xl)
                    .shadow(
                        color: (addedToCart ? AppColors.success : AppColors.primary).opacity(0.35),
                        radius: 12, x: 0, y: 6
                    )
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, .bottomInsets + 15)
            }
            .background(
                LinearGradient(
                    colors: [AppColors.background.opacity(0), AppColors.background],
                    startPoint: .top, endPoint: .center
                )
                .frame(height: 100)
                .allowsHitTesting(false),
                alignment: .top
            )
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear {
            isFavorite = favoritesVM.isFavorite(product: product)
        }
    }
    
    // MARK: - Helper Views
    
    private func nutritionRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(AppTypography.callout(.semibold))
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

#Preview {
    ProductDetailView(product: ProductModel(id: "preview_1", data: [
        "name": "Táo đỏ tươi nhập khẩu",
        "detail": "Táo đỏ được nhập khẩu từ New Zealand, giàu vitamin C và chất xơ.",
        "unit_name": "kg",
        "unit_value": "1",
        "price": 85000,
        "offer_price": 69000,
        "is_offer": true,
        "nutrition_weight": "150g",
        "avg_rating": 4,
        "image": ""
    ]))
    .environmentObject(CartViewModel())
    .environmentObject(FavoritesViewModel())
    .environmentObject(AppState())
}
