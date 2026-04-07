//
//  ProfileEditView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var mainVM: MainViewModel
    
    @State private var txtName: String = ""
    @State private var txtEmail: String = ""
    @State private var txtPhone: String = ""
    @State private var isSaving: Bool = false
    @State private var showSaved: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xl) {
                    
                    // Avatar Section
                    VStack(spacing: AppSpacing.sm) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primarySurface)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(AppColors.primary)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Circle()
                                .fill(AppColors.primary)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: AppShadow.subtle.color, radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.top, AppSpacing.xl)
                    
                    // Form
                    VStack(spacing: AppSpacing.lg) {
                        ModernTextField(title: "Họ và tên", placeholder: "Nhập họ và tên", text: $txtName, icon: "person")
                        ModernTextField(title: "Email", placeholder: "Nhập email", text: $txtEmail, icon: "envelope", keyboardType: .emailAddress, disabled: true)
                        ModernTextField(title: "Số điện thoại", placeholder: "Nhập số điện thoại", text: $txtPhone, icon: "phone", keyboardType: .phonePad)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Save Button
                    Button {
                        saveProfile()
                    } label: {
                        HStack(spacing: AppSpacing.xs) {
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                            }
                            Text(showSaved ? "Đã lưu ✓" : "Lưu thông tin")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(isLoading: isSaving))
                    .disabled(isSaving)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                }
                .padding(.bottom, AppSpacing.huge)
            }
        }
        .navigationTitle("Thông tin cá nhân")
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
            txtName = mainVM.userObj.username
            txtEmail = mainVM.userObj.email
            txtPhone = mainVM.userObj.phone
        }
    }
    
    private func saveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isSaving = true
        
        let data: [String: Any] = [
            "username": txtName,
            "phone": txtPhone,
            "updated_at": FieldValue.serverTimestamp()
        ]
        
        Firestore.firestore().collection("users").document(userId).setData(data, merge: true) { error in
            DispatchQueue.main.async {
                isSaving = false
                if error == nil {
                    mainVM.userObj.username = txtName
                    mainVM.userObj.phone = txtPhone
                    
                    withAnimation(AppAnimation.spring) {
                        showSaved = true
                    }
                    AppHaptics.notification(.success)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { showSaved = false }
                    }
                }
            }
        }
    }
}

// MARK: - Modern Text Field

struct ModernTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    var disabled: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppTypography.caption(.semibold))
                .foregroundColor(isFocused ? AppColors.primary : AppColors.textSecondary)
            
            HStack(spacing: AppSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isFocused ? AppColors.primary : AppColors.textTertiary)
                        .frame(width: 20)
                }
                
                TextField(placeholder, text: $text)
                    .font(AppTypography.body(.medium))
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .disabled(disabled)
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(height: 52)
            .background(
                disabled ? AppColors.surfaceSecondary.opacity(0.5) : AppColors.surface
            )
            .cornerRadius(AppRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(
                        isFocused ? AppColors.primary : AppColors.border,
                        lineWidth: isFocused ? 1.5 : 0.5
                    )
            )
            .animation(AppAnimation.quick, value: isFocused)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
            .environmentObject(MainViewModel())
    }
}
