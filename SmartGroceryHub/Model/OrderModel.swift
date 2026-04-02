//
//  OrderModel.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI

struct OrderModel: Identifiable {
    var id: String = UUID().uuidString
    var userId: String = ""
    var items: [OrderItemData] = []
    var totalPrice: Double = 0
    var status: OrderStatus = .placed
    var createdAt: Date = Date()
    var itemCount: Int = 0
    
    enum OrderStatus: String {
        case placed = "Đã đặt hàng"
        case processing = "Đang xử lý"
        case shipping = "Đang giao"
        case delivered = "Đã giao"
        case cancelled = "Đã hủy"
        
        var color: Color {
            switch self {
            case .placed: return Color(hex: "3498DB")
            case .processing: return Color(hex: "F39C12")
            case .shipping: return Color(hex: "E67E22")
            case .delivered: return Color(hex: "27AE60")
            case .cancelled: return Color(hex: "E74C3C")
            }
        }
        
        var icon: String {
            switch self {
            case .placed: return "checkmark.circle"
            case .processing: return "gearshape.2"
            case .shipping: return "shippingbox"
            case .delivered: return "checkmark.seal.fill"
            case .cancelled: return "xmark.circle"
            }
        }
    }
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.userId = data["user_id"] as? String ?? ""
        self.totalPrice = data["total_price"] as? Double ?? 0
        self.itemCount = data["item_count"] as? Int ?? 0
        
        if let statusStr = data["status"] as? String {
            self.status = OrderStatus(rawValue: statusStr) ?? .placed
        }
        
        if let timestamp = data["created_at"] as? FirebaseFirestore.Timestamp {
            self.createdAt = timestamp.dateValue()
        }
        
        if let itemsData = data["items"] as? [[String: Any]] {
            self.items = itemsData.map { OrderItemData(data: $0) }
        }
    }
}

struct OrderItemData: Identifiable {
    var id: String = UUID().uuidString
    var productName: String = ""
    var productImage: String = ""
    var price: Double = 0
    var qty: Int = 1
    
    init(data: [String: Any]) {
        self.productName = data["name"] as? String ?? ""
        self.productImage = data["image"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0
        self.qty = data["qty"] as? Int ?? 1
    }
}

import FirebaseFirestore
