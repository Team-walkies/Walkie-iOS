//
//  HomeView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationBar(
                    showLogo: true,
                    showAlarmButton: true
                )
                
                ZStack(alignment: .bottomTrailing) {
                    switch viewModel.state {
                    case .loaded(let homeState):
                        VStack {
                            let width = geometry.size.width - 32
                            HomeStatsView(homeState: homeState, width: width)
                            HomeCharacterView(homeState: homeState, width: width)
                        }
                        .padding(.leading)
                        
                        Image(homeState.characterImage)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 120,
                                height: 120)
                            .padding(.trailing, 8)
                        
                    default:
                        EmptyView()
                    }
                }
                .padding(.top, 8)
            }
        }
        .onAppear {
            viewModel.action(.homeWillAppear)
        }
    }
}

struct HomeStatsView: View {
    
    let homeState: HomeViewModel.HomeState
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 5) {
                Text("\(homeState.nowStep)")
                    .font(.H1)
                    .foregroundColor(.white)
                Text("걸음")
                    .font(.B1)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
            .padding(.leading, 20)
            
            HStack(alignment: .bottom, spacing: 5) {
                Text("6.4km")
                    .font(.H2)
                    .foregroundColor(.white)
                Text("이동")
                    .font(.B2)
                    .foregroundColor(.white)
                    .padding(.bottom, 3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Spacer()
            
            ZStack {
                Image(.imgSpeechbubble)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 136, height: 45)
                
                HStack(spacing: 0) {
                    Text("부화까지 ")
                        .font(.B2)
                        .foregroundColor(.gray400)
                    
                    Text("\(homeState.needStep)걸음")
                        .font(.B2)
                        .foregroundColor(.white)
                }
                .padding(.top, -8)
            }
            .padding(.bottom, -17)
            
            Image(homeState.eggImage)
                .resizable()
                .scaledToFit()
                .frame(width: 296, height: 296)
                .padding(.bottom, -85)
        }
        .frame(width: width, height: 371)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue300, .blue200]),
                startPoint: .center,
                endPoint: .bottom
            )
        )
        .mask(RoundedRectangle(cornerRadius: 16))
    }
}

struct HomeCharacterView: View {
    
    let homeState: HomeViewModel.HomeState
    let width: CGFloat
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(homeState.characterName)
                    .font(.H6)
                    .foregroundColor(.gray700)
                
                Text("와 함께 걷는 중..")
                    .font(.B2)
                    .foregroundColor(.gray500)
            }
            .padding(.leading, 16)
            Spacer()
        }
        .frame(
            width: width,
            height: 52
        )
        .background(.gray100)
        .mask(RoundedRectangle(cornerRadius: 12))
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
