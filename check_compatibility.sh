#!/bin/bash

# Script kiểm tra tương thích Mac với iOS 18.6
echo "🔍 Kiểm tra tương thích Mac với iOS 18.6..."
echo ""

# Lấy thông tin hệ thống
MACOS_VERSION=$(sw_vers -productVersion)
MODEL_NAME=$(system_profiler SPHardwareDataType | grep "Model Name" | awk -F': ' '{print $2}' | xargs)
MODEL_ID=$(system_profiler SPHardwareDataType | grep "Model Identifier" | awk -F': ' '{print $2}' | xargs)
CHIP_INFO=$(system_profiler SPHardwareDataType | grep "Chip\|Processor Name" | awk -F': ' '{print $2}' | xargs)
MEMORY=$(system_profiler SPHardwareDataType | grep "Memory" | awk -F': ' '{print $2}' | xargs)

echo "📱 Thông tin Mac hiện tại:"
echo "   Model: $MODEL_NAME"
echo "   Identifier: $MODEL_ID"
echo "   Chip: $CHIP_INFO"
echo "   RAM: $MEMORY"
echo "   macOS: $MACOS_VERSION"
echo ""

# Kiểm tra Xcode hiện tại
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n1 | awk '{print $2}')
    echo "🛠️ Xcode hiện tại: $XCODE_VERSION"
else
    echo "🛠️ Xcode: Chưa cài đặt"
fi

# Kiểm tra Flutter hiện tại
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n1 | awk '{print $2}')
    echo "📦 Flutter hiện tại: $FLUTTER_VERSION"
else
    echo "📦 Flutter: Chưa cài đặt"
fi

echo ""
echo "🎯 Yêu cầu cho iOS 18.6:"
echo "   macOS: 14.0+ (Sonoma)"
echo "   Xcode: 16.0+"
echo "   Flutter: 3.24+"
echo ""

# Kiểm tra tương thích macOS 14.0
echo "🔍 Kiểm tra tương thích macOS 14.0..."

# Danh sách Mac models hỗ trợ macOS 14.0
SUPPORTED_MODELS=(
    "MacBookAir10,1"    # MacBook Air M1 2020
    "Mac13,1"           # MacBook Air M2 2022
    "Mac13,2"           # MacBook Air M2 2022
    "Mac14,2"           # MacBook Air M2 2023
    "Mac15,12"          # MacBook Air M3 2024
    "Mac15,13"          # MacBook Air M3 2024
    "MacBookPro16,1"    # MacBook Pro 16" 2019
    "MacBookPro16,2"    # MacBook Pro 13" 2020
    "MacBookPro16,3"    # MacBook Pro 13" 2020
    "MacBookPro16,4"    # MacBook Pro 16" 2019
    "MacBookPro17,1"    # MacBook Pro 13" M1 2020
    "MacBookPro18,1"    # MacBook Pro 16" M1 2021
    "MacBookPro18,2"    # MacBook Pro 16" M1 2021
    "MacBookPro18,3"    # MacBook Pro 14" M1 2021
    "MacBookPro18,4"    # MacBook Pro 14" M1 2021
    "Mac14,5"           # MacBook Pro 14" M2 2023
    "Mac14,6"           # MacBook Pro 16" M2 2023
    "Mac14,7"           # MacBook Pro 13" M2 2022
    "Mac14,9"           # MacBook Pro 14" M2 2023
    "Mac14,10"          # MacBook Pro 16" M2 2023
    "Mac15,3"           # MacBook Pro 14" M3 2023
    "Mac15,6"           # MacBook Pro 16" M3 2023
    "Mac15,7"           # MacBook Pro 14" M3 2024
    "Mac15,8"           # MacBook Pro 16" M3 2024
    "Mac15,9"           # MacBook Pro 14" M3 2024
    "Mac15,10"          # MacBook Pro 16" M3 2024
    "Mac15,11"          # MacBook Pro 14" M3 2024
    "iMac20,1"          # iMac 27" 2020
    "iMac20,2"          # iMac 27" 2020
    "iMac21,1"          # iMac 24" M1 2021
    "iMac21,2"          # iMac 24" M1 2021
    "Mac15,4"           # iMac 24" M3 2023
    "Mac15,5"           # iMac 24" M3 2023
    "iMacPro1,1"        # iMac Pro 2017
    "Macmini8,1"        # Mac mini 2018
    "Macmini9,1"        # Mac mini M1 2020
    "Mac14,3"           # Mac mini M2 2023
    "Mac14,12"          # Mac mini M2 Pro 2023
    "Mac13,1"           # Mac Studio M1 Max 2022
    "Mac13,2"           # Mac Studio M1 Ultra 2022
    "Mac14,13"          # Mac Studio M2 Max 2023
    "Mac14,14"          # Mac Studio M2 Ultra 2023
    "MacPro7,1"         # Mac Pro 2019
    "Mac14,8"           # Mac Pro M2 Ultra 2023
)

# Kiểm tra model có trong danh sách hỗ trợ không
SUPPORTED=false
for model in "${SUPPORTED_MODELS[@]}"; do
    if [[ "$MODEL_ID" == "$model" ]]; then
        SUPPORTED=true
        break
    fi
done

# Kiểm tra theo năm cho Intel Macs
if [[ "$CHIP_INFO" == *"Intel"* ]]; then
    # Kiểm tra MacBook Pro Intel
    if [[ "$MODEL_ID" == MacBookPro* ]]; then
        YEAR=$(echo $MODEL_ID | grep -o '[0-9]\+' | head -1)
        if [[ $YEAR -ge 16 ]]; then  # MacBookPro16,x = 2019+
            SUPPORTED=true
        fi
    fi
    
    # Kiểm tra iMac Intel
    if [[ "$MODEL_ID" == iMac* ]]; then
        YEAR=$(echo $MODEL_ID | grep -o '[0-9]\+' | head -1)
        if [[ $YEAR -ge 20 ]]; then  # iMac20,x = 2020+
            SUPPORTED=true
        fi
    fi
fi

echo ""
if [ "$SUPPORTED" = true ]; then
    echo "✅ MAC CỦA BẠN HỖ TRỢ macOS 14.0+"
    echo ""
    echo "🚀 Bạn có thể upgrade để hỗ trợ iOS 18.6:"
    echo "   1. Upgrade macOS lên 14.0+ Sonoma"
    echo "   2. Cài đặt Xcode 16.0+"
    echo "   3. Update Flutter lên 3.24+"
    echo "   4. Build cho iPhone iOS 18.6"
    echo ""
    echo "📋 Các bước tiếp theo:"
    echo "   - Đọc UPGRADE_GUIDE.md để upgrade"
    echo "   - Backup dữ liệu trước khi upgrade"
    echo "   - Kiểm tra dung lượng disk (cần 50GB+)"
    
    # Kiểm tra dung lượng disk
    AVAILABLE_GB=$(df -h / | awk 'NR==2{print $4}' | sed 's/Gi//')
    echo "   - Dung lượng available: $(df -h / | awk 'NR==2{print $4}')"
    
else
    echo "❌ MAC CỦA BẠN KHÔNG HỖ TRỢ macOS 14.0+"
    echo ""
    echo "🔄 Giải pháp thay thế:"
    echo "   1. Sử dụng GitHub Actions (miễn phí)"
    echo "   2. Sử dụng Codemagic CI/CD"
    echo "   3. Thuê dịch vụ Remote Mac"
    echo "   4. Mua Mac mới (Mac mini M2: ~$599)"
    echo "   5. Test trên iPhone iOS cũ hơn"
    echo ""
    echo "📋 Khuyến nghị:"
    echo "   - Đọc iOS_18_COMPATIBILITY.md"
    echo "   - Cân nhắc upgrade hardware"
    echo "   - Sử dụng CI/CD cho development"
fi

echo ""
echo "📚 Tài liệu tham khảo:"
echo "   - iOS_18_COMPATIBILITY.md: Chi tiết tương thích"
echo "   - UPGRADE_GUIDE.md: Hướng dẫn upgrade"
echo "   - APPLE_DEVELOPER_GUIDE.md: Về Apple Developer Account"
