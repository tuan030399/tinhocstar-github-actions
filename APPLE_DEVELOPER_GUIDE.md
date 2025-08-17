# 🍎 Hướng dẫn Apple Developer Account & Alternatives

## 🎯 Các lựa chọn cho iOS Development

### 1️⃣ Apple ID miễn phí (Khuyến nghị cho test)
- ✅ **Miễn phí**
- ✅ **Có thể build cho device**
- ❌ **Chỉ 7 ngày**, sau đó phải build lại
- ❌ **Không thể distribute**
- ❌ **Giới hạn 3 apps cùng lúc**

### 2️⃣ Apple Developer Program ($99/năm)
- ✅ **Build unlimited**
- ✅ **Distribute qua App Store**
- ✅ **TestFlight beta testing**
- ✅ **Enterprise features**
- ❌ **Tốn phí $99/năm**

### 3️⃣ Giải pháp thay thế
- ✅ **CI/CD services** (GitHub Actions, Codemagic)
- ✅ **Nhờ người khác build**
- ✅ **Simulator testing**

## 📱 Cách sử dụng Apple ID miễn phí

### Bước 1: Tạo Apple ID
```
1. Vào: https://appleid.apple.com/
2. Click "Create Your Apple ID"
3. Điền thông tin:
   - Email
   - Password
   - Tên
   - Ngày sinh
   - Câu hỏi bảo mật
4. Verify email
```

### Bước 2: Setup trong Xcode
```
1. Mở Xcode
2. Preferences > Accounts
3. Click "+" > Apple ID
4. Đăng nhập với Apple ID vừa tạo
5. Chọn "Personal Team"
```

### Bước 3: Cấu hình Project
```
1. Mở ios/Runner.xcworkspace
2. Chọn Runner project
3. Signing & Capabilities
4. Team: Chọn Personal Team
5. Bundle ID: com.yourname.tinhocstar (phải unique)
```

### Bước 4: Build và Install
```
1. Connect iPhone/iPad qua USB
2. Trust computer trên device
3. Xcode: Product > Run
4. Trên device: Settings > General > Device Management
5. Trust developer app
```

## 💰 Apple Developer Program ($99/năm)

### Lợi ích
- **Unlimited installs**: Không giới hạn 7 ngày
- **App Store**: Có thể publish lên App Store
- **TestFlight**: Beta testing với 10,000 users
- **Advanced features**: Push notifications, CloudKit, etc.
- **Analytics**: App Store Connect analytics

### Cách đăng ký
```
1. Vào: https://developer.apple.com/programs/
2. Click "Enroll"
3. Chọn loại account:
   - Individual: Cá nhân ($99/năm)
   - Organization: Công ty ($99/năm + giấy tờ pháp lý)
4. Thanh toán $99
5. Chờ Apple approve (1-2 ngày)
```

### Yêu cầu
- **Apple ID** đã verify
- **Credit card** hoặc PayPal
- **Địa chỉ** hợp lệ
- **Giấy tờ tùy thân** (cho Organization)

## 🔄 Giải pháp thay thế (Không cần Developer Account)

### 1. GitHub Actions (Miễn phí)
```yaml
# .github/workflows/ios.yml
name: iOS Build
on: [push]
jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v2
    - uses: subosito/flutter-action@v1
    - run: flutter build ios --release --no-codesign
```

### 2. Codemagic (Flutter CI/CD)
```
1. Vào: https://codemagic.io/
2. Connect GitHub repository
3. Configure iOS build
4. Download IPA file
```

### 3. Bitrise (Mobile CI/CD)
```
1. Vào: https://www.bitrise.io/
2. Add Flutter project
3. Configure iOS workflow
4. Build và download IPA
```

## 🛠️ Setup cho Xcode 10.1 với Apple ID miễn phí

### Script tự động
```bash
#!/bin/bash
echo "🔧 Setup iOS với Apple ID miễn phí..."

# Cập nhật Bundle ID unique
BUNDLE_ID="com.$(whoami).tinhocstar"
echo "📱 Bundle ID: $BUNDLE_ID"

# Cập nhật project.pbxproj
sed -i '' "s/com.example.qltinhoc/$BUNDLE_ID/g" ios/Runner.xcodeproj/project.pbxproj

echo "✅ Setup hoàn thành!"
echo "📋 Các bước tiếp theo:"
echo "1. Mở Xcode: open ios/Runner.xcworkspace"
echo "2. Chọn Personal Team trong Signing"
echo "3. Connect device và build"
echo "4. Trust app trên device"
```

## 📊 So sánh các lựa chọn

| Tính năng | Apple ID Free | Developer Program | CI/CD |
|-----------|---------------|-------------------|-------|
| **Giá** | Miễn phí | $99/năm | Miễn phí/Trả phí |
| **Device Install** | 7 ngày | Unlimited | Không |
| **App Store** | Không | Có | Không |
| **TestFlight** | Không | Có | Không |
| **Signing** | Tự động | Manual | Tự động |
| **Phù hợp** | Test cá nhân | Production | Development |

## 🎯 Khuyến nghị cho bạn

### Với Xcode 10.1 + macOS 10.13:

**Bước 1: Test với Apple ID miễn phí**
```
1. Tạo Apple ID
2. Build với Personal Team
3. Test trên device 7 ngày
4. Rebuild khi hết hạn
```

**Bước 2: Nếu hài lòng, có 3 lựa chọn:**
- **Upgrade macOS** → Xcode mới → Developer Account
- **Sử dụng CI/CD** → Build trên cloud
- **Mua Developer Account** → $99/năm

**Bước 3: Cho production:**
- **Developer Account** nếu muốn App Store
- **Enterprise distribution** nếu chỉ internal
- **CI/CD** nếu chỉ cần file IPA

## 💡 Tips tiết kiệm

1. **Chia sẻ Developer Account**: Với team/bạn bè
2. **Sử dụng CI/CD**: Miễn phí cho open source
3. **Test trên Simulator**: Không cần device thật
4. **Apple ID rotation**: Tạo nhiều Apple ID (không khuyến khích)

## 🚀 Kết luận

**Cho việc test app tinhocstar:**
- ✅ **Bắt đầu với Apple ID miễn phí**
- ✅ **Sử dụng Simulator cho development**
- ✅ **Cân nhắc Developer Account sau**
- ✅ **CI/CD cho automation**
