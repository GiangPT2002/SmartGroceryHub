//
//  CategoryCell.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryCell: View {
    @State var tObj: TypeModel
    @State var color: Color = Color.yellow
    var didAddCart: ( ()->() )?
    
    var body: some View {
        HStack{
            
            WebImage(url: URL(string: tObj.image ))
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            
            Text(tObj.name)
                .font(.custom("Times New Roman", size: 16))
                .foregroundColor(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            
        }
        .padding(15)
        .frame(width: 250, height: 100)
        .background(tObj.color.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    CategoryCell(tObj: TypeModel(id: "preview_1", data: [
        "type_name": "Pulses",
        "image": "",
        "color": "F8A44C"
    ]))
}
