# 📱 Hướng dẫn cài đặt IPA từ GitHub Actions

## 🎯 Tổng quan
File IPA từ GitHub Actions là **unsigned** (chưa ký), cần sideload để cài đặt trên iPhone.

## 📥 BƯỚC 1: DOWNLOAD IPA TỪ GITHUB

### 1.1 Vào GitHub repository
```
1. Mở: https://github.com/YOUR_USERNAME/tinhocstar-ios
2. Click tab "Actions"
3. Chọn build run mới nhất (✅ green checkmark)
4. Scroll xuống "Artifacts" section
5. Click "tinhocstar-ios-XXX" để download
6. Giải nén file zip để có file .ipa
```

### 1.2 Kiểm tra file IPA
```bash
# File sẽ có tên: tinhocstar-unsigned.ipa
# Kích thước: ~20-50MB
# Format: iOS App Store Package
```

## 📱 BƯỚC 2: CÀI ĐẶT IPA

### 🥇 CÁCH 1: AltStore (Khuyến nghị)

#### Setup AltStore:
```
1. Download AltStore Desktop:
   - Windows: https://altstore.io/
   - macOS: https://altstore.io/

2. Cài đặt AltStore Desktop trên máy tính

3. Cài đặt AltStore app trên iPhone:
   - Connect iPhone qua USB
   - Trust computer trên iPhone
   - Mở AltStore Desktop
   - Click "Install AltStore"
   - Nhập Apple ID (không cần Developer Account)
```

#### Sideload IPA:
```
1. Mở AltStore app trên iPhone
2. Tab "My Apps"
3. Click "+" ở góc trên
4. Chọn file tinhocstar-unsigned.ipa
5. Nhập Apple ID password
6. Chờ cài đặt hoàn thành
7. Trust developer trong Settings
```

### 🥈 CÁCH 2: 3uTools

#### Setup 3uTools:
```
1. Download: https://www.3u.com/
2. Cài đặt trên Windows/Mac
3. Connect iPhone qua USB
4. Trust computer trên iPhone
```

#### Install IPA:
```
1. Mở 3uTools
2. Tab "Apps"
3. Click "Install" 
4. Chọn file .ipa
5. Click "Install"
6. Chờ cài đặt hoàn thành
7. Trust developer trên iPhone
```

### 🥉 CÁCH 3: Xcode (Nếu có Mac)

```
1. Mở Xcode
2. Window > Devices and Simulators
3. Chọn iPhone trong danh sách
4. Drag & drop file .ipa vào "Installed Apps"
5. Chờ cài đặt hoàn thành
6. Trust developer trên iPhone
```

### 🔧 CÁCH 4: iOS App Installer

```
1. Download iOS App Installer
2. Connect iPhone qua USB
3. Browse và chọn file .ipa
4. Click "Install"
5. Trust developer trên iPhone
```

## 🔐 BƯỚC 3: TRUST DEVELOPER

### Sau khi cài đặt IPA:
```
1. Vào Settings trên iPhone
2. General > VPN & Device Management
3. Tìm "Developer App" section
4. Tap vào Apple ID của bạn
5. Tap "Trust [Your Apple ID]"
6. Tap "Trust" để xác nhận
```

### Nếu không thấy Developer App:
```
1. Thử mở app tinhocstar
2. Sẽ có popup "Untrusted Developer"
3. Tap "Cancel"
4. Vào Settings > General > VPN & Device Management
5. Làm theo bước trust ở trên
```

## ⚠️ GIỚI HẠN VÀ LƯU Ý

### Giới hạn 7 ngày:
- **App chỉ hoạt động 7 ngày** với Apple ID thường
- **Sau 7 ngày**: App sẽ không mở được
- **Giải pháp**: Sideload lại file IPA mới

### Giới hạn 3 apps:
- **Tối đa 3 apps** cùng lúc với 1 Apple ID
- **Nếu vượt quá**: Phải revoke app cũ
- **Trong AltStore**: Manage apps trong "My Apps"

### Yêu cầu kết nối:
- **AltStore**: Cần kết nối WiFi cùng mạng với máy tính
- **3uTools**: Cần USB connection
- **Refresh**: Cần refresh trước khi hết hạn

## 🔄 REFRESH APP (Gia hạn)

### Với AltStore:
```
1. Mở AltStore app trên iPhone
2. Tab "My Apps"
3. Tìm app tinhocstar
4. Tap "Refresh" (nếu gần hết hạn)
5. Nhập Apple ID password
```

### Với 3uTools:
```
1. Connect iPhone qua USB
2. Mở 3uTools
3. Reinstall file .ipa
4. Trust developer lại
```

## 🚨 TROUBLESHOOTING

### App không cài được:
```
❌ "Unable to install"
✅ Kiểm tra:
   - iPhone storage đủ không
   - iOS version tương thích (12.0+)
   - Apple ID đã đăng nhập chưa
   - Trust computer chưa
```

### App crash khi mở:
```
❌ App bị crash
✅ Kiểm tra:
   - Đã trust developer chưa
   - App còn hạn không (7 ngày)
   - iOS version compatibility
   - Reinstall app
```

### AltStore không connect:
```
❌ "Could not find AltServer"
✅ Giải pháp:
   - Cùng WiFi network
   - AltServer running trên máy tính
   - Firewall không block
   - Restart AltServer
```

### 3uTools không nhận iPhone:
```
❌ Device not detected
✅ Giải pháp:
   - USB cable tốt
   - Trust computer
   - iTunes/3uTools drivers
   - Restart iPhone
```

## 💡 TIPS VÀ TRICKS

### Tự động refresh:
- **AltStore**: Bật "Background App Refresh"
- **Notification**: Nhận thông báo khi gần hết hạn
- **WiFi**: Giữ kết nối WiFi để auto-refresh

### Multiple Apple IDs:
- **Sử dụng nhiều Apple ID** để có thêm 3 app slots
- **Family Sharing**: Share với thành viên gia đình
- **Developer Account**: $99/năm cho unlimited

### Backup IPA:
- **Save file .ipa** để reinstall sau
- **GitHub Releases**: Upload IPA lên GitHub Releases
- **Cloud storage**: Backup trên Google Drive/iCloud

## 🎯 KẾT LUẬN

**Quy trình hoàn chỉnh:**
1. ✅ **Build** trên GitHub Actions (tự động)
2. ✅ **Download** IPA từ Artifacts
3. ✅ **Sideload** bằng AltStore/3uTools
4. ✅ **Trust** developer trên iPhone
5. ✅ **Refresh** mỗi 7 ngày

**Lợi ích:**
- 🆓 **Miễn phí** hoàn toàn
- 🔄 **Tự động** build khi push code
- 📱 **iOS 18.6** support
- 🚀 **Không cần Mac** để build

**Hạn chế:**
- ⏰ **7 ngày** hết hạn
- 📱 **3 apps** tối đa
- 🔄 **Cần refresh** thường xuyên
- 🔐 **Không distribute** được
