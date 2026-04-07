//
//  CartItemModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct CartItemModel: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var product: ProductModel
    var qty: Int = 1
    
    static func == (lhs: CartItemModel, rhs: CartItemModel) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}
