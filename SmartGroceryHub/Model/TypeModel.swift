//
//  TypeModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI

struct TypeModel: Identifiable, Equatable {
    
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var color: Color = Color.primaryApp
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["type_name"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.color = Color(hex: data["color"] as? String ?? "000000")
    }
    
    static func == (lhs: TypeModel, rhs: TypeModel) -> Bool {
        return lhs.id == rhs.id
    }
}
