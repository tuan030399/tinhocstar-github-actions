#!/bin/bash

# Build script cho Xcode 10.1
echo "🏗️ Build tinhocstar với Xcode 10.1..."

# Tìm Flutter path
FLUTTER_PATH=""
if [ -d "$HOME/development/flutter_1_22/bin" ]; then
    FLUTTER_PATH="$HOME/development/flutter_1_22/bin/flutter"
elif command -v flutter &> /dev/null; then
    FLUTTER_PATH="flutter"
else
    echo "❌ Flutter không tìm thấy!"
    echo "💡 Chạy setup_xcode_10.sh trước"
    exit 1
fi

echo "📱 Flutter path: $FLUTTER_PATH"

# Kiểm tra Flutter version
FLUTTER_VERSION=$($FLUTTER_PATH --version | head -n1 | awk '{print $2}')
echo "📱 Flutter version: $FLUTTER_VERSION"

if [[ "$FLUTTER_VERSION" > "2.0" ]]; then
    echo "⚠️ Cảnh báo: Flutter version cao có thể không tương thích với Xcode 10.1"
    echo "💡 Khuyến nghị sử dụng Flutter 1.22.6"
fi

# Clean project
echo "🧹 Clean project..."
$FLUTTER_PATH clean
$FLUTTER_PATH pub get

# Kiểm tra iOS setup
echo "🔍 Kiểm tra iOS setup..."
$FLUTTER_PATH doctor

# Menu lựa chọn build
echo ""
echo "📋 Chọn loại build:"
echo "1. Simulator (không cần signing)"
echo "2. Device Debug (cần Apple ID)"
echo "3. Device Release (cần Apple ID)"
echo "4. Mở Xcode để build manual"
echo ""
read -p "Nhập lựa chọn (1-4): " choice

case $choice in
    1)
        echo "📱 Build cho iOS Simulator..."
        $FLUTTER_PATH build ios --simulator --debug
        if [ $? -eq 0 ]; then
            echo "✅ Build simulator thành công!"
            echo "🚀 Chạy: $FLUTTER_PATH run"
        else
            echo "❌ Build simulator thất bại!"
        fi
        ;;
    2)
        echo "📱 Build Device Debug..."
        $FLUTTER_PATH build ios --debug
        if [ $? -eq 0 ]; then
            echo "✅ Build debug thành công!"
            echo "📋 Các bước tiếp theo:"
            echo "1. Mở Xcode: open ios/Runner.xcworkspace"
            echo "2. Connect iPhone/iPad"
            echo "3. Chọn device và run"
            echo "4. Trust app trên device"
        else
            echo "❌ Build debug thất bại!"
            echo "💡 Kiểm tra signing trong Xcode"
        fi
        ;;
    3)
        echo "📱 Build Device Release..."
        $FLUTTER_PATH build ios --release
        if [ $? -eq 0 ]; then
            echo "✅ Build release thành công!"
            echo "📋 Các bước tiếp theo:"
            echo "1. Mở Xcode: open ios/Runner.xcworkspace"
            echo "2. Product > Archive"
            echo "3. Distribute App"
        else
            echo "❌ Build release thất bại!"
            echo "💡 Kiểm tra signing trong Xcode"
        fi
        ;;
    4)
        echo "🛠️ Mở Xcode..."
        open ios/Runner.xcworkspace
        echo "📋 Trong Xcode:"
        echo "1. Chọn Runner project"
        echo "2. Signing & Capabilities > Chọn Team"
        echo "3. Chọn device/simulator"
        echo "4. Product > Run hoặc Archive"
        ;;
    *)
        echo "❌ Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac

echo ""
echo "💡 Tips cho Xcode 10.1:"
echo "- Chỉ hỗ trợ iOS 12.x trở xuống"
echo "- Personal Team: App hoạt động 7 ngày"
echo "- Developer Account: Unlimited"
echo "- Simulator: Không cần signing"
echo ""
echo "📚 Tài liệu:"
echo "- XCODE_10_SETUP.md: Setup chi tiết"
echo "- APPLE_DEVELOPER_GUIDE.md: Về signing"
