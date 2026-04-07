//
//  OrderModel.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import FirebaseFirestore

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
            case .placed: return AppColors.info
            case .processing: return AppColors.warning
            case .shipping: return AppColors.accentDark
            case .delivered: return AppColors.success
            case .cancelled: return AppColors.error
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
        
        var progress: Double {
            switch self {
            case .placed: return 0.25
            case .processing: return 0.5
            case .shipping: return 0.75
            case .delivered: return 1.0
            case .cancelled: return 0
            }
        }
    }
    
    // MARK: - Computed Properties
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: createdAt)
    }
    
    var formattedPrice: String {
        "\(Int(totalPrice))đ"
    }
    
    var shortId: String {
        "#\(id.prefix(8).uppercased())"
    }
    
    var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
    
    // MARK: - Init
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.userId = data["user_id"] as? String ?? ""
        self.totalPrice = data["total_price"] as? Double ?? 0
        self.itemCount = data["item_count"] as? Int ?? 0
        
        if let statusStr = data["status"] as? String {
            self.status = OrderStatus(rawValue: statusStr) ?? .placed
        }
        
        if let timestamp = data["created_at"] as? Timestamp {
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
    
    var totalPrice: Double {
        price * Double(qty)
    }
    
    var formattedTotal: String {
        "\(Int(totalPrice))đ"
    }
    
    init(data: [String: Any]) {
        self.productName = data["name"] as? String ?? ""
        self.productImage = data["image"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0
        self.qty = data["qty"] as? Int ?? 1
    }
}
