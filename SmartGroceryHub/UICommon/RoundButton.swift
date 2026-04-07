//
//  RoundButton.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 10/2/25.
//

import SwiftUI

struct RoundButton: View {
    var title: String = "Tittle"
    var didTap: (() -> ())?
    
    var body: some View {
        Button {
            AppHaptics.impact(.medium)
            didTap?()
        } label: {
            Text(title)
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    RoundButton()
        .padding(.horizontal, 20)
}
