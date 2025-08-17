#!/bin/bash

# Script để đóng gói Flutter project cho Mac
echo "🚀 Đóng gói Flutter project cho Mac..."

# Tạo thư mục tạm
mkdir -p temp_package

# Copy các file cần thiết
echo "📁 Copy source code..."
cp -r lib temp_package/
cp -r assets temp_package/
cp pubspec.yaml temp_package/
cp pubspec.lock temp_package/
cp README.md temp_package/ 2>/dev/null || echo "README.md not found, skipping..."

# Copy iOS folder nếu có
if [ -d "ios" ]; then
    echo "📱 Copy iOS configuration..."
    cp -r ios temp_package/
fi

# Tạo file hướng dẫn
cat > temp_package/SETUP_MAC.md << 'EOF'
# Hướng dẫn setup Flutter project trên Mac

## 1. Cài đặt Flutter
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Kiểm tra
flutter doctor
```

## 2. Cài đặt Xcode
- Download từ App Store
- Chạy: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
- Chạy: `sudo xcodebuild -runFirstLaunch`

## 3. Setup project
```bash
# Restore dependencies
flutter pub get

# Kiểm tra iOS setup
flutter doctor

# Tạo iOS project nếu chưa có
flutter create --platforms=ios .
```

## 4. Build IPA
```bash
# Build release
flutter build ios --release

# Hoặc build với Xcode
open ios/Runner.xcworkspace
```

## 5. Cấu hình cần thiết
- Bundle ID: com.example.tinhocstar
- Team ID: (cần Apple Developer Account)
- App Icon: assets/images/logo.png
- App Name: tinhocstar
EOF

# Tạo archive
echo "📦 Tạo archive..."
tar -czf tinhocstar-flutter-project.tar.gz -C temp_package .

# Dọn dẹp
rm -rf temp_package

echo "✅ Hoàn thành! File: tinhocstar-flutter-project.tar.gz"
echo "📤 Chuyển file này sang Mac và giải nén để tiếp tục."
