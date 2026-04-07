//
//  ShimmerView.swift
//  SmartGroceryHub
//
//  Skeleton loading placeholder components.
//

import SwiftUI

// MARK: - Shimmer Placeholder Shape

struct ShimmerPlaceholder: View {
    var width: CGFloat? = nil
    var height: CGFloat = 16
    var radius: CGFloat = AppRadius.xs
    
    @State private var phase: CGFloat = -1
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(Color(hex: "E8E8E8"))
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.5), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: phase * geo.size.width)
                }
                .mask(RoundedRectangle(cornerRadius: radius))
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1.5
                }
            }
    }
}

// MARK: - Product Cell Skeleton

struct ProductCellSkeleton: View {
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            ShimmerPlaceholder(height: 90, radius: AppRadius.md)
                .padding(.top, AppSpacing.md)
                .padding(.horizontal, AppSpacing.lg)
            
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                ShimmerPlaceholder(height: 14)
                ShimmerPlaceholder(width: 80, height: 12)
            }
            .padding(.horizontal, AppSpacing.md)
            
            Spacer()
            
            HStack {
                ShimmerPlaceholder(width: 60, height: 18)
                Spacer()
                ShimmerPlaceholder(width: 40, height: 40, radius: AppRadius.md)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.md)
        }
        .frame(width: 170, height: 250)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadow.subtle.color, radius: AppShadow.subtle.radius, x: 0, y: 2)
    }
}

// MARK: - Category Skeleton

struct CategorySkeleton: View {
    var height: CGFloat = 200
    
    var body: some View {
        ShimmerPlaceholder(height: height, radius: AppRadius.xxl)
    }
}

// MARK: - Cart Item Skeleton

struct CartItemSkeleton: View {
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ShimmerPlaceholder(width: 80, height: 80, radius: AppRadius.md)
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                ShimmerPlaceholder(height: 16)
                ShimmerPlaceholder(width: 80, height: 12)
                HStack {
                    ShimmerPlaceholder(width: 100, height: 35, radius: AppRadius.sm)
                    Spacer()
                    ShimmerPlaceholder(width: 60, height: 18)
                }
            }
        }
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 15) {
            ProductCellSkeleton()
            ProductCellSkeleton()
        }
        CartItemSkeleton()
            .padding(.horizontal, 20)
    }
    .padding()
    .background(AppColors.background)
}
