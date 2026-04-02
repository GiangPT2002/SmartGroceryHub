//
//  CartView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct CartView: View {
    @StateObject var cartVM = CartViewModel.shared
    @State private var showCheckoutConfirm = false
    
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
                                CartItemRow(itemId: item.id)
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .slide.combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .padding(.bottom, 150)
                        .animation(.easeInOut(duration: 0.3), value: cartVM.cartItems.count)
                    }
                }
            }
            
            // Checkout Button
            if !cartVM.cartItems.isEmpty {
                VStack {
                    Spacer()
                    
                    // Item summary
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(cartVM.cartItems.count) sản phẩm")
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundColor(.secondaryText)
                            Spacer()
                            Text("Tổng cộng")
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundColor(.secondaryText)
                        }
                        
                        Button {
                            showCheckoutConfirm = true
                        } label: {
                            HStack {
                                Text("Thanh toán")
                                    .font(.customfont(.bold, fontSize: 18))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(cartVM.totalPrice, specifier: "%.0f")đ")
                                    .font(.customfont(.bold, fontSize: 16))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.primaryApp)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, .bottomInsets + 120)
                    .background(
                        Color.white
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -5)
                    )
                }
            }
        }
        .ignoresSafeArea()
        .alert("Xác nhận thanh toán", isPresented: $showCheckoutConfirm) {
            Button("Hủy", role: .cancel) { }
            Button("Thanh toán") {
                cartVM.checkout()
            }
        } message: {
            Text("Bạn có chắc muốn thanh toán \(cartVM.cartItems.count) sản phẩm với tổng \(cartVM.totalPrice, specifier: "%.0f")đ?")
        }
        .alert("Đặt hàng thành công! 🎉", isPresented: $cartVM.showCheckoutSuccess) {
            Button("OK") { }
        } message: {
            Text("Đơn hàng của bạn đã được ghi nhận. Bạn có thể theo dõi đơn hàng tại mục Tài khoản > Đơn hàng.")
        }
    }
}

#Preview {
    CartView()
}
