//
//  FavoritesView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesView: View {
    @StateObject var favVM = FavoritesViewModel.shared
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Text("Yêu thích")
                        .font(.customfont(.bold, fontSize: 24))
                        .foregroundColor(.primaryText)
                    Spacer()
                }
                .padding(.top, .topInsets + 10)
                .padding(.bottom, 15)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea(.all, edges: .top)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                )
                
                if favVM.isLoading && favVM.favoriteItems.isEmpty {
                    Spacer()
                    ProgressView("Đang tải...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else if favVM.favoriteItems.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 80))
                            .foregroundColor(.placeholder)
                        
                        Text("Chưa có yêu thích")
                            .font(.customfont(.bold, fontSize: 22))
                            .foregroundColor(.primaryText)
                        
                        Text("Hãy khám phá và thêm sản phẩm\nyêu thích của bạn!")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(favVM.favoriteItems) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    FavoriteProductCard(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
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
    @State private var isRemoving = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                WebImage(url: URL(string: product.image))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 100, height: 90)
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity)
                
                // Remove favorite button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        FavoritesViewModel.shared.removeFavorite(product: product)
                    }
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
                .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.customfont(.bold, fontSize: 15))
                    .foregroundColor(.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(product.unitValue) \(product.unitName)")
                    .font(.customfont(.medium, fontSize: 13))
                    .foregroundColor(.secondaryText)
            }
            .padding(.horizontal, 12)
            
            Spacer()
            
            HStack {
                Text("\(product.offerPrice ?? product.price, specifier: "%.0f")đ")
                    .font(.customfont(.semibold, fontSize: 17))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Button {
                    CartViewModel.shared.addToCart(product: product)
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.primaryApp)
                        .cornerRadius(13)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(height: 230)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        FavoritesView()
    }
}
