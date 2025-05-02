//
//  Coordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI

protocol Coordinator: AnyObject {
    var diContainer: DIContainer { get set }
    var path: NavigationPath { get set }
    var sheet: (any AppRoute)? { get set }
    var fullScreenCover: (any AppRoute)? { get set }
    var sheetOnDismiss: (() -> Void)? { get set }
    var fullScreenCoverOnDismiss: (() -> Void)? { get set }

    func push(_ scene: any AppRoute)
    func pop()
    func popToRoot()
    func presentSheet(_ sheet: any AppRoute, onDismiss: (() -> Void)?)
    func dismissSheet()
    func presentFullScreenCover(
        _ fullScreenCover: any AppRoute,
        onDismiss: (() -> Void)?
    )
    func dismissFullScreenCover()
}

extension Coordinator {
    func push(_ scene: any AppRoute) {
        path.append(scene)
    }

    func pop() {
        if !path.isEmpty { path.removeLast() }
    }

    func popToRoot() {
        if !path.isEmpty { path.removeLast(path.count - 1) }
    }

    func presentSheet(_ sheet: any AppRoute, onDismiss: (() -> Void)? = nil) {
        self.sheet = sheet
        self.sheetOnDismiss = onDismiss
    }

    func dismissSheet() {
        self.sheet = nil
        if let onDismiss = sheetOnDismiss { onDismiss() }
        self.sheetOnDismiss = nil
    }

    func presentFullScreenCover(
        _ fullScreenCover: any AppRoute,
        onDismiss: (() -> Void)? = nil
    ) {
        self.fullScreenCover = fullScreenCover
        self.fullScreenCoverOnDismiss = onDismiss
    }

    func dismissFullScreenCover() {
        self.fullScreenCover = nil
        if let onDismiss = fullScreenCoverOnDismiss { onDismiss() }
        self.fullScreenCoverOnDismiss = nil
    }
}
