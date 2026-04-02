//
//  ProductModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 14/3/25.
//

import SwiftUI

struct ProductModel: Identifiable, Equatable {
    var id: String = ""
    var catId: String = ""
    var brandId: String = ""
    var typeId: String = ""
    var detail: String = ""
    var name: String = ""
    var unitName: String = ""
    var unitValue: String = ""
    var nutritionWeight: String = ""
    var image: String = ""
    var catName: String = ""
    var typeName: String = ""
    var offerPrice: Double?
    var price: Double = 0
    var isOffer: Bool = false
    var isBestSell: Bool = false
    var isFav: Bool = false
    var avgRating: Int = 0

    init(id: String, data: [String: Any]) {
        self.id = id
        self.catId = data["cat_id"] as? String ?? ""
        self.brandId = data["brand_id"] as? String ?? ""
        self.typeId = data["type_id"] as? String ?? ""
        self.detail = data["detail"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.unitName = data["unit_name"] as? String ?? ""
        self.unitValue = data["unit_value"] as? String ?? ""
        self.nutritionWeight = data["nutrition_weight"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.catName = data["cat_name"] as? String ?? ""
        self.typeName = data["type_name"] as? String ?? ""
        self.offerPrice = data["offer_price"] as? Double
        self.price = data["price"] as? Double ?? 0
        self.isOffer = data["is_offer"] as? Bool ?? false
        self.isBestSell = data["is_best_sell"] as? Bool ?? false
        self.isFav = data["is_fav"] as? Bool ?? false
        self.avgRating = data["avg_rating"] as? Int ?? 0
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
}
