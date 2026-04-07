//
//  DesignSystem.swift
//  SmartGroceryHub
//
//  Design tokens & system for the entire application.
//

import SwiftUI

// MARK: - Color Palette

enum AppColors {
    // Primary
    static let primary = Color(hex: "53B175")
    static let primaryDark = Color(hex: "3D8A59")
    static let primaryLight = Color(hex: "7BC89A")
    static let primarySurface = Color(hex: "E8F5EE")
    
    // Accent
    static let accent = Color(hex: "F39C12")
    static let accentDark = Color(hex: "E67E22")
    static let accentLight = Color(hex: "FDEBD0")
    
    // Semantic
    static let success = Color(hex: "27AE60")
    static let warning = Color(hex: "F39C12")
    static let error = Color(hex: "E74C3C")
    static let info = Color(hex: "3498DB")
    
    // Neutrals
    static let background = Color(hex: "F7F8FC")
    static let surface = Color.white
    static let surfaceSecondary = Color(hex: "F2F3F2")
    static let border = Color(hex: "E2E2E2")
    static let divider = Color(hex: "F0F0F0")
    
    // Text
    static let textPrimary = Color(hex: "181725")
    static let textSecondary = Color(hex: "7C7C7C")
    static let textTertiary = Color(hex: "B1B1B1")
    static let textOnPrimary = Color.white
    
    // Gradient Presets
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "53B175"), Color(hex: "43A065")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let warmGradient = LinearGradient(
        colors: [Color(hex: "F39C12"), Color(hex: "E67E22")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let coolGradient = LinearGradient(
        colors: [Color(hex: "3498DB"), Color(hex: "2980B9")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let sunsetGradient = LinearGradient(
        colors: [Color(hex: "F2994A"), Color(hex: "F2C94C")],
        startPoint: .leading, endPoint: .trailing
    )
    static let heroGradient = LinearGradient(
        colors: [Color(hex: "53B175").opacity(0.0), Color(hex: "53B175").opacity(0.08)],
        startPoint: .top, endPoint: .bottom
    )
}

// MARK: - Typography

enum AppTypography {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
        .custom("Gilroy-Bold", size: 34)
    }
    static func title1(_ weight: Gilroy = .bold) -> Font {
        .custom(weight.rawValue, size: 28)
    }
    static func title2(_ weight: Gilroy = .bold) -> Font {
        .custom(weight.rawValue, size: 24)
    }
    static func title3(_ weight: Gilroy = .semibold) -> Font {
        .custom(weight.rawValue, size: 20)
    }
    static func headline(_ weight: Gilroy = .semibold) -> Font {
        .custom(weight.rawValue, size: 18)
    }
    static func body(_ weight: Gilroy = .medium) -> Font {
        .custom(weight.rawValue, size: 16)
    }
    static func callout(_ weight: Gilroy = .medium) -> Font {
        .custom(weight.rawValue, size: 15)
    }
    static func subheadline(_ weight: Gilroy = .medium) -> Font {
        .custom(weight.rawValue, size: 14)
    }
    static func footnote(_ weight: Gilroy = .medium) -> Font {
        .custom(weight.rawValue, size: 13)
    }
    static func caption(_ weight: Gilroy = .regular) -> Font {
        .custom(weight.rawValue, size: 12)
    }
    static func price(_ weight: Gilroy = .bold) -> Font {
        .custom(weight.rawValue, size: 22)
    }
}

// MARK: - Spacing

enum AppSpacing {
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
    static let huge: CGFloat = 64
}

// MARK: - Corner Radius

enum AppRadius {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 10
    static let md: CGFloat = 14
    static let lg: CGFloat = 18
    static let xl: CGFloat = 22
    static let xxl: CGFloat = 28
    static let pill: CGFloat = 999
}

// MARK: - Shadows

struct AppShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    static let subtle = AppShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    static let card = AppShadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    static let elevated = AppShadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
    static let floating = AppShadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 12)
    static let colored = AppShadow(color: AppColors.primary.opacity(0.3), radius: 15, x: 0, y: 6)
}

// MARK: - Animation Presets

enum AppAnimation {
    static let quick = Animation.easeOut(duration: 0.2)
    static let standard = Animation.easeInOut(duration: 0.3)
    static let smooth = Animation.easeInOut(duration: 0.4)
    static let dramatic = Animation.easeInOut(duration: 0.6)
    static let spring = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.35, dampingFraction: 0.6)
    static let gentle = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    static let stagger: (Int) -> Animation = { index in
        .spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05)
    }
}

// MARK: - Haptics

enum AppHaptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - Icon Set

enum AppIcons {
    static let home = "house.fill"
    static let explore = "safari.fill"
    static let cart = "cart.fill"
    static let favorites = "heart.fill"
    static let account = "person.fill"
    static let search = "magnifyingglass"
    static let back = "chevron.left"
    static let forward = "chevron.right"
    static let close = "xmark"
    static let add = "plus"
    static let remove = "minus"
    static let delete = "trash"
    static let edit = "pencil"
    static let share = "square.and.arrow.up"
    static let filter = "line.3.horizontal.decrease"
    static let sort = "arrow.up.arrow.down"
    static let location = "location.fill"
    static let notification = "bell.fill"
    static let settings = "gearshape.fill"
    static let logout = "rectangle.portrait.and.arrow.right"
    static let order = "bag.fill"
    static let success = "checkmark.circle.fill"
    static let star = "star.fill"
    static let starHalf = "star.leadinghalf.filled"
    static let starEmpty = "star"
}
