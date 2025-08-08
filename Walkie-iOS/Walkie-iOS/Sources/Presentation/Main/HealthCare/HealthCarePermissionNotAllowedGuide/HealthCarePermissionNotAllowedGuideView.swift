//
//  HealthCarePermissionNotAllowedGuideView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import SwiftUI
import WalkieCommon

struct HealthCarePermissionNotAllowedGuideView: View {
    
    @StateObject var viewModel: HealthCarePermissionNotAllowedGuideViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            NavigationBar(showBackButton: true)
            ScrollView(.vertical) {
                VStack(
                    alignment: .center,
                    spacing: 0
                ) {
                    Group {
                        Text("걸음 기록을 보려면")
                            .font(.B1)
                            .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        HStack(alignment: .center, spacing: 0) {
                            Image(.iconHealthApp)
                                .resizable()
                                .frame(width: 22, height: 22)
                            Text("건강 앱에서 권한을 허용해주세요")
                                .font(.B1)
                                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        }.padding(.bottom, 24)
                        InstructionView(
                            imageName: Image(.imgHealthPermission1),
                            instructionText: "1. 건강 앱에서 '프로필'을 눌러주세요"
                        )
                        InstructionView(
                            imageName: Image(.imgHealthPermission2),
                            instructionText: "2. 스크롤을 내려 '앱'을 눌러주세요"
                        )
                        InstructionView(
                            imageName: Image(.imgHealthPermission3),
                            instructionText: "3. 'Walkie'를 눌러주세요"
                        )
                        InstructionView(
                            imageName: Image(.imgHealthPermission4),
                            instructionText: "4. '모두 켜기'를 눌러주면 끝!"
                        )
                    }
                    .padding(.horizontal, 24)
                }
                .scrollIndicators(.never)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
            .onChange(of: scenePhase, initial: false) { _, newValue in
                switch newValue {
                case .active:
                    viewModel.action(.returnFromPermissionSetting)
                default:
                    break
                }
            }
        }
    }
    
    private struct InstructionView: View {
        let imageName: Image
        let instructionText: String
        
        var body: some View {
            VStack {
                imageName
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 160)
            }
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .background(WalkieCommonAsset.gray50.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 8)
            
            Text(instructionText)
                .font(.B2)
                .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 24)
        }
    }
    
}
