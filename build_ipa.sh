#!/bin/bash

# Script build IPA cho tinhocstar
echo "🚀 Build IPA cho tinhocstar..."

# Kiểm tra môi trường
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter không tìm thấy!"
    exit 1
fi

if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode không tìm thấy!"
    exit 1
fi

# Clean project
echo "🧹 Clean project..."
flutter clean
flutter pub get

# Kiểm tra iOS setup
echo "🔍 Kiểm tra iOS setup..."
flutter doctor

# Build iOS release
echo "📱 Build iOS release..."
flutter build ios --release --no-codesign

if [ $? -ne 0 ]; then
    echo "❌ Flutter build thất bại!"
    exit 1
fi

echo "✅ Flutter build thành công!"

# Hướng dẫn build IPA với Xcode
echo ""
echo "📋 Để tạo IPA file, làm theo các bước sau:"
echo ""
echo "1️⃣ Mở Xcode workspace:"
echo "   open ios/Runner.xcworkspace"
echo ""
echo "2️⃣ Trong Xcode:"
echo "   - Chọn 'Any iOS Device' hoặc device cụ thể"
echo "   - Vào Product > Archive"
echo "   - Chờ build hoàn thành"
echo ""
echo "3️⃣ Trong Organizer window:"
echo "   - Chọn archive vừa tạo"
echo "   - Click 'Distribute App'"
echo "   - Chọn distribution method:"
echo "     • Ad Hoc: Để test trên device"
echo "     • App Store: Để submit lên App Store"
echo "     • Enterprise: Cho enterprise distribution"
echo "     • Development: Cho development testing"
echo ""
echo "4️⃣ Export IPA:"
echo "   - Chọn destination folder"
echo "   - Click 'Export'"
echo "   - File IPA sẽ được tạo"
echo ""
echo "💡 Lưu ý:"
echo "   - Cần Apple Developer Account để sign"
echo "   - Cần cấu hình Team trong Signing & Capabilities"
echo "   - Bundle ID: com.example.tinhocstar"
echo ""

# Tạo script Xcode build tự động (nếu có certificate)
cat > build_with_xcode.sh << 'EOF'
#!/bin/bash

# Auto build với Xcode (cần cấu hình signing trước)
echo "🏗️ Auto build với Xcode..."

# Build archive
xcodebuild -workspace ios/Runner.xcworkspace \
           -scheme Runner \
           -configuration Release \
           -destination generic/platform=iOS \
           -archivePath build/Runner.xcarchive \
           archive

if [ $? -eq 0 ]; then
    echo "✅ Archive thành công!"
    
    # Export IPA (Ad Hoc)
    xcodebuild -exportArchive \
               -archivePath build/Runner.xcarchive \
               -exportPath build/ipa \
               -exportOptionsPlist ios/ExportOptions.plist
    
    if [ $? -eq 0 ]; then
        echo "🎉 IPA đã được tạo tại: build/ipa/tinhocstar.ipa"
    else
        echo "❌ Export IPA thất bại!"
    fi
else
    echo "❌ Archive thất bại!"
fi
EOF

chmod +x build_with_xcode.sh

# Tạo ExportOptions.plist mẫu
cat > ios/ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>compileBitcode</key>
    <false/>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
EOF

echo "📝 Đã tạo script build_with_xcode.sh và ExportOptions.plist"
echo "   (Cần cập nhật YOUR_TEAM_ID trong ExportOptions.plist)"
echo ""
echo "🎯 Build hoàn thành! Sử dụng Xcode để tạo IPA file."
