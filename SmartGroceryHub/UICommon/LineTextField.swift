//
//  LineTextField.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 11/2/25.
//

import SwiftUI

struct LineTextField: View {
    var title: String = "Title"
    var placholder: String = "Placholder"
    @Binding var txt: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(title)
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.textSecondary)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            TextField(placholder, text: $txt)
                .font(AppTypography.body(.medium))
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: 40)
            
            Divider()
        }
    }
}

struct LineSecureField: View {
    var title: String = "Title"
    var placholder: String = "Placholder"
    @Binding var txt: String
    @Binding var isShowPassword: Bool
    
    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(title)
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.textSecondary)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            if isShowPassword {
                TextField(placholder, text: $txt)
                    .font(AppTypography.body(.medium))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .modifier(ShowButton(isShow: $isShowPassword))
                    .frame(height: 40)
            } else {
                SecureField(placholder, text: $txt)
                    .font(AppTypography.body(.medium))
                    .autocapitalization(.none)
                    .modifier(ShowButton(isShow: $isShowPassword))
                    .frame(height: 40)
            }
            Divider()
        }
    }
}

struct LineTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        LineTextField(txt: $txt)
            .padding(20)
    }
}
