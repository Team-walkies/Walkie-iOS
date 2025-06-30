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
            
            Color.black
                .opacity(isPresented ? 0.6 : 0)
                .ignoresSafeArea()
                .zIndex(1)
            
            VStack {
                Spacer()
                content()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(24, corners: [.topLeft, .topRight])
            }
            .ignoresSafeArea(edges: .bottom)
            .offset(y: isPresented ? 0 : height)
            .zIndex(2)
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}
