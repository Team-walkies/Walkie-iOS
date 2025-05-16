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
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .ignoresSafeArea(.all)
                .presentationDetents([.height(height-34)]) // Safe Area 고려
                .presentationBackgroundInteraction(.disabled)
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
        }
    }
    
    func permissionBottomSheet<Content: View>(
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
                .presentationCornerRadius(24)
                .ignoresSafeArea(.all, edges: .bottom)
                .presentationDetents([.height(height)])
                .presentationBackgroundInteraction(.disabled)
                .presentationDragIndicator(.hidden)
                .presentationBackground(.white)
                .interactiveDismissDisabled(true)
        }
    }
    
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
    
    func skeleton() -> some View {
        modifier(SkeletonModifier())
    }
}
