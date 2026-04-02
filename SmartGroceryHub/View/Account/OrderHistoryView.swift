//
//  OrderHistoryView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderHistoryView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var orderVM = OrderViewModel.shared
    
    var body: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Đơn hàng")
                        .font(.customfont(.bold, fontSize: 22))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 25, height: 25) // Balance spacer
                }
                .padding(.top, .topInsets + 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                
                if orderVM.isLoading && orderVM.orders.isEmpty {
                    Spacer()
                    ProgressView("Đang tải đơn hàng...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else if orderVM.orders.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "bag")
                            .font(.system(size: 80))
                            .foregroundColor(.placeholder)
                        
                        Text("Chưa có đơn hàng")
                            .font(.customfont(.bold, fontSize: 22))
                            .foregroundColor(.primaryText)
                        
                        Text("Đơn hàng của bạn sẽ xuất hiện ở đây\nsau khi bạn mua sắm!")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(orderVM.orders) { order in
                                OrderCard(order: order)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            orderVM.fetchOrders()
        }
    }
}

// MARK: - Order Card

struct OrderCard: View {
    var order: OrderModel
    @State private var isExpanded = false
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy HH:mm"
        f.locale = Locale(identifier: "vi_VN")
        return f
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Order header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Đơn #\(order.id.prefix(8).uppercased())")
                        .font(.customfont(.bold, fontSize: 16))
                        .foregroundColor(.primaryText)
                    
                    Text(dateFormatter.string(from: order.createdAt))
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                // Status badge
                HStack(spacing: 5) {
                    Image(systemName: order.status.icon)
                        .font(.system(size: 12, weight: .semibold))
                    Text(order.status.rawValue)
                        .font(.customfont(.semibold, fontSize: 12))
                }
                .foregroundColor(order.status.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(order.status.color.opacity(0.1))
                .cornerRadius(10)
            }
            
            Divider()
            
            // Order summary
            HStack {
                Text("\(order.itemCount) sản phẩm")
                    .font(.customfont(.medium, fontSize: 15))
                    .foregroundColor(.secondaryText)
                
                Spacer()
                
                Text("\(order.totalPrice, specifier: "%.0f")đ")
                    .font(.customfont(.bold, fontSize: 18))
                    .foregroundColor(.primaryApp)
            }
            
            // Expandable items list
            if isExpanded && !order.items.isEmpty {
                VStack(spacing: 10) {
                    ForEach(order.items) { item in
                        HStack(spacing: 12) {
                            WebImage(url: URL(string: item.productImage))
                                .resizable()
                                .indicator(.activity)
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.productName)
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(.primaryText)
                                    .lineLimit(1)
                                Text("x\(item.qty)")
                                    .font(.customfont(.medium, fontSize: 13))
                                    .foregroundColor(.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text("\(item.price * Double(item.qty), specifier: "%.0f")đ")
                                .font(.customfont(.semibold, fontSize: 14))
                                .foregroundColor(.primaryText)
                        }
                    }
                }
                .padding(.top, 5)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Expand/Collapse button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Spacer()
                    Text(isExpanded ? "Thu gọn" : "Xem chi tiết")
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.primaryApp)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primaryApp)
                    Spacer()
                }
                .padding(.top, 5)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    OrderHistoryView()
}
