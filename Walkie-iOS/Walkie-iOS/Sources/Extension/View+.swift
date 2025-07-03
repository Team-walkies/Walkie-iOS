//
//  View+.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

extension View {
    
    func alignTo(_ alignment: Alignment) -> some View {
        modifier(AlignmentModifier(alignment: alignment))
    }
    
    func multiline(lineLimit: Int? = nil) -> some View {
        modifier(MultilineModifier(lineLimit: lineLimit))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func popGestureEnabled(_ enabled: Bool) -> some View {
        background(PopGestureConfigurator(enabled: enabled))
    }
    
    func applyHaptic(
        _ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium
    ) -> some View {
        modifier(HapticOnTapModifier(style: style))
    }
    
    func walkieTouchEffect() -> some View {
        self.buttonStyle(WalkieTouchEffect())
    }
}

// MARK: - AlignmentModifier
struct AlignmentModifier: ViewModifier {
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if alignment == .bottom || alignment == .bottomLeading || alignment == .bottomTrailing {
                Spacer(minLength: 0)
            }
            HStack(spacing: 0) {
                if alignment == .trailing || alignment == .bottomTrailing || alignment == .topTrailing {
                    Spacer(minLength: 0)
                }
                content
                if alignment == .leading || alignment == .bottomLeading || alignment == .topLeading {
                    Spacer(minLength: 0)
                }
            }
            if alignment == .top || alignment == .topLeading || alignment == .topTrailing {
                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - MultilineModifier
struct MultilineModifier: ViewModifier {
    let lineLimit: Int?
    
    func body(content: Content) -> some View {
        content.lineLimit(lineLimit)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - bottomSheet()
extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                Color(white: 0, opacity: 0.6)
                    .zIndex(1)
                    .ignoresSafeArea(.all)
                    .opacity(isPresented.wrappedValue ? 1 : 0)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented.wrappedValue)
        .sheet(isPresented: isPresented) {
            content()
                .ignoresSafeArea(.all)
                .presentationDetents([.height(height)])
                .presentationBackgroundInteraction(.disabled)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
    }
    
    func shimmer(isGray100: Bool) -> some View {
        modifier(ShimmerModifier(isGray100: isGray100))
    }
    
    func skeleton() -> some View {
        modifier(SkeletonModifier())
    }
    
    func skeletonGray200() -> some View {
        modifier(SkeletonModifierGray200())
    }
    
    @ViewBuilder
    func applySkeleton(isGray100: Bool) -> some View {
        if isGray100 {
            self.skeleton()
        } else {
            self.skeletonGray200()
        }
    }
    
    func innerBorder(color: Color, lineWidth: CGFloat, padding: CGFloat, cornerRadius: CGFloat) -> some View {
        self.modifier(InnerBorder(color: color, lineWidth: lineWidth, padding: padding, cornerRadius: cornerRadius))
    }
    
}

// Haptic

struct HapticOnTapModifier: ViewModifier {
    
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                HapticManager.shared.impact(style: style)
            }
    }
}

// 안쪽 테두리를 위한 ViewModifier
struct InnerBorder: ViewModifier {
    let color: Color
    let lineWidth: CGFloat
    let padding: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
                    .padding(padding)
            )
    }
}
