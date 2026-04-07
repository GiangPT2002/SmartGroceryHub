//
//  Theme.swift
//  SmartGroceryHub
//
//  ViewModifiers, ButtonStyles, and reusable UI primitives.
//

import SwiftUI

// MARK: - Card Style Modifier

struct CardStyle: ViewModifier {
    var padding: CGFloat = AppSpacing.md
    var radius: CGFloat = AppRadius.lg
    var shadow: AppShadow = .card
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppColors.surface)
            .cornerRadius(radius)
            .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

// MARK: - Glass Morphism Modifier

struct GlassMorphism: ViewModifier {
    var radius: CGFloat = AppRadius.lg
    var opacity: CGFloat = 0.8
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial.opacity(opacity))
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
    }
}

// MARK: - Shimmer Effect

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    var speed: Double = 1.5
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.4),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                    phase = UIScreen.main.bounds.width
                }
            }
    }
}

// MARK: - Press Feedback

struct PressableStyle: ButtonStyle {
    var scale: CGFloat = 0.97
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Primary Button Style

struct PrimaryButtonStyle: ButtonStyle {
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: AppSpacing.xs) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.85)
            }
            configuration.label
        }
        .font(AppTypography.headline())
        .foregroundColor(AppColors.textOnPrimary)
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .background(
            Group {
                if isDisabled {
                    AppColors.primary.opacity(0.4)
                } else if configuration.isPressed {
                    AppColors.primaryDark
                } else {
                    AppColors.primary
                }
            }
        )
        .cornerRadius(AppRadius.xl)
        .shadow(
            color: isDisabled ? .clear : AppShadow.colored.color,
            radius: configuration.isPressed ? 4 : AppShadow.colored.radius,
            x: 0, y: configuration.isPressed ? 2 : AppShadow.colored.y
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline())
            .foregroundColor(AppColors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(AppColors.primarySurface)
            .cornerRadius(AppRadius.xl)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Ghost Button Style

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline())
            .foregroundColor(AppColors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .stroke(AppColors.primary, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Badge Modifier

struct BadgeModifier: ViewModifier {
    let count: Int
    
    func body(content: Content) -> some View {
        content.overlay(alignment: .topTrailing) {
            if count > 0 {
                Text(count > 99 ? "99+" : "\(count)")
                    .font(.custom("Gilroy-Bold", size: 10))
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(AppColors.error)
                    .clipShape(Capsule())
                    .offset(x: 6, y: -6)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

// MARK: - Floating Header Blur

struct FloatingHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(.all, edges: .top)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
            )
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle(
        padding: CGFloat = AppSpacing.md,
        radius: CGFloat = AppRadius.lg,
        shadow: AppShadow = .card
    ) -> some View {
        modifier(CardStyle(padding: padding, radius: radius, shadow: shadow))
    }
    
    func glassMorphism(radius: CGFloat = AppRadius.lg, opacity: CGFloat = 0.8) -> some View {
        modifier(GlassMorphism(radius: radius, opacity: opacity))
    }
    
    func shimmer(speed: Double = 1.5) -> some View {
        modifier(ShimmerEffect(speed: speed))
    }
    
    func appBadge(_ count: Int) -> some View {
        modifier(BadgeModifier(count: count))
    }
    
    func floatingHeader() -> some View {
        modifier(FloatingHeaderStyle())
    }
    
    func staggeredAppear(index: Int) -> some View {
        self.transition(.asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .opacity
        ))
        .animation(AppAnimation.stagger(index), value: true)
    }
}

// MARK: - Gradient Text

struct GradientText: View {
    let text: String
    let font: Font
    let gradient: LinearGradient
    
    init(_ text: String, font: Font = AppTypography.title1(), gradient: LinearGradient = AppColors.primaryGradient) {
        self.text = text
        self.font = font
        self.gradient = gradient
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(gradient)
    }
}

// MARK: - Animated Loading Dots

struct LoadingDots: View {
    @State private var animating = false
    let color: Color
    
    init(color: Color = AppColors.primary) {
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .opacity(animating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear { animating = true }
    }
}
