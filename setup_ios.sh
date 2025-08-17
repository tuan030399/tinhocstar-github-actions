#!/bin/bash

# Script setup iOS cho Mac
echo "🍎 Setup iOS development cho tinhocstar..."

# Kiểm tra Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter chưa được cài đặt!"
    echo "📥 Cài đặt Flutter:"
    echo "1. Download: https://docs.flutter.dev/get-started/install/macos"
    echo "2. Hoặc dùng: brew install --cask flutter"
    exit 1
fi

# Kiểm tra Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode chưa được cài đặt!"
    echo "📥 Cài đặt Xcode từ App Store"
    exit 1
fi

echo "✅ Flutter và Xcode đã sẵn sàng"

# Restore dependencies
echo "📦 Restore Flutter dependencies..."
flutter pub get

# Tạo iOS project nếu chưa có
if [ ! -d "ios" ]; then
    echo "📱 Tạo iOS project..."
    flutter create --platforms=ios .
fi

# Cấu hình iOS
echo "⚙️ Cấu hình iOS project..."

# Cập nhật Bundle ID
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i '' 's/com\.example\.qltinhoc/com.example.tinhocstar/g' ios/Runner.xcodeproj/project.pbxproj
    echo "✅ Đã cập nhật Bundle ID: com.example.tinhocstar"
fi

# Cập nhật Display Name
if [ -f "ios/Runner/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName tinhocstar" ios/Runner/Info.plist 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string tinhocstar" ios/Runner/Info.plist
    echo "✅ Đã cập nhật Display Name: tinhocstar"
fi

# Copy icon nếu có
if [ -f "assets/images/logo.png" ]; then
    echo "🖼️ Cấu hình App Icon..."
    # Tạo thư mục icon
    mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset
    
    # Copy logo (cần resize thành các kích thước khác nhau)
    echo "📝 Cần resize logo.png thành các kích thước iOS:"
    echo "   - 20x20, 29x29, 40x40, 58x58, 60x60, 80x80, 87x87, 120x120, 180x180"
    echo "   - Sử dụng online tool: https://appicon.co/"
fi

# Kiểm tra setup
echo "🔍 Kiểm tra setup..."
flutter doctor

echo ""
echo "🎉 Setup hoàn thành!"
echo ""
echo "📋 Các bước tiếp theo:"
echo "1. Mở Xcode: open ios/Runner.xcworkspace"
echo "2. Chọn Team trong Signing & Capabilities"
echo "3. Build: flutter build ios --release"
echo "4. Archive trong Xcode để tạo IPA"
echo ""
echo "💡 Lưu ý: Cần Apple Developer Account để build cho device thật"
