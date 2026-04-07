//
//  SignInView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct SignInView: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background Image
            Image("sign_in_top")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight * 0.55)
                .clipped()
            
            // Bottom Gradient Overlay for readability
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .frame(height: .screenHeight * 0.6)
            }
            
            // Content
            VStack {
                Spacer()
                
                VStack(spacing: AppSpacing.lg) {
                    
                    // Title
                    Text("Mua hàng cùng với\nSmart Grocery Hub")
                        .font(AppTypography.title1(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.bottom, AppSpacing.lg)
                    
                    // Email Sign In Button
                    NavigationLink {
                        LoginView()
                    } label: {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 18))
                            Text("Tiếp tục bằng Email")
                                .font(AppTypography.headline(.bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(AppColors.primary)
                        .cornerRadius(AppRadius.xl)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    // Registration Link
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Chưa có tài khoản? Đăng ký ngay")
                            .font(AppTypography.callout(.semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                    }
                    
                    // Divider
                    HStack(spacing: AppSpacing.md) {
                        Rectangle().fill(Color.white.opacity(0.3)).frame(height: 0.5)
                        Text("Hoặc đăng nhập với")
                            .font(AppTypography.footnote(.medium))
                            .foregroundColor(.white.opacity(0.8))
                        Rectangle().fill(Color.white.opacity(0.3)).frame(height: 0.5)
                    }
                    .padding(.vertical, AppSpacing.sm)
                    
                    // Social Buttons (Glassmorphism)
                    VStack(spacing: AppSpacing.sm) {
                        Button {
                            // Google Login
                        } label: {
                            HStack(spacing: AppSpacing.md) {
                                Image("google_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                Text("Tiếp tục với Google")
                                    .font(AppTypography.headline(.semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .glassMorphism(radius: AppRadius.xl)
                        }
                        
                        Button {
                            // Facebook Login
                        } label: {
                            HStack(spacing: AppSpacing.md) {
                                Image("fb_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                Text("Tiếp tục với Facebook")
                                    .font(AppTypography.headline(.semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .glassMorphism(radius: AppRadius.xl)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.xxl)
                .padding(.bottom, .bottomInsets + 40)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    SignInView()
}
