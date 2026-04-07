//
//  ExploreCategoryCell.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreCategoryCell: View {
    var tObj: TypeModel
    var height: CGFloat = 200
    
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
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.55)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Blur Label Container
            HStack {
                Text(tObj.name)
                    .font(AppTypography.headline(.bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                Spacer()
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .frame(height: height)
        .cornerRadius(AppRadius.xxl)
        .shadow(color: tObj.color.opacity(0.25), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    ExploreCategoryCell(tObj: TypeModel(id: "1", data: [
        "type_name": "Rau củ hữu cơ",
        "image": "",
        "color": "53B175"
    ]), height: 220)
    .padding(20)
}
