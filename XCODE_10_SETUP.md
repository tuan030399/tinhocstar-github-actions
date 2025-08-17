# 🍎 Hướng dẫn Flutter iOS với Xcode 10.1 & macOS 10.13

## ⚠️ Lưu ý quan trọng
- **Xcode 10.1** chỉ hỗ trợ **Flutter 1.x** (không hỗ trợ Flutter 3.x)
- **macOS 10.13** có giới hạn về Flutter version
- Cần sử dụng **Flutter phiên bản cũ** để tương thích

## 📋 Phiên bản tương thích

### Flutter Version
```bash
# Sử dụng Flutter 1.22.6 (phiên bản cuối hỗ trợ Xcode 10.1)
git clone https://github.com/flutter/flutter.git -b 1.22.6-stable
```

### iOS Target
- **Minimum iOS**: 9.0
- **Maximum iOS**: 12.x (do Xcode 10.1 giới hạn)

## 1️⃣ Cài đặt Flutter 1.22.6

```bash
# Download Flutter 1.22.6
cd ~/development
git clone https://github.com/flutter/flutter.git -b 1.22.6-stable flutter_1_22

# Thêm vào PATH
echo 'export PATH="$PATH:$HOME/development/flutter_1_22/bin"' >> ~/.bash_profile
source ~/.bash_profile

# Kiểm tra version
flutter --version
# Kết quả mong muốn: Flutter 1.22.6
```

## 2️⃣ Setup Xcode 10.1

```bash
# Kiểm tra Xcode version
xcodebuild -version
# Kết quả: Xcode 10.1

# Setup command line tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept

# Cài đặt iOS Simulator (iOS 12.1)
# Mở Xcode > Preferences > Components
# Download iOS 12.1 Simulator
```

## 3️⃣ Downgrade project cho Flutter 1.22

### Cập nhật pubspec.yaml
```yaml
name: qltinhoc
description: A new Flutter project.

version: 1.0.0+1

environment:
  sdk: ">=2.7.0 <3.0.0"  # Phù hợp với Flutter 1.22

dependencies:
  flutter:
    sdk: flutter
  
  # Sử dụng version cũ của các packages
  cupertino_icons: ^1.0.0
  http: ^0.12.2
  image_picker: ^0.6.7+22
  permission_handler: ^5.1.0+2
  shared_preferences: ^0.5.12+4
  gsheets: ^0.3.2
  google_ml_kit: ^0.6.0  # Version cũ tương thích
  intl: ^0.16.1

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

## 4️⃣ Cấu hình iOS cho Xcode 10.1

### ios/Runner.xcodeproj/project.pbxproj
```bash
# Cập nhật iOS Deployment Target
IPHONEOS_DEPLOYMENT_TARGET = 9.0;

# Cập nhật Bundle ID
PRODUCT_BUNDLE_IDENTIFIER = com.example.tinhocstar;
```

### ios/Runner/Info.plist
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDisplayName</key>
	<string>tinhocstar</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleName</key>
	<string>tinhocstar</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>NSCameraUsageDescription</key>
	<string>App cần camera để quét tài liệu</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>App cần truy cập thư viện ảnh</string>
</dict>
</plist>
```

## 5️⃣ Build không cần Developer Account

### Simulator Build (Không cần signing)
```bash
# Build cho simulator
flutter build ios --simulator --release

# Chạy trên simulator
flutter run --release
```

### Device Build (Cần signing)
```bash
# Build cho device (cần certificate)
flutter build ios --release

# Hoặc build debug (ít yêu cầu hơn)
flutter build ios --debug
```

## 6️⃣ Tạo IPA không cần Developer Account

### Cách 1: Development Signing (Free)
```bash
# Trong Xcode:
# 1. Mở ios/Runner.xcworkspace
# 2. Chọn Runner project
# 3. Signing & Capabilities
# 4. Team: Chọn Personal Team (Apple ID cá nhân)
# 5. Bundle ID: com.yourname.tinhocstar (phải unique)
```

### Cách 2: Ad-hoc Distribution
```bash
# Cần certificate từ bạn bè có Developer Account
# Hoặc sử dụng enterprise certificate
```

## 7️⃣ Workarounds cho Xcode 10.1

### Giảm tính năng không tương thích
```dart
// Trong main.dart, comment các tính năng mới
// Sử dụng packages version cũ
// Tránh null safety (Flutter 1.22 chưa có)
```

### Build script cho Xcode 10.1
```bash
#!/bin/bash
echo "🏗️ Build cho Xcode 10.1..."

# Clean
flutter clean
flutter pub get

# Build iOS (simulator)
flutter build ios --simulator --release

echo "✅ Build hoàn thành cho iOS Simulator"
echo "📱 Để build cho device thật, cần Apple ID trong Xcode"
```

## 8️⃣ Giải pháp thay thế

### Option 1: Upgrade macOS (Khuyến nghị)
- **macOS Mojave 10.14** → Có thể dùng Xcode 11
- **macOS Catalina 10.15** → Có thể dùng Xcode 12

### Option 2: Sử dụng CI/CD
- **GitHub Actions**: Build iOS trên cloud
- **Codemagic**: Flutter CI/CD service
- **Bitrise**: Mobile CI/CD platform

### Option 3: Thuê dịch vụ build
- Nhờ người có Mac mới build giúp
- Sử dụng dịch vụ build online

## 9️⃣ Kết luận

**Với setup hiện tại của bạn:**
- ✅ **Có thể build** cho iOS Simulator
- ⚠️ **Hạn chế** build cho device thật
- ❌ **Không thể** sử dụng Flutter 3.x
- 💡 **Khuyến nghị**: Upgrade macOS nếu có thể

**File IPA có thể tạo được:**
- 📱 **Simulator IPA**: Chạy trên simulator
- 🔓 **Development IPA**: Cài trên device với Apple ID cá nhân (7 ngày)
- ❌ **Distribution IPA**: Cần Developer Account ($99/năm)
