//
//  SearchTextField.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 6/3/25.
//

import SwiftUI

struct SearchTextField: View {
   
    var placholder: String = "Tìm kiếm"
    @Binding var txt: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
           
            Image(systemName: AppIcons.search)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isFocused ? AppColors.primary : AppColors.textTertiary)
           
            TextField(placholder, text: $txt)
                .font(AppTypography.body(.medium))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isFocused)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            // Clear button
            if !txt.isEmpty {
                Button {
                    withAnimation(AppAnimation.quick) {
                        txt = ""
                    }
                    AppHaptics.impact(.light)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textTertiary)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(height: 38)
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.surfaceSecondary)
        .cornerRadius(AppRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .stroke(isFocused ? AppColors.primary.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
        .animation(AppAnimation.quick, value: isFocused)
        .animation(AppAnimation.quick, value: txt.isEmpty)
    }
}

struct SearchTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        SearchTextField(placholder: "Tìm kiếm sản phẩm", txt: $txt)
            .padding(15)
    }
}
