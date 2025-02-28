//
//  MapView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/24/25.
//

import SwiftUI

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack {
            Text("오늘의 걸음수는?!")
                .font(.H2)
            switch viewModel.state {
            case .loaded(let mapState):
                VStack {
                    Text("\(mapState.step) 걸음")
                        .font(.H2)
                    let distanceStr = String(format: "%.1f", mapState.distance)
                    Text("\(distanceStr) km")
                        .font(.H2)
                }
            default:
                Text("")
            }
        }
        .onAppear {
            viewModel.action(.mapViewAppear)
        }
        .onDisappear {
            viewModel.action(.mapViewDisappear)
        }
    }
}
