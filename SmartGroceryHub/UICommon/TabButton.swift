//
//  TabButton.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct TabButton: View {
    
    @State var title: String = "Title"
    @State var icon: String = "store_tab"
    var isSelect: Bool = false
    var animation: Namespace.ID
    var didSelect: (()->())
    
    var body: some View {
        Button{
            didSelect()
        } label: {
            VStack(spacing: 5) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelect ? .white : .secondaryText) 
                
                if !isSelect {
                    Text(title)
                        .font(.customfont(.semibold, fontSize: 12))
                        .foregroundColor(.secondaryText)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                ZStack {
                    if isSelect {
                        Capsule()
                            .fill(Color.primaryApp)
                            .matchedGeometryEffect(id: "TAB_INDICATOR", in: animation)
                    }
                }
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .scaleEffect(isSelect ? 1.05 : 1.0)
        .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5), value: isSelect)
    }
}
