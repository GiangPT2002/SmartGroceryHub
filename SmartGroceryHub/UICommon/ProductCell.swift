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
    var didAddCart: ( ()->() )?
    @State private var showAddedFeedback = false
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            // Tappable area for navigation (everything except the + button)
            NavigationLink(destination: ProductDetailView(product: pObj)) {
                VStack(spacing: 8) {
                    WebImage(url: URL(string: pObj.image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: 100, height: 90)
                        .padding(.top, 15)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(pObj.name)
                            .font(.customfont(.bold, fontSize: 16))
                            .foregroundColor(.primaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(pObj.unitValue) \(pObj.unitName)")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.horizontal, 15)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if pObj.isOffer, let offerPrice = pObj.offerPrice {
                        Text("\(offerPrice, specifier: "%.0f")đ")
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundColor(.primaryApp)
                        Text("\(pObj.price, specifier: "%.0f")đ")
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundColor(.secondaryText)
                            .strikethrough(color: .secondaryText)
                    } else {
                        Text("\(pObj.price, specifier: "%.0f")đ")
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundColor(.primaryText)
                    }
                }
                
                Spacer()
                
                // Add to cart button — NOT inside NavigationLink
                Button {
                    didAddCart?()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        showAddedFeedback = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        showAddedFeedback = false
                    }
                } label: {
                    Image(systemName: showAddedFeedback ? "checkmark" : "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(showAddedFeedback ? Color(hex: "27AE60") : Color.primaryApp)
                        .cornerRadius(15)
                        .scaleEffect(showAddedFeedback ? 1.15 : 1.0)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            
        }
        .frame(width: 170, height: 250)
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
    ProductCell(pObj: ProductModel(id: "preview_1", data: [
        "name": "Táo đỏ tươi",
        "detail": "Apples contain key nutrients.",
        "unit_name": "kg",
        "unit_value": "1",
        "price": 45000,
        "image": ""
    ]))
    .padding()
    .background(Color(hex: "F9F9F9"))
}
