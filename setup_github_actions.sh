#!/bin/bash

# Script setup GitHub Actions cho tinhocstar iOS
echo "🚀 Setup GitHub Actions cho tinhocstar iOS..."

# Kiểm tra git
if ! command -v git &> /dev/null; then
    echo "❌ Git chưa được cài đặt!"
    echo "📥 Download tại: https://git-scm.com/"
    exit 1
fi

# Nhập thông tin GitHub
echo ""
echo "📋 Nhập thông tin GitHub của bạn:"
read -p "GitHub username: " GITHUB_USERNAME
read -p "Repository name (mặc định: tinhocstar-ios): " REPO_NAME
REPO_NAME=${REPO_NAME:-tinhocstar-ios}

echo ""
echo "📱 Thông tin project:"
echo "   GitHub: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "   App name: tinhocstar"
echo "   Bundle ID: com.github.actions.tinhocstar"

# Xác nhận
read -p "Tiếp tục? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Hủy bỏ setup"
    exit 1
fi

# Tạo thư mục project
PROJECT_DIR="tinhocstar-github-actions"
echo "📁 Tạo thư mục project: $PROJECT_DIR"
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Clone repository (nếu đã tồn tại) hoặc init mới
echo "📥 Setup Git repository..."
if git ls-remote https://github.com/$GITHUB_USERNAME/$REPO_NAME.git &> /dev/null; then
    echo "📥 Clone existing repository..."
    git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git .
else
    echo "🆕 Initialize new repository..."
    git init
    git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
fi

# Copy Flutter source code
echo "📁 Copy Flutter source code..."
if [ -d "../lib" ]; then
    cp -r ../lib ./
    echo "✅ Copied lib/"
fi

if [ -d "../assets" ]; then
    cp -r ../assets ./
    echo "✅ Copied assets/"
fi

# Tạo pubspec.yaml cho Flutter 3.24
echo "📝 Tạo pubspec.yaml..."
cat > pubspec.yaml << 'EOF'
name: tinhocstar
description: Ứng dụng quản lý tin học

publish_to: 'none'

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

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/

  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
EOF

# Tạo .gitignore
echo "📝 Tạo .gitignore..."
cat > .gitignore << 'EOF'
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# iOS related
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
ios/Runner.xcworkspace/xcshareddata/

# Certificates and keys
*.p12
*.mobileprovision
*.cer
*.certSigningRequest
AuthKey_*.p8
EOF

# Tạo thư mục GitHub Actions
echo "📁 Tạo GitHub Actions workflow..."
mkdir -p .github/workflows

# Copy workflow file
cp ../ios_workflow.yml .github/workflows/ios.yml

# Tạo README.md
echo "📝 Tạo README.md..."
cat > README.md << EOF
# 🍎 tinhocstar iOS

Ứng dụng quản lý tin học được build tự động với GitHub Actions.

## 📱 Thông tin App
- **Tên**: tinhocstar
- **Platform**: iOS 12.0+
- **Bundle ID**: com.github.actions.tinhocstar
- **Build**: GitHub Actions (macOS 14 + Xcode 16)

## 🚀 Auto Build
Mỗi khi push code lên GitHub, app sẽ được build tự động:
1. Flutter 3.24.3 trên macOS 14
2. Xcode 16 với iOS 18 support
3. Tạo file IPA unsigned
4. Upload artifact để download

## 📥 Download IPA
1. Vào tab **Actions**
2. Chọn build run mới nhất
3. Download **tinhocstar-ios-xxx** artifact
4. Giải nén để có file .ipa

## 📱 Cài đặt IPA
- **AltStore**: https://altstore.io/
- **3uTools**: Sideload qua USB
- **Xcode**: Devices and Simulators

## 🔧 Development
\`\`\`bash
# Clone repository
git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git

# Install dependencies
flutter pub get

# Run on simulator
flutter run
\`\`\`

## 📋 Features
- ✅ OCR quét tài liệu
- ✅ AI gợi ý ghi chú
- ✅ Google Sheets integration
- ✅ Check trùng lặp thông minh
- ✅ Lọc ngày với Excel serial number
- ✅ Splash screen với animation

---
Built with ❤️ using GitHub Actions
EOF

# Commit và push
echo "📤 Commit và push code..."
git add .
git commit -m "🚀 Initial setup with GitHub Actions iOS build

- Add Flutter 3.24 project structure
- Configure iOS build workflow
- Setup automatic IPA generation
- Add comprehensive documentation"

# Push to GitHub
echo "📤 Pushing to GitHub..."
git branch -M main
git push -u origin main

echo ""
echo "✅ Setup hoàn thành!"
echo ""
echo "📋 Các bước tiếp theo:"
echo "1. Vào GitHub: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "2. Tab 'Actions' để xem build progress"
echo "3. Chờ build hoàn thành (~5-10 phút)"
echo "4. Download IPA từ Artifacts"
echo "5. Cài đặt bằng AltStore hoặc 3uTools"
echo ""
echo "🎯 GitHub Actions sẽ tự động build mỗi khi bạn push code!"
echo "💡 Repository public = unlimited build minutes"
echo "🔒 Repository private = 2000 minutes/tháng"
echo ""
echo "📚 Đọc thêm trong README.md"
