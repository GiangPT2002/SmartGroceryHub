//
//  ExploreView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 24/2/25.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var expVM: ExploreViewModel
    @State private var showContent = false
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.background.ignoresSafeArea()
            
            if expVM.isLoading {
                // Skeleton Loading
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        ShimmerPlaceholder(width: 180, height: 28)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.lg)
                        
                        HStack(alignment: .top, spacing: AppSpacing.md) {
                            VStack(spacing: AppSpacing.md) {
                                CategorySkeleton(height: 250)
                                CategorySkeleton(height: 180)
                            }
                            VStack(spacing: AppSpacing.md) {
                                CategorySkeleton(height: 180)
                                CategorySkeleton(height: 250)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    .padding(.bottom, .bottomInsets + 120)
                }
                .safeAreaInset(edge: .top) { searchHeader }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text("Trải nghiệm")
                            .font(AppTypography.title2(.medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        GradientText("Khám phá mới", font: AppTypography.largeTitle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.sm)
                    
                    HStack(alignment: .top, spacing: AppSpacing.md) {
                        VStack(spacing: AppSpacing.md) {
                            ForEach(Array(expVM.leftColumnItems.enumerated()), id: \.element.id) { index, tObj in
                                ExploreCategoryCell(tObj: tObj, height: index % 2 == 0 ? 250 : 180)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 30)
                                    .animation(AppAnimation.stagger(index), value: showContent)
                            }
                        }
                        VStack(spacing: AppSpacing.md) {
                            ForEach(Array(expVM.rightColumnItems.enumerated()), id: \.element.id) { index, tObj in
                                ExploreCategoryCell(tObj: tObj, height: index % 2 == 0 ? 180 : 250)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 30)
                                    .animation(AppAnimation.stagger(index + 1), value: showContent)
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, .bottomInsets + 120)
                }
                .safeAreaInset(edge: .top) { searchHeader }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
    
    @ViewBuilder
    var searchHeader: some View {
        VStack {
            SearchTextField(placholder: "Bạn cần tìm gì hôm nay?", txt: $expVM.txtSearch)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
        }
        .floatingHeader()
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(ExploreViewModel())
    }
}
