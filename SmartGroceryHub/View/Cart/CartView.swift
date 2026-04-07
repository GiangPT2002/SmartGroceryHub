//
//  CartView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    @State private var showCheckoutConfirm = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Text("Giỏ hàng của bạn")
                        .font(AppTypography.title2(.bold))
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
                .padding(.top, .topInsets)
                .padding(.bottom, AppSpacing.md)
                .background(AppColors.surface)
                .shadow(color: AppShadow.subtle.color, radius: AppShadow.subtle.radius, x: 0, y: 2)
                
                if cartVM.isEmpty {
                    // Empty State
                    Spacer()
                    VStack(spacing: AppSpacing.lg) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primarySurface)
                                .frame(width: 120, height: 120)
                            Image(systemName: "cart.badge.minus")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(AppColors.primary)
                        }
                        
                        Text("Giỏ hàng đang trống")
                            .font(AppTypography.title3(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Hãy thêm vài món đồ tươi ngon nhé!")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: AppSpacing.md) {
                            ForEach(cartVM.cartItems) { item in
                                CartItemRow(itemId: item.id)
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                                        removal: .move(edge: .trailing).combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.lg)
                        .padding(.bottom, 180)
                        .animation(AppAnimation.spring, value: cartVM.cartItems.count)
                    }
                }
            }
            
            // Checkout Bottom Bar
            if !cartVM.isEmpty {
                VStack {
                    Spacer()
                    
                    VStack(spacing: AppSpacing.sm) {
                        // Summary
                        HStack {
                            HStack(spacing: AppSpacing.xxs) {
                                Image(systemName: "bag")
                                    .font(.system(size: 14))
                                Text("\(cartVM.itemCount) sản phẩm")
                            }
                            .font(AppTypography.callout())
                            .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            Text("Tổng cộng")
                                .font(AppTypography.callout())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        // Checkout Button
                        Button {
                            AppHaptics.impact(.medium)
                            showCheckoutConfirm = true
                        } label: {
                            HStack {
                                Text("Thanh toán")
                                    .font(AppTypography.headline(.bold))
                                
                                Spacer()
                                
                                Text(cartVM.formattedTotal)
                                    .font(AppTypography.subheadline(.bold))
                                    .padding(.horizontal, AppSpacing.sm)
                                    .padding(.vertical, AppSpacing.xxs + 2)
                                    .background(Color.black.opacity(0.15))
                                    .cornerRadius(AppRadius.sm)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, AppSpacing.lg)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(AppColors.primaryGradient)
                            .cornerRadius(AppRadius.xl)
                            .shadow(color: AppShadow.colored.color, radius: AppShadow.colored.radius, x: 0, y: AppShadow.colored.y)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, .bottomInsets + 120)
                    .background(
                        AppColors.surface
                            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
                    )
                }
            }
        }
        .ignoresSafeArea()
        .alert("Xác nhận thanh toán", isPresented: $showCheckoutConfirm) {
            Button("Hủy", role: .cancel) { }
            Button("Thanh toán") {
                cartVM.checkout(orderVM: orderVM)
            }
        } message: {
            Text("Bạn có chắc muốn thanh toán \(cartVM.itemCount) sản phẩm với tổng \(cartVM.formattedTotal)?")
        }
        .alert("Đặt hàng thành công! 🎉", isPresented: $cartVM.showCheckoutSuccess) {
            Button("OK") { }
        } message: {
            Text("Đơn hàng của bạn đã được ghi nhận. Bạn có thể theo dõi tại mục Tài khoản > Đơn hàng.")
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
        .environmentObject(OrderViewModel())
}
