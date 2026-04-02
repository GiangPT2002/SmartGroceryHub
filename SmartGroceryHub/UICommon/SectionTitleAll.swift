//
//  SectionTitleAll.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI

struct SectionTitleAll: View {
    
    @State var title: String = "Title"
    @State var titleAll: String = "Xem tất cả"
    var didTap: (()->())?
    
    var body: some View {
        
        HStack{
            Text(title)
                .font(.customfont(.semibold, fontSize: 24))
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Button {
                didTap?()
            } label: {
                Text(titleAll)
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundColor(.primaryApp)
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    SectionTitleAll()
        .padding(20)
}
