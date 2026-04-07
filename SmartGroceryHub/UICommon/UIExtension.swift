//
//  UIExtension.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 9/2/25.
//

import SwiftUI

enum Gilroy: String {
    case regular = "Gilroy-Regular"
    case medium = "Gilroy-Medium"
    case semibold = "Gilroy-SemiBold"
    case bold = "Gilroy-Bold"
}

extension Font {
    
    static func customfont(_ font: Gilroy, fontSize: CGFloat) -> Font {
        custom(font.rawValue, size: fontSize)
    }
}

extension CGFloat {
    
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }
    
    static var topInsets: Double {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }
    
    static var bottomInsets: Double {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
    static var horizontalInsets: Double {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return 0 }
        return window.safeAreaInsets.left + window.safeAreaInsets.right
    }
    
    static var verticalInsets: Double {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return 0 }
        return window.safeAreaInsets.top + window.safeAreaInsets.bottom
    }
}

extension Color {
    
    static var primaryApp: Color { AppColors.primary }
    static var primaryText: Color { AppColors.textPrimary }
    static var secondaryText: Color { AppColors.textSecondary }
    static var textTitle: Color { AppColors.textSecondary }
    static var placeholder: Color { AppColors.textTertiary }
    static var darkGray: Color { Color(hex: "4C4F4D") }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3:
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6:
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8:
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ShowButton: ViewModifier {
    @Binding var isShow: Bool
    
    public func body(content: Content) -> some View {
        
        HStack {
            content
            Button {
                isShow.toggle()
            } label: {
                Image(systemName: !isShow ? "eye.fill" : "eye.slash.fill" )
                    .foregroundColor(.textTitle)
            }

        }
    }
}
