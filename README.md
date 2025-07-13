# LockApp - Parental Control Mobile Application

## 📱 Overview

LockApp is a comprehensive parental control mobile application built with Flutter and Firebase. It enables parents to monitor and control their children's device usage, manage app access, and ensure digital safety.

## ✨ Features

### 🔐 Authentication & User Management
- **Secure Firebase Authentication** with email/password
- **Role-based access control** (Parent/Child accounts)
- **Real-time user session management**

### 📱 Device Management
- **Device pairing** between parent and child devices
- **Real-time device status monitoring**
- **Device registration and identification**

### 🎯 App Control
- **App locking/unlocking** functionality
- **Installed app detection and management**
- **Custom app restrictions**

### 📊 Analytics & Monitoring
- **Usage statistics** and time tracking
- **Firebase Analytics** integration
- **Real-time activity monitoring**

### 🔔 Notifications
- **Push notifications** via Firebase Cloud Messaging
- **Real-time alerts** for parents
- **Status updates** and system notifications

### 📈 Additional Features
- **Crash reporting** with Firebase Crashlytics
- **Offline support** with Firestore caching
- **Modern UI/UX** with Material Design 3
- **Cross-platform** support (Android/iOS)

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material Design 3** - UI components

### Backend & Services
- **Firebase Core** - Foundation services
- **Firebase Authentication** - User management
- **Cloud Firestore** - NoSQL database
- **Firebase Cloud Messaging** - Push notifications
- **Firebase Analytics** - Usage tracking
- **Firebase Crashlytics** - Error reporting

### State Management & Architecture
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Freezed** - Immutable data classes
- **JSON Annotation** - Serialization

### Development Tools
- **Build Runner** - Code generation
- **Flutter Lints** - Code quality
- **Permission Handler** - Device permissions

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/vassimdr/lock.git
cd lock/lockapp
   ```

2. **Install dependencies**
   ```bash
flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build
   ```

4. **Firebase Setup**
   - Create a Firebase project
   - Add your Android/iOS apps
   - Download `google-services.json` and place in `android/app/`
   - Download `GoogleService-Info.plist` and place in `ios/Runner/`

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
└── src/
    ├── api/                  # Firebase services
    │   ├── auth_service.dart
    │   ├── firebase_auth_service.dart
    │   ├── firestore_service.dart
    │   ├── notification_service.dart
    │   └── analytics_service.dart
    ├── config/               # Configuration files
    │   └── firebase_config.dart
    ├── constants/            # App constants
    │   ├── app_constants.dart
    │   └── app_routes.dart
    ├── navigation/           # Navigation logic
    │   └── app_router.dart
    ├── screens/              # UI screens
    │   ├── auth/
    │   ├── child/
    │   ├── parent/
    │   ├── onboarding/
    │   └── permissions/
    ├── services/             # Device services
    │   └── permission_service.dart
    ├── store/                # State management
    │   └── auth/
    ├── theme/                # App theming
    │   ├── app_colors.dart
    │   ├── app_text_styles.dart
    │   └── app_theme.dart
    ├── types/                # Data models
    │   ├── user_model.dart
    │   ├── device_model.dart
    │   └── enums/
    └── utils/                # Utility functions
        └── error_handler.dart
```

## 🔧 Configuration

### Firebase Configuration
1. Enable Authentication with Email/Password
2. Create Firestore Database
3. Enable Analytics
4. Set up Cloud Messaging
5. Configure Crashlytics

### Android Configuration
- Minimum SDK: 23
- Target SDK: 34
- Permissions: Internet, Wake Lock, Receive Boot Completed

## 🎯 Usage

### For Parents
1. **Register** as a parent user
2. **Pair** with child's device
3. **Monitor** app usage and activity
4. **Control** app access remotely
5. **Receive** real-time notifications

### For Children
1. **Register** as a child user
2. **Accept** parent's pairing request
3. **Use** device within set restrictions
4. **Request** app access when needed

## 🔒 Security

- **Firebase Security Rules** for data protection
- **Role-based access control**
- **Encrypted data transmission**
- **Secure authentication flows**

## 📱 Supported Platforms

- ✅ Android (API 23+)
- ✅ iOS (iOS 12+)
- 🔄 Web (Planned)
- 🔄 Desktop (Planned)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Vasim** - [GitHub](https://github.com/vassimdr)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Community contributors and testers

---

**Made with ❤️ by Vasim** 