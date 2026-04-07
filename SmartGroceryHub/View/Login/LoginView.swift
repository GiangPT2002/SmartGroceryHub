//
//  LoginView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 11/2/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        ZStack {
            Image("bottom_bg")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight)
            
            VStack {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .padding(.bottom, AppSpacing.xs)
                
                Text("Đăng nhập")
                    .font(AppTypography.largeTitle(.bold))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.bottom, AppSpacing.xxs)
                
                Text("Nhập Email và mật khẩu của bạn")
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.bottom, AppSpacing.xxl)
                
                LineTextField(title: "Email", placholder: "Nhập email của bạn", txt: $mainVM.txtEmail, keyboardType: .emailAddress)
                    .padding(.bottom, AppSpacing.xl)
                
                LineSecureField(title: "Mật khẩu", placholder: "Nhập mật khẩu của bạn", txt: $mainVM.txtPassword, isShowPassword: $mainVM.isShowPassword)
                    .padding(.bottom, AppSpacing.sm)
                
                Button { } label: {
                    Text("Bạn quên mật khẩu?")
                        .font(AppTypography.callout(.medium))
                        .foregroundColor(AppColors.textPrimary)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, AppSpacing.lg)
                
                Button {
                    mainVM.serviceCallLogin()
                } label: {
                    Text("Đăng nhập")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: mainVM.isLoading))
                .disabled(mainVM.isLoading)
                .padding(.bottom, AppSpacing.lg)
                
                NavigationLink {
                    SignUpView()
                } label: {
                    HStack {
                        Text("Bạn chưa có tài khoản?")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textPrimary)
                        Text("Đăng ký")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.primary)
                    }
                }
                
                Spacer()
            }
            .padding(.top, .topInsets + 64)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, .bottomInsets)
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: AppIcons.back)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.surface.opacity(0.8))
                            .cornerRadius(AppRadius.sm)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, AppSpacing.lg)
        }
        .alert(isPresented: $mainVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(mainVM.errorMessage), dismissButton: .default(Text("OK")))
        }
        .background(Color.white)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
        .environmentObject(MainViewModel())
}
