## 🚶🏻‍♂️ Walkie - 걷기에 재미를 더하다
<a href="apps.apple.com/kr/app/id6742345668">
  <img src="https://img.shields.io/badge/AppStore-0D96F6.svg?style=flat-square&logo=appstore&logoColor=ffffff" width="100"/>
</a>
<a href="https://zippy-cake-826.notion.site/1c2e3ac17cda8012ab68d67896864ca9">
  <img src="https://img.shields.io/badge/Notion-212121.svg?style=flat-square&logo=notion&logoColor=ffffff" width="80"/>
</a>
<br>
<img alt="walkie" src="https://github.com/user-attachments/assets/854b4ce1-a240-468f-bc43-f224c6c2f638" width="800" height="391"/>

> 그냥 걷기만 해도 캐릭터가 생긴다!  
> 지도를 따라 스팟을 탐험하고 알을 모아 캐릭터를 부화하세요. 일상이 모험이 되는 위치 기반 만보기, 워키!


## 🏗 전체 아키텍처

### Clean Architecture 구조
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │───▶│     Domain      │───▶│      Data       │
│   (Views/VMs)   │    │  (Entities/UC)  │    │ (Repo/Service)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 주요 모듈 구성
- **Main App**: Walkie-iOS (메인 앱)
- **Widget Extension**: WalkieWidget (홈 스크린 위젯)
- **Shared Module**: WalkieCommon (공통 UI/유틸)
```
┌─────────────────┐    ┌─────────────────┐    ┌──────────────────┐
│   Walkie-iOS    │───▶│  WalkieCommon   │◀───│  WalkieWidget    │
│   (Main App)    │    │ (Shared Module) │    │ (Widget Ext.)    │
│                 │    │                 │    │                  │
│ • Views/VMs     │    │ • ProgressBar   │    │ • LiveActivity   │
│ • Business      │    │ • FontLiterals  │    │ • Dynamic Island │
│ • Networking    │    │ • Colors        │    │ • Configuration  │
│ • HealthKit     │    │ • Utils         │    │                  │
└─────────────────┘    └─────────────────┘    └──────────────────┘
```

## 🛠️ Tech Skills 

<table>
  <tr>
    <th>Category</th>
    <th>Stack</th>
    <th>Use</th>
  </tr>
  <tr>
    <td rowspan="3">🖥 UI Framework</td>
    <td>SwiftUI</td>
    <td>선언형 UI 구축</td>
  </tr>
  <tr>
    <td>Combine</td>
    <td>반응형 프로그래밍</td>
  </tr>
  <tr>
    <td>Lottie</td>
    <td>JSON 애니메이션</td>
  </tr>
  <tr>
    <td rowspan="4">📱 iOS System</td>
    <td>CoreMotion / HealthKit</td>
    <td>실시간 현재 걸음 수 및 과거 걸음수 연동</td>
  </tr>
  <tr>
    <td>CoreLocation</td>
    <td>실시간 위치 정보</td>
  </tr>
  <tr>
    <td>UserNotifications</td>
    <td>로컬 / 원격 알림</td>
  </tr>
  <tr>
    <td>BackgroundTasks</td>
    <td>백그라운드 걸음수 업데이트 작업</td>
  </tr>
  <tr>
    <td rowspan="2">🌐 네트워킹</td>
    <td>Moya / URLSession</td>
    <td>HTTP 추상화 및 통신</td>
  </tr>
  <tr>
    <td>Firebase FCM</td>
    <td>푸시 알림</td>
  </tr>
  <tr>
    <td rowspan="3">💾 데이터</td>
    <td>Keychain</td>
    <td>사용자의 JWT 토큰 저장</td>
  </tr>
  <tr>
    <td>UserDefaults</td>
    <td>앱 정보 로컬에 저장</td>
  </tr>
  <tr>
    <td>In-Memory Store</td>
    <td>실시간 상태 관리</td>
  </tr>
</table>

## 📞 Contact

📨 **E-mail:** walkieofficial@gmail.com

📱 **Instagram:** [@walkie__official](https://www.instagram.com/walkie__official?igsh=bTZhZjUwa2JkdW1u)

---

<div align="center">
  <b>일상이 모험이 되는 순간, 워키와 함께하세요! 🚶‍♂️✨</b>
</div>
