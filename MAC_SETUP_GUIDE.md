# 🍎 Hướng dẫn setup Flutter iOS trên Mac

## 📋 Yêu cầu
- macOS 10.14 trở lên
- Xcode 12.0 trở lên
- Apple Developer Account (để build cho device thật)

## 1️⃣ Cài đặt Flutter

### Cách 1: Homebrew (Khuyến nghị)
```bash
# Cài đặt Homebrew nếu chưa có
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Cài đặt Flutter
brew install --cask flutter

# Thêm vào PATH
echo 'export PATH="$PATH:/opt/homebrew/bin/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Cách 2: Download trực tiếp
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Thêm vào PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

## 2️⃣ Cài đặt Xcode

```bash
# Cài đặt từ App Store hoặc
# Download từ: https://developer.apple.com/xcode/

# Sau khi cài đặt, chạy:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Chấp nhận license
sudo xcodebuild -license accept
```

## 3️⃣ Cài đặt iOS Simulator

```bash
# Mở Xcode
# Vào: Xcode > Preferences > Components
# Download iOS Simulator versions cần thiết
```

## 4️⃣ Kiểm tra setup

```bash
flutter doctor
```

Kết quả mong muốn:
```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain (nếu có)
✓ Xcode - develop for iOS and macOS
✓ Chrome - develop for the web
✓ Android Studio (nếu có)
✓ VS Code (nếu có)
✓ Connected device (1 available)
✓ Network resources
```

## 5️⃣ Setup project

```bash
# Giải nén project
tar -xzf tinhocstar-flutter-project.tar.gz
cd tinhocstar-flutter-project

# Chạy setup script
chmod +x setup_ios.sh
./setup_ios.sh

# Restore dependencies
flutter pub get
```

## 6️⃣ Cấu hình iOS

### Bundle ID và Signing
```bash
# Mở Xcode workspace
open ios/Runner.xcworkspace

# Trong Xcode:
# 1. Chọn Runner project
# 2. Chọn Runner target
# 3. Vào tab "Signing & Capabilities"
# 4. Chọn Team (cần Apple Developer Account)
# 5. Đổi Bundle Identifier: com.example.tinhocstar
```

### App Icon
1. Tạo icon sizes từ logo.png:
   - 20x20, 29x29, 40x40, 58x58, 60x60
   - 80x80, 87x87, 120x120, 180x180
2. Sử dụng tool: https://appicon.co/
3. Drag & drop vào AppIcon.appiconset trong Xcode

## 7️⃣ Build IPA

### Cách 1: Flutter command
```bash
# Build release
flutter build ios --release

# File sẽ ở: build/ios/iphoneos/Runner.app
```

### Cách 2: Xcode Archive (Khuyến nghị)
```bash
# Mở Xcode
open ios/Runner.xcworkspace

# Trong Xcode:
# 1. Chọn "Any iOS Device" hoặc device cụ thể
# 2. Product > Archive
# 3. Chờ build hoàn thành
# 4. Trong Organizer: Distribute App
# 5. Chọn method: Ad Hoc, App Store, Enterprise
# 6. Export IPA file
```

## 8️⃣ Troubleshooting

### Lỗi signing
```bash
# Kiểm tra certificates
security find-identity -v -p codesigning

# Reset signing
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Lỗi dependencies
```bash
# Clean và rebuild
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

### Lỗi Xcode
```bash
# Reset Xcode
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ios/Pods ios/Podfile.lock
cd ios && pod install && cd ..
```

## 9️⃣ Lưu ý quan trọng

- **Apple Developer Account**: Cần để build cho device thật
- **Provisioning Profile**: Tự động tạo khi có Developer Account
- **Code Signing**: Bắt buộc cho iOS
- **App Store**: Cần review để publish

## 🎯 Kết quả

Sau khi hoàn thành, bạn sẽ có:
- File IPA để cài đặt trên iPhone/iPad
- App với tên "tinhocstar"
- Icon logo tùy chỉnh
- Tất cả tính năng như Android version
