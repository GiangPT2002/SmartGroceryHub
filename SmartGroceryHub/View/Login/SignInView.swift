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
                
                VStack(spacing: 20) {
                    
                    // Title
                    Text("Mua hàng cùng với\nSmart Grocery Hub")
                        .font(.customfont(.bold, fontSize: 32))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 20)
                    
                    // Email Sign In Button
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Tiếp tục bằng Email")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.primaryApp)
                            .cornerRadius(20)
                            .shadow(color: Color.primaryApp.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    // Registration Link
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Chưa có tài khoản? Đăng ký ngay")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                    }
                    
                    // Divider
                    HStack(spacing: 15) {
                        Rectangle().fill(Color.white.opacity(0.3)).frame(height: 1)
                        Text("Hoặc đăng nhập với")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Rectangle().fill(Color.white.opacity(0.3)).frame(height: 1)
                    }
                    .padding(.vertical, 15)
                    
                    // Social Buttons (Glassmorphism)
                    VStack(spacing: 15) {
                        Button {
                            // Google Login
                        } label: {
                            HStack(spacing: 15) {
                                Image("google_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Google")
                                    .font(.customfont(.semibold, fontSize: 18))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(.ultraThinMaterial) // Apple native glassmorphism
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        }
                        
                        Button {
                            // Facebook Login
                        } label: {
                            HStack(spacing: 15) {
                                Image("fb_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Facebook")
                                    .font(.customfont(.semibold, fontSize: 18))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        }
                    }
                }
                .padding(.horizontal, 30)
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

