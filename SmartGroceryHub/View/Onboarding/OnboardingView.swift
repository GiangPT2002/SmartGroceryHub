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
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Bỏ qua")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial.opacity(0.3))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, .topInsets + 10)
                
                Spacer()
                
                // Icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 180, height: 180)
                    
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: pages[currentPage].icon)
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(.white)
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: currentPage)
                
                Spacer()
                    .frame(height: 50)
                
                // Content
                VStack(spacing: 15) {
                    Text(pages[currentPage].title)
                        .font(.customfont(.bold, fontSize: 36))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(pages[currentPage].subtitle)
                        .font(.customfont(.medium, fontSize: 17))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                    .frame(height: 50)
                
                // Page dots
                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? .white : .white.opacity(0.4))
                            .frame(width: index == currentPage ? 28 : 10, height: 10)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
                
                // Action button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        completeOnboarding()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text(currentPage < pages.count - 1 ? "Tiếp theo" : "Bắt đầu ngay")
                            .font(.customfont(.bold, fontSize: 20))
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .foregroundColor(pages[currentPage].gradient.first ?? .primaryApp)
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, .bottomInsets + 30)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation { currentPage -= 1 }
                    }
                }
        )
    }
    
    private func completeOnboarding() {
        withAnimation {
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

#Preview {
    OnboardingView()
}
