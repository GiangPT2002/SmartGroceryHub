//
//  ProductCell.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCell: View {
    
    @State var pObj: ProductModel
    var didAddCart: ( ()->() )?
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            WebImage(url: URL(string: pObj.image ))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 100, height: 90)
                .padding(.top, 15)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(pObj.name)
                    .font(.customfont(.bold, fontSize: 16))
                    .foregroundColor(.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(pObj.unitValue) \(pObj.unitName)")
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.secondaryText)
            }
            .padding(.horizontal, 15)
            
            Spacer()
            
            HStack {
                Text("\(pObj.offerPrice ?? pObj.price, specifier: "%.0f")đ")
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Button {
                    didAddCart?()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.primaryApp)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            
        }
        .frame(width: 170, height: 240)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ProductCell(pObj: ProductModel(id: "preview_1", data: [
        "name": "Táo đỏ tươi",
        "detail": "Apples contain key nutrients.",
        "unit_name": "kg",
        "unit_value": "1",
        "price": 45000,
        "image": "https://www.apple.com/v/apple-fresh/a/images/meta/oh-snap_overview__c92c4o82rtmu_og.png"
    ]))
    .padding()
    .background(Color(hex: "F9F9F9"))
}
