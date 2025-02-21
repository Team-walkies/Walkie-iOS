//
//  ViewModelable.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

import Combine

protocol ViewModelable: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    
    func action(_ action: Action)
}
