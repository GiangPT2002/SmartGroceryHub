//
//  CartView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct CartView: View {
    @StateObject var cartVM = CartViewModel.shared
    
    var body: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Text("Giỏ hàng của bạn")
                        .font(.customfont(.bold, fontSize: 24))
                        .foregroundColor(.primaryText)
                    Spacer()
                }
                .padding(.top, .topInsets)
                .padding(.bottom, 15)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                
                if cartVM.cartItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.badge.minus")
                            .font(.system(size: 80))
                            .foregroundColor(.placeholder)
                        Text("Giỏ hàng đang trống")
                            .font(.customfont(.bold, fontSize: 20))
                            .foregroundColor(.primaryText)
                        Text("Hãy thêm vài món đồ tươi ngon nhé!")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.secondaryText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(cartVM.cartItems) { item in
                                CartItemRow(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .padding(.bottom, 120) // Space for checkout button
                    }
                }
            }
            
            // Checkout Button
            if !cartVM.cartItems.isEmpty {
                VStack {
                    Spacer()
                    Button {
                        cartVM.checkout()
                    } label: {
                        HStack {
                            Text("Thanh toán")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(cartVM.totalPrice, specifier: "%.0f")đ")
                                .font(.customfont(.bold, fontSize: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.primaryApp)
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, .bottomInsets + 120)
                }
            }
        }
        .ignoresSafeArea()
        .alert(isPresented: $cartVM.showCheckoutSuccess) {
            Alert(title: Text("Thành công"), message: Text("Đơn hàng của bạn đã được đặt thành công!"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    CartView()
}
