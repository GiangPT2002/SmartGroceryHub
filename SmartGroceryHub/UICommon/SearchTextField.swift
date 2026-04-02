//
//  SearchTextField.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 6/3/25.
//

import SwiftUI

struct SearchTextField: View {
   
    @State var placholder: String = "Tìm kiếm"
    @Binding var txt: String
    
    var body: some View {
        HStack(spacing: 15) {
           
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.placeholder)
           
            TextField(placholder, text: $txt)
                .font(.customfont(.semibold, fontSize: 16))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(height: 35)
        .padding(15)
        .background(Color(hex: "F2F3F2"))
        .cornerRadius(18)
    }
}

struct SearchTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        SearchTextField(placholder: "Tìm kiếm sản phẩm", txt: $txt)
            .padding(15)
    }
}
