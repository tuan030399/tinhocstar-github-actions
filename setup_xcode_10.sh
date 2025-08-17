#!/bin/bash

# Setup script cho Xcode 10.1 và macOS 10.13
echo "🍎 Setup tinhocstar cho Xcode 10.1..."

# Kiểm tra macOS version
MACOS_VERSION=$(sw_vers -productVersion)
echo "📱 macOS Version: $MACOS_VERSION"

if [[ "$MACOS_VERSION" < "10.13" ]]; then
    echo "❌ Cần macOS 10.13 trở lên!"
    exit 1
fi

# Kiểm tra Xcode version
XCODE_VERSION=$(xcodebuild -version | head -n1 | awk '{print $2}')
echo "🛠️ Xcode Version: $XCODE_VERSION"

# Cài đặt Flutter 1.22.6 (tương thích với Xcode 10.1)
echo "📦 Setup Flutter 1.22.6..."

if [ ! -d "$HOME/development" ]; then
    mkdir -p $HOME/development
fi

cd $HOME/development

# Download Flutter 1.22.6 nếu chưa có
if [ ! -d "flutter_1_22" ]; then
    echo "⬇️ Download Flutter 1.22.6..."
    git clone https://github.com/flutter/flutter.git -b 1.22.6-stable flutter_1_22
fi

# Thêm Flutter vào PATH
FLUTTER_PATH="$HOME/development/flutter_1_22/bin"
if ! echo $PATH | grep -q "$FLUTTER_PATH"; then
    echo "🔧 Thêm Flutter vào PATH..."
    echo "export PATH=\"\$PATH:$FLUTTER_PATH\"" >> ~/.bash_profile
    export PATH="$PATH:$FLUTTER_PATH"
fi

# Kiểm tra Flutter
echo "🔍 Kiểm tra Flutter..."
$FLUTTER_PATH/flutter --version

# Quay về project directory
cd - > /dev/null

# Tạo pubspec.yaml tương thích với Flutter 1.22
echo "📝 Tạo pubspec.yaml cho Flutter 1.22..."
cat > pubspec.yaml << 'EOF'
name: qltinhoc
description: Ứng dụng quản lý tin học

version: 1.0.0+1

environment:
  sdk: ">=2.7.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # Packages tương thích với Flutter 1.22
  cupertino_icons: ^1.0.0
  http: ^0.12.2
  image_picker: ^0.6.7+22
  permission_handler: ^5.1.0+2
  shared_preferences: ^0.5.12+4
  intl: ^0.16.1
  
  # Thay thế các packages không tương thích
  # gsheets: ^0.3.2  # Có thể không tương thích
  # google_ml_kit: ^0.6.0  # Version cũ

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/images/
EOF

# Tạo iOS project nếu chưa có
if [ ! -d "ios" ]; then
    echo "📱 Tạo iOS project..."
    $FLUTTER_PATH/flutter create --platforms=ios .
fi

# Cấu hình iOS cho Xcode 10.1
echo "⚙️ Cấu hình iOS project..."

# Tạo Bundle ID unique
BUNDLE_ID="com.$(whoami).tinhocstar"
echo "📱 Bundle ID: $BUNDLE_ID"

# Cập nhật project.pbxproj
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i '' "s/com\.example\.qltinhoc/$BUNDLE_ID/g" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*;/IPHONEOS_DEPLOYMENT_TARGET = 9.0;/g" ios/Runner.xcodeproj/project.pbxproj
fi

# Cập nhật Info.plist
cat > ios/Runner/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>tinhocstar</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>tinhocstar</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
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
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>NSCameraUsageDescription</key>
	<string>App cần camera để quét tài liệu</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>App cần truy cập thư viện ảnh</string>
</dict>
</plist>
EOF

# Restore dependencies
echo "📦 Restore dependencies..."
$FLUTTER_PATH/flutter pub get

# Kiểm tra setup
echo "🔍 Kiểm tra setup..."
$FLUTTER_PATH/flutter doctor

echo ""
echo "✅ Setup hoàn thành!"
echo ""
echo "📋 Các bước tiếp theo:"
echo "1. Mở Xcode: open ios/Runner.xcworkspace"
echo "2. Trong Xcode:"
echo "   - Chọn Runner project"
echo "   - Vào Signing & Capabilities"
echo "   - Team: Chọn Personal Team (Apple ID)"
echo "   - Bundle ID đã được set: $BUNDLE_ID"
echo "3. Build:"
echo "   - Simulator: $FLUTTER_PATH/flutter run"
echo "   - Device: Connect iPhone và run trong Xcode"
echo ""
echo "💡 Lưu ý:"
echo "- Cần Apple ID để build cho device"
echo "- App chỉ hoạt động 7 ngày với Personal Team"
echo "- Cần rebuild sau 7 ngày"
echo ""
echo "📚 Đọc thêm:"
echo "- XCODE_10_SETUP.md: Hướng dẫn chi tiết"
echo "- APPLE_DEVELOPER_GUIDE.md: Về Apple Developer Account"
