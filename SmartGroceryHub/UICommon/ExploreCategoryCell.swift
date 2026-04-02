//
//  ExploreCategoryCell.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreCategoryCell: View {
    @State var tObj: TypeModel
    var height: CGFloat = 200 // Dynamic height for masonry effect
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            WebImage(url: URL(string: tObj.image))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: height)
                .clipped()
            
            // Gradient Overlay for text readability
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]), startPoint: .center, endPoint: .bottom)
            
            // Blur Label Container
            HStack {
                Text(tObj.name)
                    .font(.customfont(.bold, fontSize: 18))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                Spacer()
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .frame(height: height)
        .cornerRadius(25)
        .shadow(color: tObj.color.opacity(0.3), radius: 10, x: 0, y: 8)
    }
}

#Preview {
    ExploreCategoryCell(tObj: TypeModel(id: "1", data: [
        "type_name": "Rau củ hữu cơ",
        "image": "https://www.apple.com/v/apple-fresh/a/images/meta/oh-snap_overview__c92c4o82rtmu_og.png",
        "color": "53B175"
    ]), height: 220)
    .padding(20)
}
