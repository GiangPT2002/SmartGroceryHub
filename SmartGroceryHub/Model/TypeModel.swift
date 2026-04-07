//
//  TypeModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI

struct TypeModel: Identifiable, Equatable, Hashable {
    
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var color: Color = AppColors.primary
    
    // MARK: - Computed Properties
    
    var gradientColors: [Color] {
        [color.opacity(0.8), color]
    }
    
    var surfaceColor: Color {
        color.opacity(0.12)
    }
    
    var borderColor: Color {
        color.opacity(0.4)
    }
    
    // MARK: - Init from Firestore
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["type_name"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.color = Color(hex: data["color"] as? String ?? "53B175")
    }
    
    // MARK: - Equatable & Hashable
    
    static func == (lhs: TypeModel, rhs: TypeModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
