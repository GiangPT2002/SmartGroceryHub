//
//  FavoritesView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favVM: FavoritesViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var appState: AppState
    
    let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Text("Yêu thích")
                        .font(AppTypography.title2(.bold))
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    
                    // Count badge
                    if !favVM.isEmpty {
                        Text("\(favVM.count)")
                            .font(AppTypography.caption(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.primary)
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, .topInsets + 10)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)
                .floatingHeader()
                
                if favVM.isLoading && favVM.isEmpty {
                    Spacer()
                    LoadingDots()
                    Spacer()
                } else if favVM.isEmpty {
                    Spacer()
                    VStack(spacing: AppSpacing.lg) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "FFE5E5"))
                                .frame(width: 120, height: 120)
                            Image(systemName: "heart.slash")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(AppColors.error)
                        }
                        
                        Text("Chưa có yêu thích")
                            .font(AppTypography.title3(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Hãy khám phá và thêm sản phẩm\nyêu thích của bạn!")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                            ForEach(favVM.favoriteItems) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    FavoriteProductCard(product: product)
                                }
                                .buttonStyle(PressableStyle())
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)
                        .padding(.bottom, .bottomInsets + 120)
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

// MARK: - Favorite Product Card

struct FavoriteProductCard: View {
    var product: ProductModel
    @EnvironmentObject var favVM: FavoritesViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            ZStack(alignment: .topTrailing) {
                WebImage(url: URL(string: product.image))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 100, height: 90)
                    .padding(.top, AppSpacing.md)
                    .frame(maxWidth: .infinity)
                
                // Remove favorite button
                Button {
                    withAnimation(AppAnimation.bouncy) {
                        favVM.removeFavorite(product: product)
                    }
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.error)
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(AppRadius.xs)
                }
                .padding(AppSpacing.sm)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(AppTypography.subheadline(.bold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(product.unitLabel)
                    .font(AppTypography.caption(.medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, AppSpacing.sm)
            
            Spacer(minLength: 0)
            
            HStack {
                Text(product.formattedPrice)
                    .font(AppTypography.headline(.bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button {
                    cartVM.addToCart(product: product)
                    appState.showToast("Đã thêm vào giỏ hàng!", icon: "cart.fill.badge.plus")
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(AppColors.primary)
                        .cornerRadius(AppRadius.sm)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, AppSpacing.sm)
            .padding(.bottom, AppSpacing.sm)
        }
        .frame(height: 230)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadow.card.color, radius: AppShadow.card.radius, x: 0, y: AppShadow.card.y)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.border.opacity(0.3), lineWidth: 0.5)
        )
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .environmentObject(FavoritesViewModel())
            .environmentObject(CartViewModel())
            .environmentObject(AppState())
    }
}
