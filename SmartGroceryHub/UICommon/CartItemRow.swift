//
//  CartItemRow.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartItemRow: View {
    @ObservedObject var cartVM = CartViewModel.shared
    var itemId: String
    
    private var item: CartItemModel? {
        cartVM.cartItems.first(where: { $0.id == itemId })
    }
    
    var body: some View {
        if let item = item {
            HStack(spacing: 15) {
                WebImage(url: URL(string: item.product.image))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(item.product.name)
                            .font(.customfont(.bold, fontSize: 16))
                            .foregroundColor(.primaryText)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                cartVM.removeFromCart(item: item)
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .frame(width: 30, height: 30)
                        }
                    }
                    
                    Text("\(item.product.unitValue) \(item.product.unitName)")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.secondaryText)
                    
                    HStack {
                        // Quantity Controller
                        HStack(spacing: 15) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    cartVM.decreaseQty(item: item)
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(item.qty > 1 ? .primaryApp : .gray)
                                    .frame(width: 35, height: 35)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            Text("\(item.qty)")
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(.primaryText)
                                .frame(minWidth: 25)
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    cartVM.increaseQty(item: item)
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                                    .background(Color.primaryApp)
                                    .cornerRadius(12)
                            }
                        }
                        
                        Spacer()
                        
                        // Total price for this item (unit price × qty)
                        let unitPrice = item.product.offerPrice ?? item.product.price
                        Text("\(unitPrice * Double(item.qty), specifier: "%.0f")đ")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.primaryText)
                    }
                    .padding(.top, 5)
                }
            }
            .padding(15)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
        }
    }
}
