# SmartGroceryHub 🛒

Ứng dụng mua sắm thực phẩm thông minh dành cho iOS, giúp người dùng dễ dàng khám phá, lựa chọn và đặt mua sản phẩm tươi ngon.

## ✨ Tính năng

| Tính năng | Mô tả |
|-----------|-------|
| 🏠 **Trang chủ** | Banner ưu đãi, sản phẩm bán chạy, gian hàng theo danh mục |
| 🔍 **Tìm kiếm** | Tìm kiếm sản phẩm theo tên, hiển thị kết quả theo dạng lưới |
| 🛒 **Giỏ hàng** | Thêm/xóa sản phẩm, điều chỉnh số lượng, đồng bộ Firestore |
| ❤️ **Yêu thích** | Lưu sản phẩm yêu thích, đồng bộ real-time với Firestore |
| 📦 **Đơn hàng** | Theo dõi lịch sử đơn hàng với trạng thái chi tiết |
| 👤 **Tài khoản** | Quản lý thông tin cá nhân, đơn hàng, cài đặt |
| 🎯 **Onboarding** | Giới thiệu app cho người dùng mới với 3 trang đẹp mắt |
| 🔐 **Xác thực** | Đăng nhập / Đăng ký qua Firebase Authentication |

## 🛠 Công nghệ

- **SwiftUI** — Giao diện declarative, hiện đại
- **MVVM Architecture** — Tách biệt rõ ràng View / ViewModel / Model
- **Firebase Auth** — Xác thực người dùng (Email/Password)
- **Cloud Firestore** — Cơ sở dữ liệu real-time cho sản phẩm, giỏ hàng, yêu thích, đơn hàng
- **SDWebImageSwiftUI** — Tải và cache ảnh sản phẩm 
- **Gilroy Font** — Typography nhất quán toàn ứng dụng

## 📁 Cấu trúc dự án

```
SmartGroceryHub/
├── Model/          → ProductModel, CartItemModel, TypeModel, UserModel, OrderModel
├── ViewModel/      → MainVM, HomeVM, CartVM, ExploreVM, FavoritesVM, OrderVM
├── View/
│   ├── Home/       → HomeView, ProductDetailView
│   ├── Explore/    → ExploreView
│   ├── Cart/       → CartView
│   ├── Favorites/  → FavoritesView
│   ├── Account/    → AccountView, OrderHistoryView, ProfileEditView, AboutView
│   ├── Login/      → WelcomeView, SignInView, LoginView, SignUpView
│   ├── Onboarding/ → OnboardingView
│   └── MainTab/    → MainTabView
├── UICommon/       → Reusable components (ProductCell, CartItemRow, TabButton, etc.)
└── Font/           → Gilroy font files
```

## 🚀 Cài đặt và chạy

### Yêu cầu
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Cocoapods hoặc SPM (cho Firebase và SDWebImage)

### Các bước
1. Clone repository: `git clone <repo-url>`
2. Mở `SmartGroceryHub.xcodeproj` trong Xcode
3. Thêm file `GoogleService-Info.plist` từ Firebase Console
4. Build và chạy trên Simulator hoặc thiết bị thật

## 📊 Firestore Collections

| Collection | Mô tả |
|-----------|-------|
| `products` | Danh sách sản phẩm |
| `types` | Danh mục sản phẩm |
| `users` | Thông tin người dùng |
| `favorites/{userId}/items` | Sản phẩm yêu thích |
| `carts/{userId}` | Giỏ hàng |
| `orders/{userId}/items` | Lịch sử đơn hàng |

## 👤 Tác giả

**Phạm Trường Giang**

© 2025 Smart Grocery Hub. All rights reserved.
