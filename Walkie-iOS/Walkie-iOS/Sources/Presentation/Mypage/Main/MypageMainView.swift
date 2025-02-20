//
//  MypageMainView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/20/25.
//

import SwiftUI
struct MypageMainView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 4) {
                NavigationBar(
                    showAlarmButton: true,
                    hasAlarm: true)
                VStack(spacing: 0) {
                    ProfileSectionView()
                        .padding(.bottom, 20)
                    
                    SettingSectionView()
                        .padding(.bottom, 8)
                    
                    ServiceSectionView()
                        .padding(.bottom, 8)
                    
                    FeedbackButtonView()
                        .padding(.bottom, 12)
                    
                    AccountActionButtonsView()
                }
                .frame(alignment: .top)
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct ProfileSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text("승빈짱짱")
                    .font(.H2)
                    .foregroundStyle(.gray700)
                Text("님")
                    .font(.H2)
                    .foregroundStyle(.gray500)
                    .padding(.trailing, 8)
                
                UserLevelBadge(level: "초보워키")
                Spacer()
            }
            
            HighlightTextAttribute(
                text: "지금까지 5개의 스팟을 탐험했어요",
                textColor: .gray500,
                font: .B1,
                highlightText: "5",
                highlightColor: .blue400,
                highlightFont: .H5)
        }
    }
}

private struct SettingSectionView: View {
    var body: some View {
        ItemSection(title: MypageMainItem.setting.title) {
            ForEach([SettingItem.myInfo, .pushNotification], id: \.title) { item in
                ItemRow(
                    icon: item.icon,
                    title: item.title,
                    action: item.action,
                    isVersion: false)
            }
        }
    }
}

private struct ServiceSectionView: View {
    var body: some View {
        ItemSection(title: MypageMainItem.service.title) {
            ForEach([ServiceItem.notice, .privacyPolicy, .appVersion], id: \.title) { item in
                ItemRow(
                    icon: item.icon,
                    title: item.title,
                    action: item.action,
                    isVersion: item == ServiceItem.appVersion
                )
            }
        }
    }
}

private struct FeedbackButtonView: View {
    var body: some View {
        Button(
            action: {
                // 피드백 이동
            },
            label: {
                HStack(spacing: 0) {
                    Image(.icMyFeedback)
                        .frame(width: 36, height: 36)
                        .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("앱에 대한 의견을 남겨주세요!")
                            .font(.B2)
                            .foregroundStyle(.gray700)
                        Text("더 나은 서비스를 위해 노력할게요")
                            .font(.C1)
                            .foregroundStyle(.gray500)
                    }
                    Spacer()
                    Image(.icChevronRight)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.gray300)
                }
                .padding(16)
            }
        )
        .frame(height: 72)
        .background(.gray100)
        .cornerRadius(12)
    }
}
private struct AccountActionButtonsView: View {
    var body: some View {
        HStack(spacing: 12) {
            Button {
                // 로그아웃
            } label: {
                Text("로그아웃")
                    .font(.B2)
                    .foregroundStyle(.gray400)
            }
            .contentShape(Rectangle())
            Rectangle()
                .frame(width: 1, height: 16)
                .foregroundStyle(.gray300)
            Button {
                // 탈퇴하기
            } label: {
                Text("탈퇴하기")
                    .font(.B2)
                    .foregroundStyle(.gray400)
            }
        }
        .frame(alignment: .center)
    }
}

struct ItemSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.H6)
                .foregroundStyle(.gray500)
                .padding(.bottom, 8)
            content
        }
        .padding(.all, 16)
        .background(.gray100)
        .cornerRadius(12)
    }
}

struct ItemRow: View {
    let icon: Image
    let title: String
    let action: () -> Void
    let isVersion: Bool
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                icon
                    .frame(width: 36, height: 36)
                    .padding(.trailing, 8)
                Text(title)
                    .font(.B2)
                    .foregroundStyle(.gray700)
                Spacer()
                if isVersion {
                    Text("v1.0.0")
                        .font(.B2)
                        .foregroundStyle(.gray400)
                } else {
                    Image(.icChevronRight)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.gray300)
                }
            }
            .frame(height: 52)
        }.contentShape(Rectangle())
    }
}

struct UserLevelBadge: View {
    let level: String
    
    var body: some View {
        Text(level)
            .font(.B2)
            .foregroundStyle(.blue400)
            .padding(.horizontal, 8)
            .frame(height: 28)
            .background(.blue50)
            .cornerRadius(8)
    }
}

enum MypageMainItem {
    case setting
    case service
    
    var title: String {
        switch self {
        case .setting:
            return "설정"
        case .service:
            return "서비스 약관"
        }
    }
}

enum SettingItem {
    case myInfo
    case pushNotification
    
    var title: String {
        switch self {
        case .myInfo:
            return "내 정보"
        case .pushNotification:
            return "푸시 알림"
        }
    }
    
    var icon: Image {
        switch self {
        case .myInfo:
            return Image(.icMySetting)
        case .pushNotification:
            return Image(.icMyAlarm)
        }
    }
    
    var action: () -> Void {
        switch self {
        case .myInfo:
            // 내 정보 이동
            return {}
        case .pushNotification:
            // 푸시 알림 이동
            return {}
        }
    }
}

enum ServiceItem {
    case notice
    case privacyPolicy
    case appVersion
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .appVersion:
            return "앱 버전"
        }
    }
    
    var icon: Image {
        switch self {
        case .notice:
            return Image(.icMyNotice)
        case .privacyPolicy:
            return Image(.icMyPrivacy)
        case .appVersion:
            return Image(.icMyVersion)
        }
    }
    
    var action: () -> Void {
        switch self {
        case .notice:
            // 공지사항 이동
            return {}
        case .privacyPolicy:
            // 개인정보처리방침 이동
            return {}
        case .appVersion:
            return {}
        }
    }
}

#Preview {
    MypageMainView()
}
