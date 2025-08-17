# 🚀 Hướng dẫn Upgrade Mac để hỗ trợ iOS 18.6

## 🔍 BƯỚC 1: KIỂM TRA MAC CỦA BẠN

### Kiểm tra model Mac:
```bash
# Mở Terminal và chạy:
system_profiler SPHardwareDataType | grep "Model Name"
system_profiler SPHardwareDataType | grep "Model Identifier"
system_profiler SPHardwareDataType | grep "Chip"
```

### Kết quả mẫu:
```
Model Name: MacBook Pro
Model Identifier: MacBookPro15,1
Chip: Intel Core i7 / Apple M1/M2/M3
```

### Mac models HỖ TRỢ macOS 14.0 Sonoma:

#### ✅ ĐƯỢC HỖ TRỢ:
- **MacBook Air**: 2020, 2022, 2024 (M1/M2/M3)
- **MacBook Pro**: 2019, 2021, 2023, 2024 (Intel/M1/M2/M3)
- **iMac**: 2019, 2021, 2023, 2024 (Intel/M1/M3)
- **iMac Pro**: 2017 (Intel)
- **Mac mini**: 2018, 2020, 2022, 2023 (Intel/M1/M2)
- **Mac Studio**: 2022, 2023 (M1/M2)
- **Mac Pro**: 2019, 2023 (Intel/M2)

#### ❌ KHÔNG HỖ TRỢ:
- **MacBook Air**: 2018 trở về trước
- **MacBook Pro**: 2018 trở về trước  
- **iMac**: 2017 trở về trước
- **Mac mini**: 2014 trở về trước
- **Mac Pro**: 2013 trở về trước

## 🎯 BƯỚC 2: LỰA CHỌN UPGRADE PATH

### Nếu Mac HỖ TRỢ macOS 14.0+:
```
✅ Upgrade macOS → Xcode 16 → iOS 18.6 support
```

### Nếu Mac KHÔNG HỖ TRỢ:
```
❌ Cần mua Mac mới HOẶC dùng giải pháp thay thế
```

## 🔄 BƯỚC 3: UPGRADE macOS (Nếu được hỗ trợ)

### Chuẩn bị upgrade:
```bash
# 1. Backup với Time Machine
# 2. Kiểm tra dung lượng (cần 50GB+ free)
df -h

# 3. Kiểm tra RAM (khuyến nghị 16GB+)
system_profiler SPHardwareDataType | grep "Memory"

# 4. Update apps hiện tại
softwareupdate -l
```

### Upgrade process:
```bash
# Cách 1: System Preferences
# Apple Menu > About This Mac > Software Update

# Cách 2: Terminal
sudo softwareupdate -i -a

# Cách 3: Download từ App Store
# Search "macOS Sonoma" hoặc "macOS Sequoia"
```

### Upgrade path từ macOS 10.13:
```
macOS 10.13 High Sierra
    ↓
macOS 10.14 Mojave (nếu cần)
    ↓  
macOS 10.15 Catalina (nếu cần)
    ↓
macOS 11.0 Big Sur (nếu cần)
    ↓
macOS 12.0 Monterey (nếu cần)
    ↓
macOS 13.0 Ventura (nếu cần)
    ↓
macOS 14.0 Sonoma ← Target
    ↓
macOS 15.0 Sequoia (latest)
```

**Lưu ý**: Có thể upgrade trực tiếp nếu Mac hỗ trợ.

## 🛠️ BƯỚC 4: CÀI ĐẶT XCODE 16

### Sau khi có macOS 14.0+:
```bash
# Cách 1: App Store (Khuyến nghị)
# Mở App Store > Search "Xcode" > Install

# Cách 2: Developer Portal
# https://developer.apple.com/xcode/

# Cách 3: Command Line
xcode-select --install
```

### Kiểm tra Xcode version:
```bash
xcodebuild -version
# Kết quả mong muốn: Xcode 16.0+
```

## 📱 BƯỚC 5: CÀI ĐẶT FLUTTER MỚI

### Cài Flutter 3.24+:
```bash
# Xóa Flutter cũ
rm -rf ~/development/flutter_1_22

# Cài Flutter mới
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Update PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Kiểm tra
flutter --version
# Kết quả mong muốn: Flutter 3.24+
```

## 🔧 BƯỚC 6: UPDATE PROJECT

### Update pubspec.yaml:
```yaml
name: qltinhoc
description: Ứng dụng quản lý tin học

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"  # Flutter 3.24+

dependencies:
  flutter:
    sdk: flutter
  
  # Packages mới cho Flutter 3.24
  cupertino_icons: ^1.0.8
  http: ^1.2.1
  image_picker: ^1.1.2
  permission_handler: ^11.3.1
  shared_preferences: ^2.2.3
  gsheets: ^0.5.0
  google_mlkit_text_recognition: ^0.13.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

### Update iOS configuration:
```bash
# Cập nhật iOS Deployment Target
# ios/Runner.xcodeproj/project.pbxproj
IPHONEOS_DEPLOYMENT_TARGET = 12.0;  # Minimum cho iOS 18.6

# Cập nhật Info.plist cho iOS 18
# Thêm privacy permissions mới
```

## 🎯 BƯỚC 7: BUILD CHO iOS 18.6

### Setup project:
```bash
# Clean và update
flutter clean
flutter pub get

# Tạo iOS project mới nếu cần
flutter create --platforms=ios .

# Kiểm tra setup
flutter doctor
```

### Build commands:
```bash
# Build cho Simulator iOS 18
flutter build ios --simulator --release

# Build cho Device iOS 18.6
flutter build ios --release

# Run trên device
flutter run --release
```

## 💰 CHI PHÍ UPGRADE

### Nếu Mac hỗ trợ:
- **macOS upgrade**: Miễn phí
- **Xcode 16**: Miễn phí  
- **Flutter 3.24**: Miễn phí
- **Apple Developer**: $99/năm (optional)
- **Tổng**: $0-99

### Nếu Mac không hỗ trợ:
- **Mac mini M2**: ~$599
- **MacBook Air M2**: ~$1099  
- **MacBook Pro M3**: ~$1599+
- **iMac M3**: ~$1299+

## 🔄 GIẢI PHÁP THAY THẾ (Nếu không upgrade được)

### 1. GitHub Actions (Miễn phí)
```yaml
# .github/workflows/ios.yml
name: iOS Build
on: [push]
jobs:
  build:
    runs-on: macos-14
    steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.3'
    - run: flutter build ios --release
    - uses: actions/upload-artifact@v4
      with:
        name: ios-build
        path: build/ios/iphoneos/
```

### 2. Codemagic
- Free tier: 500 build minutes/month
- Hỗ trợ iOS 18.6
- Auto build và distribute

### 3. Remote Mac services
- MacStadium: $79/month
- AWS EC2 Mac: $1.083/hour
- MacinCloud: $30/month

### 4. Downgrade iPhone
- Sử dụng iPhone cũ với iOS 16-17
- Vẫn test được app
- Tương thích với Xcode 14-15

## 📋 CHECKLIST HOÀN CHỈNH

### Pre-upgrade:
- [ ] Kiểm tra Mac model compatibility
- [ ] Backup toàn bộ dữ liệu
- [ ] Kiểm tra dung lượng disk (50GB+)
- [ ] Kiểm tra RAM (16GB+ khuyến nghị)

### Upgrade process:
- [ ] Upgrade macOS lên 14.0+
- [ ] Cài đặt Xcode 16.0+
- [ ] Cài đặt Flutter 3.24+
- [ ] Update project dependencies

### Post-upgrade:
- [ ] Test build iOS Simulator
- [ ] Test build iOS Device
- [ ] Deploy to iPhone iOS 18.6
- [ ] Verify all features work

## 🎉 KẾT QUẢ

Sau khi hoàn thành upgrade, bạn sẽ có:
- ✅ **macOS 14.0+** với Xcode 16.0+
- ✅ **Flutter 3.24+** hỗ trợ iOS 18.6
- ✅ **Build và install** trên iPhone iOS 18.6
- ✅ **Tất cả tính năng** app hoạt động đầy đủ
- ✅ **Future-proof** cho iOS updates tiếp theo
