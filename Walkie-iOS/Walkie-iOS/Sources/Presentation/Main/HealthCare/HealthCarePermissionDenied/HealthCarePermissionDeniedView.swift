//
//  HealthCarePermissionDeniedView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import SwiftUI
import WalkieCommon

struct HealthCarePermissionDeniedView: View {
    
    @StateObject var viewModel: HealthCarePermissionDeniedViewModel
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
                        ForEach(Instruction.allCases, id: \.self) { instruction in
                            InstructionView(
                                imageName: instruction.image,
                                instructionText: instruction.text
                            )
                        }
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
    
    private enum Instruction: CaseIterable {
        case step1, step2, step3, step4
        
        var image: Image {
            switch self {
            case .step1: return Image(.imgHealthPermission1)
            case .step2: return Image(.imgHealthPermission2)
            case .step3: return Image(.imgHealthPermission3)
            case .step4: return Image(.imgHealthPermission4)
            }
        }
        
        var text: String {
            switch self {
            case .step1: return "1. 건강 앱에서 '프로필'을 눌러주세요"
            case .step2: return "2. 스크롤을 내려 '앱'을 눌러주세요"
            case .step3: return "3. 'Walkie'를 눌러주세요"
            case .step4: return "4. '모두 켜기'를 눌러주면 끝!"
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
