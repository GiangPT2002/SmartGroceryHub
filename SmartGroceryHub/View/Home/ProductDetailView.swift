//
//  ProductDetailView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 20/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var cartVM = CartViewModel.shared
    
    var product: ProductModel
    @State private var qty: Int = 1
    @State private var showNutrition: Bool = false
    @State private var showDescription: Bool = true
    @State private var addedToCart: Bool = false
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: - Hero Image Section
                    ZStack(alignment: .topLeading) {
                        LinearGradient(
                            colors: [Color(hex: "F2F3F2"), Color(hex: "E8EBE8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 320)
                        .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                        
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
                                mode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primaryText)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(14)
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    isFavorite.toggle()
                                    FavoritesViewModel.shared.toggleFavorite(product: product)
                                }
                            } label: {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(isFavorite ? .red : .primaryText)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(14)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, .topInsets + 10)
                    }
                    
                    // MARK: - Product Info
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // Name & Unit
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(product.name)
                                    .font(.customfont(.bold, fontSize: 26))
                                    .foregroundColor(.primaryText)
                                
                                Text("\(product.unitValue) \(product.unitName)")
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(.secondaryText)
                            }
                            
                            Spacer()
                        }
                        
                        // Price Section
                        HStack(alignment: .bottom, spacing: 10) {
                            if product.isOffer, let offerPrice = product.offerPrice {
                                Text("\(offerPrice, specifier: "%.0f")đ")
                                    .font(.customfont(.bold, fontSize: 28))
                                    .foregroundColor(.primaryApp)
                                
                                Text("\(product.price, specifier: "%.0f")đ")
                                    .font(.customfont(.medium, fontSize: 18))
                                    .foregroundColor(.secondaryText)
                                    .strikethrough(color: .secondaryText)
                                
                                // Discount badge
                                let discount = Int(((product.price - offerPrice) / product.price) * 100)
                                Text("-\(discount)%")
                                    .font(.customfont(.bold, fontSize: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.85))
                                    .cornerRadius(8)
                            } else {
                                Text("\(product.price, specifier: "%.0f")đ")
                                    .font(.customfont(.bold, fontSize: 28))
                                    .foregroundColor(.primaryApp)
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        // Quantity Stepper
                        HStack {
                            Text("Số lượng")
                                .font(.customfont(.semibold, fontSize: 18))
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Button {
                                    if qty > 1 { qty -= 1 }
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(qty > 1 ? .primaryApp : .gray)
                                        .frame(width: 44, height: 44)
                                        .background(Color.white)
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                Text("\(qty)")
                                    .font(.customfont(.bold, fontSize: 20))
                                    .foregroundColor(.primaryText)
                                    .frame(minWidth: 35)
                                
                                Button {
                                    qty += 1
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.primaryApp)
                                        .cornerRadius(14)
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        // MARK: - Description Section
                        DisclosureGroup(isExpanded: $showDescription) {
                            Text(product.detail.isEmpty ? "Sản phẩm tươi ngon, chất lượng cao, được tuyển chọn kỹ lưỡng." : product.detail)
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundColor(.secondaryText)
                                .lineSpacing(4)
                                .padding(.top, 8)
                        } label: {
                            Text("Mô tả sản phẩm")
                                .font(.customfont(.semibold, fontSize: 18))
                                .foregroundColor(.primaryText)
                        }
                        .tint(.primaryText)
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        // MARK: - Nutrition Section
                        DisclosureGroup(isExpanded: $showNutrition) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    nutritionRow(label: "Khối lượng", value: product.nutritionWeight.isEmpty ? "N/A" : product.nutritionWeight)
                                    nutritionRow(label: "Đơn vị", value: "\(product.unitValue) \(product.unitName)")
                                    nutritionRow(label: "Đánh giá", value: "\(product.avgRating)/5 ⭐")
                                }
                                Spacer()
                            }
                            .padding(.top, 8)
                        } label: {
                            Text("Thông tin dinh dưỡng")
                                .font(.customfont(.semibold, fontSize: 18))
                                .foregroundColor(.primaryText)
                        }
                        .tint(.primaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                    .padding(.bottom, 120)
                }
            }
            
            // MARK: - Add to Cart Button
            VStack {
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        cartVM.addToCartWithQty(product: product, qty: qty)
                        addedToCart = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        addedToCart = false
                    }
                } label: {
                    HStack(spacing: 12) {
                        if addedToCart {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                            Text("Đã thêm vào giỏ!")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                            Text("Thêm vào giỏ")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            let unitPrice = product.offerPrice ?? product.price
                            Text("\(unitPrice * Double(qty), specifier: "%.0f")đ")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .padding(.horizontal, 20)
                    .background(addedToCart ? Color(hex: "2ECC71") : Color.primaryApp)
                    .cornerRadius(22)
                    .shadow(color: Color.primaryApp.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, .bottomInsets + 15)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear {
            isFavorite = FavoritesViewModel.shared.isFavorite(product: product)
        }
    }
    
    // MARK: - Helper Views
    
    private func nutritionRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.customfont(.medium, fontSize: 15))
                .foregroundColor(.secondaryText)
            Spacer()
            Text(value)
                .font(.customfont(.semibold, fontSize: 15))
                .foregroundColor(.primaryText)
        }
    }
}

#Preview {
    ProductDetailView(product: ProductModel(id: "preview_1", data: [
        "name": "Táo đỏ tươi nhập khẩu",
        "detail": "Táo đỏ được nhập khẩu từ New Zealand, giàu vitamin C và chất xơ. Thích hợp cho mọi lứa tuổi.",
        "unit_name": "kg",
        "unit_value": "1",
        "price": 85000,
        "offer_price": 69000,
        "is_offer": true,
        "nutrition_weight": "150g",
        "avg_rating": 4,
        "image": ""
    ]))
}
