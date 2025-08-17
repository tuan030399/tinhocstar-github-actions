# 🚀 GitHub Actions - Tạo IPA miễn phí

## 📋 Tổng quan
GitHub Actions cho phép build iOS app trên macOS cloud miễn phí:
- **2000 phút/tháng** cho private repos
- **Unlimited** cho public repos
- **macOS 14 Sonoma** với Xcode 16+
- **Tự động build** khi push code

## 🎯 BƯỚC 1: TẠO GITHUB REPOSITORY

### 1.1 Tạo GitHub account (nếu chưa có)
```
1. Vào: https://github.com
2. Click "Sign up"
3. Tạo account với email
4. Verify email
```

### 1.2 Tạo repository mới
```
1. Login GitHub
2. Click "+" > "New repository"
3. Repository name: tinhocstar-ios
4. Description: Ứng dụng quản lý tin học
5. Chọn: Public (để có unlimited minutes)
6. ✅ Add a README file
7. Click "Create repository"
```

### 1.3 Clone repository về máy
```bash
# Trên máy Windows
git clone https://github.com/YOUR_USERNAME/tinhocstar-ios.git
cd tinhocstar-ios
```

## 🎯 BƯỚC 2: UPLOAD CODE LÊN GITHUB

### 2.1 Copy Flutter project
```bash
# Copy files từ project cũ
cp -r /path/to/qltinhoc/lib ./
cp -r /path/to/qltinhoc/assets ./
cp /path/to/qltinhoc/pubspec.yaml ./
```

### 2.2 Tạo pubspec.yaml cho Flutter 3.24
```yaml
name: tinhocstar
description: Ứng dụng quản lý tin học

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  cupertino_icons: ^1.0.8
  http: ^1.2.1
  image_picker: ^1.1.2
  permission_handler: ^11.3.1
  shared_preferences: ^2.2.3
  intl: ^0.19.0
  # Thêm các packages khác nếu cần

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

### 2.3 Tạo .gitignore
```bash
# Tạo file .gitignore
cat > .gitignore << 'EOF'
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
ios/Runner.xcworkspace/xcshareddata/

# IDE
.vscode/
.idea/
*.iml

# OS
.DS_Store
Thumbs.db

# Certificates (sẽ dùng secrets)
*.p12
*.mobileprovision
*.cer
*.certSigningRequest
EOF
```

### 2.4 Push code lên GitHub
```bash
git add .
git commit -m "Initial Flutter project"
git push origin main
```

## 🎯 BƯỚC 3: TẠO GITHUB ACTIONS WORKFLOW

### 3.1 Tạo thư mục workflow
```bash
mkdir -p .github/workflows
```

### 3.2 Tạo file iOS workflow
```yaml
# .github/workflows/ios.yml
name: iOS Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:  # Cho phép chạy manual

jobs:
  build:
    name: Build iOS
    runs-on: macos-14  # macOS Sonoma với Xcode 16
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.3'
        channel: 'stable'
    
    - name: Flutter doctor
      run: flutter doctor -v
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Create iOS project
      run: flutter create --platforms=ios .
    
    - name: Configure iOS
      run: |
        # Cập nhật Bundle ID
        sed -i '' 's/com.example.tinhocstar/com.github.tinhocstar/g' ios/Runner.xcodeproj/project.pbxproj
        
        # Cập nhật Display Name
        /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName tinhocstar" ios/Runner/Info.plist
    
    - name: Build iOS (No Codesign)
      run: flutter build ios --release --no-codesign
    
    - name: Create IPA (Unsigned)
      run: |
        cd build/ios/iphoneos
        mkdir Payload
        cp -r Runner.app Payload/
        zip -r tinhocstar-unsigned.ipa Payload/
    
    - name: Upload IPA artifact
      uses: actions/upload-artifact@v4
      with:
        name: tinhocstar-ios
        path: build/ios/iphoneos/tinhocstar-unsigned.ipa
        retention-days: 30
```

### 3.3 Push workflow lên GitHub
```bash
git add .github/workflows/ios.yml
git commit -m "Add iOS build workflow"
git push origin main
```

## 🎯 BƯỚC 4: CHẠY BUILD VÀ DOWNLOAD IPA

### 4.1 Trigger build
```
1. Vào GitHub repository
2. Tab "Actions"
3. Chọn "iOS Build" workflow
4. Click "Run workflow" > "Run workflow"
5. Chờ build hoàn thành (~5-10 phút)
```

### 4.2 Download IPA
```
1. Sau khi build xong (✅ green checkmark)
2. Click vào build run
3. Scroll xuống "Artifacts" section
4. Click "tinhocstar-ios" để download
5. Giải nén để có file .ipa
```

## 🎯 BƯỚC 5: CÀI ĐẶT IPA (UNSIGNED)

### 5.1 Cài đặt qua AltStore (Khuyến nghị)
```
1. Download AltStore: https://altstore.io/
2. Cài AltStore trên máy tính
3. Cài AltStore app trên iPhone
4. Sideload file .ipa qua AltStore
5. Trust developer trong Settings
```

### 5.2 Cài đặt qua 3uTools
```
1. Download 3uTools
2. Connect iPhone qua USB
3. Vào "Apps" > "Install"
4. Chọn file .ipa
5. Trust developer trên iPhone
```

### 5.3 Cài đặt qua Xcode (nếu có Mac)
```
1. Mở Xcode
2. Window > Devices and Simulators
3. Chọn iPhone
4. Drag & drop file .ipa
5. Trust developer
```

## 💡 TIPS VÀ LƯU Ý

### Giới hạn GitHub Actions:
- **2000 phút/tháng** cho private repos
- **Unlimited** cho public repos
- **1 build ≈ 5-10 phút**
- **Có thể chạy 200-400 builds/tháng**

### IPA unsigned limitations:
- **Chỉ cài được 7 ngày** (như Personal Team)
- **Cần resign** sau 7 ngày
- **Không thể distribute** rộng rãi
- **Chỉ cho testing** cá nhân

### Cải thiện workflow:
- Thêm cache để build nhanh hơn
- Tự động increment version
- Notify qua Telegram/Discord
- Upload lên TestFlight (cần Developer Account)

## 🔧 TROUBLESHOOTING

### Build failed:
```bash
# Kiểm tra logs trong Actions tab
# Thường do:
# - pubspec.yaml syntax error
# - Missing dependencies
# - iOS configuration issues
```

### IPA không cài được:
```bash
# Kiểm tra:
# - iPhone iOS version compatibility
# - Trust developer settings
# - AltStore/3uTools setup
```

### Hết GitHub Actions minutes:
```bash
# Giải pháp:
# - Chuyển repo sang public (unlimited)
# - Optimize workflow (cache, conditions)
# - Sử dụng self-hosted runners
```
