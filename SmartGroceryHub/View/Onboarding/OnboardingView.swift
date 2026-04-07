//
//  OnboardingView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Mua sắm\nthông minh",
            subtitle: "Khám phá hàng ngàn sản phẩm tươi ngon\nvới giá tốt nhất mỗi ngày",
            icon: "cart.fill",
            gradient: [Color(hex: "53B175"), Color(hex: "43A065")]
        ),
        OnboardingPage(
            title: "Giao hàng\nnhanh chóng",
            subtitle: "Đặt hàng dễ dàng và nhận hàng\nnhanh chóng tận cửa nhà bạn",
            icon: "shippingbox.fill",
            gradient: [Color(hex: "F39C12"), Color(hex: "E67E22")]
        ),
        OnboardingPage(
            title: "Thanh toán\nan toàn",
            subtitle: "Thanh toán bảo mật với nhiều\nphương thức thanh toán tiện lợi",
            icon: "lock.shield.fill",
            gradient: [Color(hex: "3498DB"), Color(hex: "2980B9")]
        )
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: pages[currentPage].gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentPage)
            
            // Animated particles
            ForEach(0..<8, id: \.self) { index in
                FloatingParticle(index: index, color: .white.opacity(0.1))
            }
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Bỏ qua")
                            .font(AppTypography.callout(.semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.vertical, AppSpacing.xs)
                            .background(.ultraThinMaterial.opacity(0.3))
                            .cornerRadius(AppRadius.pill)
                    }
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.top, .topInsets + 10)
                
                Spacer()
                
                // Icon with rings
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.08))
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .fill(.white.opacity(0.12))
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .fill(.white.opacity(0.18))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: pages[currentPage].icon)
                        .font(.system(size: 45, weight: .medium))
                        .foregroundColor(.white)
                        .id("icon-\(currentPage)")
                        .transition(.scale.combined(with: .opacity))
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: currentPage)
                
                Spacer()
                    .frame(height: 50)
                
                // Content
                VStack(spacing: AppSpacing.md) {
                    Text(pages[currentPage].title)
                        .font(AppTypography.largeTitle(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .id("title-\(currentPage)")
                        .transition(.push(from: .trailing))
                    
                    Text(pages[currentPage].subtitle)
                        .font(AppTypography.body(.medium))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .id("subtitle-\(currentPage)")
                        .transition(.push(from: .trailing))
                }
                .padding(.horizontal, AppSpacing.xxl)
                .animation(.easeInOut(duration: 0.4), value: currentPage)
                
                Spacer()
                    .frame(height: 40)
                
                // Page dots
                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? .white : .white.opacity(0.4))
                            .frame(width: index == currentPage ? 28 : 10, height: 10)
                            .animation(AppAnimation.spring, value: currentPage)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
                
                // Action button
                Button {
                    AppHaptics.impact(.medium)
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.4)) { currentPage += 1 }
                    } else {
                        completeOnboarding()
                    }
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Text(currentPage < pages.count - 1 ? "Tiếp theo" : "Bắt đầu ngay")
                            .font(AppTypography.headline(.bold))
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .foregroundColor(pages[currentPage].gradient.first ?? AppColors.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .background(Color.white)
                    .cornerRadius(AppRadius.xl)
                    .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, AppSpacing.xxl)
                .padding(.bottom, .bottomInsets + 30)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        AppHaptics.selection()
                        withAnimation(.easeInOut(duration: 0.4)) { currentPage += 1 }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        AppHaptics.selection()
                        withAnimation(.easeInOut(duration: 0.4)) { currentPage -= 1 }
                    }
                }
        )
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func completeOnboarding() {
        AppHaptics.notification(.success)
        withAnimation(AppAnimation.smooth) {
            hasSeenOnboarding = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
}

// MARK: - Floating Particle

struct FloatingParticle: View {
    let index: Int
    let color: Color
    
    @State private var offset = CGPoint.zero
    @State private var scale: CGFloat = 1
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: CGFloat.random(in: 8...30), height: CGFloat.random(in: 8...30))
            .offset(x: offset.x, y: offset.y)
            .scaleEffect(scale)
            .onAppear {
                let startX = CGFloat.random(in: -200...200)
                let startY = CGFloat.random(in: -400...400)
                offset = CGPoint(x: startX, y: startY)
                
                withAnimation(
                    .easeInOut(duration: Double.random(in: 4...8))
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.3)
                ) {
                    offset = CGPoint(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    scale = CGFloat.random(in: 0.6...1.4)
                }
            }
    }
}

#Preview {
    OnboardingView()
}
