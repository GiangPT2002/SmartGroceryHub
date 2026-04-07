//
//  WelcomeView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 9/2/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Image("man")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight)
            
            // Gradient overlay
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            VStack {
                Spacer()
                
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(AppAnimation.smooth.delay(0.2), value: showContent)
                    .padding(.bottom, AppSpacing.xs)
                
                Text("Xin Chào\nquý khách")
                    .font(AppTypography.largeTitle(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(AppAnimation.smooth.delay(0.4), value: showContent)
                
                Text("Sự hài lòng của quý khách là niềm vui của chúng tôi")
                    .font(AppTypography.body(.medium))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, AppSpacing.lg)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(AppAnimation.smooth.delay(0.6), value: showContent)
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Bắt đầu")
                        .font(AppTypography.headline(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(AppColors.primary)
                        .cornerRadius(AppRadius.xl)
                        .shadow(color: AppColors.primary.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                .animation(AppAnimation.smooth.delay(0.8), value: showContent)
                
                Spacer().frame(height: 80)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear {
            withAnimation { showContent = true }
        }
    }
}

#Preview {
    WelcomeView()
}
