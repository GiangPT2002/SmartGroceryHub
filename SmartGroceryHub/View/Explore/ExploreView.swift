//
//  ExploreView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 24/2/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var expVM = ExploreViewModel.shared
    
    var leftColumnItems: [TypeModel] {
        let filtered = expVM.typeArr.filter { expVM.txtSearch.isEmpty ? true : $0.name.lowercased().contains(expVM.txtSearch.lowercased()) }
        return stride(from: 0, to: filtered.count, by: 2).map { filtered[$0] }
    }
    
    var rightColumnItems: [TypeModel] {
        let filtered = expVM.typeArr.filter { expVM.txtSearch.isEmpty ? true : $0.name.lowercased().contains(expVM.txtSearch.lowercased()) }
        return stride(from: 1, to: filtered.count, by: 2).map { filtered[$0] }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            if expVM.isLoading {
                ProgressView("Đang tải dữ liệu...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Trải nghiệm")
                            .font(.customfont(.medium, fontSize: 22))
                            .foregroundColor(.secondaryText)
                        
                        Text("Khám phá mới")
                            .font(.customfont(.bold, fontSize: 34))
                            .foregroundColor(.primaryApp)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20) // Normal padding, no topInsets manual space needed
                    .padding(.bottom, 10)
                    
                    HStack(alignment: .top, spacing: 15) {
                        VStack(spacing: 15) {
                            ForEach(Array(leftColumnItems.enumerated()), id: \.element.id) { index, tObj in
                                ExploreCategoryCell(tObj: tObj, height: index % 2 == 0 ? 250 : 180)
                            }
                        }
                        VStack(spacing: 15) {
                            ForEach(Array(rightColumnItems.enumerated()), id: \.element.id) { index, tObj in
                                ExploreCategoryCell(tObj: tObj, height: index % 2 == 0 ? 180 : 250)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, .bottomInsets + 120)
                }
                .safeAreaInset(edge: .top) {
                    VStack {
                        SearchTextField(placholder: "Bạn cần tìm gì hôm nay?", txt: $expVM.txtSearch)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                    }
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea(.all, edges: .top)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                    )
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

#Preview {
    NavigationView {
        ExploreView()
    }
}
