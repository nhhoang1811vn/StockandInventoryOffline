# Import from contacts (Suppliers + Customers) — design

Ngày: 2026-11-27. Cỡ: thay đổi nhỏ (một luồng, bốn màn hình). Làm ở Offline trước, port sang Online
sau.

## Ý định

Ở `SuppliersPage` và `CustomersPage`, nút help (`?`) trên AppBar chuyển vào overflow menu (⋮).
Menu thêm mục **Import from contacts**: chọn **một** liên hệ bằng bộ chọn của hệ điều hành,
map vào model, mở trang Save với dữ liệu điền sẵn để người dùng xem lại rồi lưu.
Lý do: nhập nhanh nhà cung cấp/khách hàng đã có trong danh bạ thay vì gõ tay.
Help markdown đã ghi "import from Contacts" (`md_resource_en.dart:230`), tính năng chưa tồn tại.

## Mục tiêu / không mục tiêu

- Có: overflow menu, import một liên hệ, map đủ trường có thể, kiểm tra giới hạn free trước khi mở
  bộ chọn.
- Không: chọn nhiều người, ảnh đại diện (`file`), chống trùng, Windows (ẩn mục này), `taxID`/
  `bankDetail` (danh bạ không có).
- Anti-goal: không đụng data layer (`repo/`, `data/`, `domain/`); không để import bỏ qua giới hạn
  free.

## Cách làm đã chọn

Các phương án đã xét: (A) tự viết trang chọn nhiều người bằng `flutter_contacts`; (B) bộ chọn hệ
điều hành,
một người; (C) chọn nhiều rồi cắt phần vượt. Người dùng chọn **B, một người**.
Package: `flutter_native_contact_picker_plus` (bản 1.3.2), xin quyền để lấy đủ trường (hướng 2).

### Luồng

1. Bấm "Import from contacts" → cubit gọi `isValidToAddMoreSupplier()` / `…Customer()` (đã có).
2. Hết chỗ → emit `OpenBuySubscriptionDialogState` (popup có sẵn, chuỗi
   `buy_subscription_to_add_more_entity`). Dừng.
3. Còn chỗ → **chỉ trên Android** xin quyền contacts bằng `permission_handler` (đã có, 12.0.3). Bị
   từ chối thì vẫn tiếp tục, chỉ lấy name + phone. **iOS không xin quyền** (quyết định sau review:
   plugin đọc `CNContact.note` khi đã có quyền, có thể gây exception native không bắt được nếu thiếu
   entitlement notes; iOS chỉ lấy tên + các số điện thoại, chưa kiểm chứng trên máy thật).
4. `FlutterContactPickerPlus().selectContact()`; `null` (người dùng hủy) → không làm gì.
5. Map sang `Supplier`/`Customer` rồi `onAddItem(item)` → mở trang Save điền sẵn (luồng sẵn có,
   Offline gán `storeId`).

### Mapping

| Property                      | Nguồn                                                                                                                                |
|-------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `name`                        | `fullName`, rỗng thì `organizationInfo.company`; cả hai rỗng thì bỏ qua                                                              |
| `phone`                       | `selectedPhoneNumber` (Android chỉ trả số được chọn); nếu rỗng (iOS) thì số đầu của `phoneNumbers`, các số còn lại vào `description` |
| `email`                       | email đầu tiên                                                                                                                       |
| `address`                     | địa chỉ đầu tiên, ghép `street, city, state, postalCode, country`, bỏ phần rỗng                                                      |
| `description`                 | tên công ty (+ chức danh), ghi chú, email thừa, số thừa; mỗi phần một dòng                                                           |
| `taxID`, `bankDetail`, `file` | để trống                                                                                                                             |

### Menu

Thứ tự: Import from contacts, Help. Theo pattern `PopupMenuButton` của `goods_view.dart` (enum
overflow, `offset: Offset(0, 8)`, bo góc 12).
Nút `+` giữ nguyên. Chuỗi: tái dùng `action_help`; thêm `action_import_from_contacts` vào 11 file
`assets/translations/`. Không có chuỗi báo lỗi quyền: bị từ chối thì rút về tên + số, không báo lỗi.

## Kết quả spike (Android emulator API 37, picker của Google Contacts)

- Không có quyền: chỉ `fullName` + đúng số được chọn; email/địa chỉ/công ty/ghi chú trống. Không
  crash.
- Có quyền: đủ email, địa chỉ, công ty + chức danh, ghi chú. Ảnh avatar chưa kiểm tra (không dùng).
- Picker Android liệt kê **mỗi số điện thoại một dòng**: một người có 2 số xuất hiện 2 lần; người
  **không có số điện thoại không chọn được**.
- `phoneNumbers` chỉ chứa số đã chọn, các số khác không lấy được.
- Chưa kiểm chứng: iOS (không có máy), nhãn địa chỉ có cấu trúc (spike chỉ nhập một chuỗi).

## Ràng buộc

- Android: `READ_CONTACTS` trong `AndroidManifest.xml`. iOS: không cần cấu hình quyền (không xin
  quyền, bộ chọn hệ thống không cần). Muốn có email/địa chỉ trên iOS thì phải thử trên máy thật rồi
  mới thêm `NSContactsUsageDescription` + `PERMISSION_CONTACTS=1`.
- Ẩn mục Import khi `!isMobilePlatform` (Windows không có danh bạ).
- Online: không có `storeId`, lưu qua `SuppliersRepository`/Firebase; `/port-ui` không đụng `repo/`,
  nên phần map→model viết riêng nếu cần. Repo Online đang có thay đổi chưa commit ở file khác, cần
  `git status` trước khi port.
- Không commit, không push.

## Để builder quyết

Tên enum/file, nơi đặt hàm map (đề xuất một helper dùng chung cho supplier và customer), nội dung
chuỗi dịch cho 11 ngôn ngữ, cách hiển thị khi quyền bị từ chối vĩnh viễn (đề xuất snackbar ngắn).
