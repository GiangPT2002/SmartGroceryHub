//
//  OrderHistoryView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI

struct OrderHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var orderVM: OrderViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if orderVM.isLoading && orderVM.isEmpty {
                VStack {
                    Spacer()
                    LoadingDots()
                    Spacer()
                }
            } else if orderVM.isEmpty {
                VStack(spacing: AppSpacing.lg) {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(AppColors.primarySurface)
                            .frame(width: 120, height: 120)
                        Image(systemName: "bag.badge.questionmark")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(AppColors.primary)
                    }
                    
                    Text("Chưa có đơn hàng nào")
                        .font(AppTypography.title3(.bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Hãy mua sắm để có đơn hàng đầu tiên!")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: AppSpacing.md) {
                        ForEach(orderVM.orders) { order in
                            OrderCard(order: order)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.lg)
                }
            }
        }
        .navigationTitle("Đơn hàng")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: AppIcons.back)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
        .onAppear {
            orderVM.fetchOrders()
        }
    }
}

// MARK: - Order Card

struct OrderCard: View {
    let order: OrderModel
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(AppAnimation.spring) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: AppSpacing.md) {
                    // Status Icon
                    ZStack {
                        Circle()
                            .fill(order.status.color.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: order.status.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(order.status.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.shortId)
                            .font(AppTypography.subheadline(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(order.formattedDate)
                            .font(AppTypography.caption(.medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(order.formattedPrice)
                            .font(AppTypography.headline(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(order.status.rawValue)
                            .font(AppTypography.caption(.semibold))
                            .foregroundColor(order.status.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(order.status.color.opacity(0.12))
                            .cornerRadius(AppRadius.xs)
                    }
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            .padding(AppSpacing.md)
            
            // Expandable Detail
            if isExpanded {
                Divider().padding(.horizontal, AppSpacing.md)
                
                // Progress Bar
                VStack(spacing: AppSpacing.sm) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(AppColors.surfaceSecondary)
                                .frame(height: 6)
                            
                            Capsule()
                                .fill(order.status.color)
                                .frame(width: geo.size.width * order.status.progress, height: 6)
                                .animation(AppAnimation.smooth, value: order.status)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.top, AppSpacing.sm)
                }
                
                // Items
                VStack(spacing: AppSpacing.xs) {
                    ForEach(order.items) { item in
                        HStack(spacing: AppSpacing.sm) {
                            Text(item.productName)
                                .font(AppTypography.subheadline())
                                .foregroundColor(AppColors.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("x\(item.qty)")
                                .font(AppTypography.footnote(.semibold))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text(item.formattedTotal)
                                .font(AppTypography.subheadline(.semibold))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(minWidth: 60, alignment: .trailing)
                        }
                    }
                }
                .padding(AppSpacing.md)
            }
        }
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
        OrderHistoryView()
            .environmentObject(OrderViewModel())
    }
}
