//
//  PopGestureConfigurator.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/2/25.
//

import SwiftUI

struct PopGestureConfigurator: UIViewControllerRepresentable {
    let enabled: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.navigationController?
                .interactivePopGestureRecognizer?.isEnabled = enabled
        }
    }
}
