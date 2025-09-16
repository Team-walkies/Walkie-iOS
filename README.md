## 🚶🏻‍♂️ Walkie - 걷기에 재미를 더하다


**Appstore Download** | <a href="https://apps.apple.com/kr/app/id6742345668">
  <img alt="Download on the App Store" src="https://img.shields.io/badge/AppStore-0D96F6.svg?style=flat-square&logo=apple&logoColor=ffffff" style="height:20px"/>
</a>

**Official Homepage** | <a href="https://zippy-cake-826.notion.site/1c2e3ac17cda8012ab68d67896864ca9">
  <img alt="Notion Docs" src="https://img.shields.io/badge/Notion-212121.svg?style=flat-square&logo=notion&logoColor=ffffff" style="height:20px"/>
</a>

**Official Instagram** | <a href="https://www.instagram.com/walkie__official/">
  <img alt="Instagram" src="https://img.shields.io/badge/Instagram-E4405F?style=flat-square&logo=instagram&logoColor=white" style="height:20px"/>
</a>

<img alt="walkie" src="https://github.com/user-attachments/assets/6be3a84e-5ee2-4273-9df1-c902694787ac" width="800"/>

> 그냥 걷기만 해도 캐릭터가 생긴다!  
> 지도를 따라 스팟을 탐험하고 알을 모아 캐릭터를 부화하세요. 일상이 모험이 되는 위치 기반 만보기, 워키!

> Just walk, and characters come to life!<br>
> Explore spots on the map, collect eggs, and hatch characters.<br>
> A location-based pedometer app, Walkie, that turns your daily routine into an adventure!

## 🏗 System Architecture

### MVVM-C + Clean Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │───▶│     Domain      │◀───│      Data       │
│   (Views/VMs)   │    │  (Entities/UC)  │    │ (Repo/Service)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Modules
- **Main App**: Walkie-iOS
- **Widget Extension**: WalkieWidget
- **Shared Module**: WalkieCommon
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
    <td>Declarative UI Development</td>
  </tr>
  <tr>
    <td>Combine</td>
    <td>Reactive Programming</td>
  </tr>
  <tr>
    <td>Lottie</td>
    <td>JSON-based Animations</td>
  </tr>
  <tr>
    <td rowspan="4">📱 iOS System</td>
    <td>CoreMotion / HealthKit</td>
    <td>Real-time and Historical Step Count Integration</td>
  </tr>
  <tr>
    <td>CoreLocation</td>
    <td>Real-time Location Information</td>
  </tr>
  <tr>
    <td>UserNotifications</td>
    <td>Local / Remote Notifications</td>
  </tr>
  <tr>
    <td>BackgroundTasks</td>
    <td>Background Step Count Updates</td>
  </tr>
  <tr>
    <td rowspan="2">🌐 Networking</td>
    <td>Moya / URLSession</td>
    <td>HTTP Abstraction and Communication</td>
  </tr>
  <tr>
    <td>Firebase FCM</td>
    <td>Push Notifications</td>
  </tr>
  <tr>
    <td rowspan="3">💾 Data</td>
    <td>Keychain</td>
    <td>Storage of User's JWT Token</td>
  </tr>
  <tr>
    <td>UserDefaults</td>
    <td>Local Storage of App Information</td>
  </tr>
  <tr>
    <td>In-Memory Store</td>
    <td>Real-time State Management</td>
  </tr>
</table>

## 📞 Contact

📨 **E-mail:** walkieofficial@gmail.com

---

<div align="center">
  <b>일상이 모험이 되는 순간, 워키와 함께하세요! 🚶‍♂️✨</b>
</div>
