//
//  SignUpView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 18/2/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        ZStack {
            Image("bottom_bg")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom, AppSpacing.xs)
                    
                    Text("Đăng ký")
                        .font(AppTypography.largeTitle(.bold))
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.bottom, AppSpacing.xxs)
                    
                    Text("Nhập thông tin cá nhân của bạn")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.bottom, AppSpacing.xxl)
                    
                    LineTextField(title: "Họ và tên", placholder: "Nhập họ và tên của bạn", txt: $mainVM.txtUsername)
                        .padding(.bottom, AppSpacing.xl)
                    
                    LineTextField(title: "Email", placholder: "Nhập email của bạn", txt: $mainVM.txtEmail, keyboardType: .emailAddress)
                        .padding(.bottom, AppSpacing.xl)
                    
                    LineSecureField(title: "Mật khẩu", placholder: "Nhập mật khẩu của bạn", txt: $mainVM.txtPassword, isShowPassword: $mainVM.isShowPassword)
                        .padding(.bottom, AppSpacing.sm)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text("Để tiếp tục, bạn đồng ý với")
                            .font(AppTypography.callout())
                            .foregroundColor(AppColors.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 0) {
                            Text("Điều khoản dịch vụ")
                                .font(AppTypography.subheadline(.medium))
                                .foregroundColor(AppColors.primary)
                            Text(" và ")
                                .font(AppTypography.subheadline(.medium))
                                .foregroundColor(AppColors.textSecondary)
                            Text("Chính sách bảo mật.")
                                .font(AppTypography.subheadline(.medium))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.bottom, AppSpacing.lg)
                    
                    Button {
                        mainVM.serviceCallSignUp()
                    } label: {
                        Text("Đăng ký")
                    }
                    .buttonStyle(PrimaryButtonStyle(isLoading: mainVM.isLoading))
                    .disabled(mainVM.isLoading)
                    .padding(.bottom, AppSpacing.lg)
                    
                    NavigationLink {
                        LoginView()
                    } label: {
                        HStack {
                            Text("Bạn đã có tài khoản?")
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textPrimary)
                            Text("Đăng nhập")
                                .font(AppTypography.body(.semibold))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, .topInsets + 64)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, .bottomInsets)
            }
            
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
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    SignUpView()
        .environmentObject(MainViewModel())
}
