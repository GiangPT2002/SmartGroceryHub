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
    var didAddCart: ( ()->() )?
    
    var body: some View {
        HStack(spacing: 15) {
            
            WebImage(url: URL(string: tObj.image ))
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 70, height: 70)
                .padding(.leading, 15)
            
            Text(tObj.name)
                .font(.customfont(.bold, fontSize: 18))
                .foregroundColor(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(width: 250, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(tObj.color.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(tObj.color.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    CategoryCell(tObj: TypeModel(id: "preview_1", data: [
        "type_name": "Trái cây nhập",
        "image": "https://www.apple.com/v/apple-fresh/a/images/meta/oh-snap_overview__c92c4o82rtmu_og.png",
        "color": "F8A44C"
    ]))
}
