//
//  AccountRow.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct AccountRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryText)
                .frame(width: 25)
            
            Text(title)
                .font(.customfont(.semibold, fontSize: 18))
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.secondaryText)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1)),
            alignment: .bottom
        )
    }
}

#Preview {
    AccountRow(title: "Đơn hàng của tôi", icon: "bag")
        .padding()
}
