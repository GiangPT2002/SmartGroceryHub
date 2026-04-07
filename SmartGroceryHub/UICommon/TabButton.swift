//
//  TabButton.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang.
//

import SwiftUI

struct TabButton: View {
    
    var title: String = "Title"
    var icon: String = "store_tab"
    var systemIcon: String? = nil
    var isSelect: Bool = false
    var badgeCount: Int = 0
    var animation: Namespace.ID
    var didSelect: (() -> ())
    
    var body: some View {
        Button {
            AppHaptics.selection()
            didSelect()
        } label: {
            VStack(spacing: 4) {
                Group {
                    if let systemIcon = systemIcon {
                        Image(systemName: systemIcon)
                            .font(.system(size: 20, weight: isSelect ? .bold : .medium))
                            .scaleEffect(isSelect ? 1.1 : 1.0)
                    } else {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                }
                .foregroundColor(isSelect ? .white : AppColors.textSecondary)
                .appBadge(badgeCount)
                
                if !isSelect {
                    Text(title)
                        .font(AppTypography.caption(.semibold))
                        .foregroundColor(AppColors.textSecondary)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, isSelect ? 20 : 12)
            .background(
                ZStack {
                    if isSelect {
                        Capsule()
                            .fill(AppColors.primaryGradient)
                            .matchedGeometryEffect(id: "TAB_INDICATOR", in: animation)
                            .shadow(color: AppColors.primary.opacity(0.4), radius: 8, x: 0, y: 3)
                    }
                }
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .scaleEffect(isSelect ? 1.05 : 1.0)
        .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.65, blendDuration: 0.4), value: isSelect)
    }
}
