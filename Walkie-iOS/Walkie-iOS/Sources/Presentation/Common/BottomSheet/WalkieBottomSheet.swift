//
//  WalkieBottomSheet.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/18/25.
//

import SwiftUI

struct WalkieBottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let height: CGFloat
    let content: () -> SheetContent
    
    func body(content base: Content) -> some View {
        ZStack {
            base
            
            if isPresented {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            if isPresented {
                VStack {
                    Spacer()
                    self.content()
                        .frame(height: height)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(24, corners: [.topLeft, .topRight])
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}
