# Home: hướng dẫn đổi Store lần đầu (coach mark)

Trạng thái: chờ duyệt. Ngày: 2026-11-28. Làm ở Offline trước, sau đó port sang Online bằng `/port-ui`.

## Mục đích

Vùng chọn Store trên Home đã thay đổi (vùng chạm chỉ còn bao logo + tên, có mũi tên ▾).
Người dùng cần được cho biết "chạm vào đây để đổi Store đang chọn". Hướng dẫn hiện một lần,
cho cả người dùng cũ (sau khi cập nhật) lẫn người cài mới.

## Mục tiêu / Không phải mục tiêu

- Mục tiêu: lần đầu vào Home, làm tối nền, làm nổi vùng Store, có bong bóng chữ + nút đóng.
- Không làm: hướng dẫn cho màn khác, tour nhiều bước, mục "xem lại hướng dẫn" trong Settings,
  thay đổi data layer (`repo/`, `data/`, `domain/`).
- Điều phải tránh: hướng dẫn hiện lại mỗi lần mở app, hoặc đè lên popup quảng cáo Online app.

## Các cách đã cân nhắc

1. Tự viết lớp phủ: không thêm dependency, nhưng phải tự xử lý xoay màn hình, bàn phím.
2. **Dùng package `tutorial_coach_mark` (đã chọn)**: nhanh, ít code, chỉ cần `GlobalKey`.
   Đánh đổi: thêm dependency ở cả hai app (không có package chung giữa hai app).
3. Chỉ tooltip/banner, không làm tối nền: không "focus" vào vùng Store như yêu cầu.

`showcaseview` bị loại vì buộc bọc `ShowCaseWidget` ở gốc và sửa từng widget đích.

## Thiết kế

- Thêm `tutorial_coach_mark: ^1.3.4` vào `pubspec.yaml` của cả hai app (SDK `>=3.3.0` tương thích).
- Gắn `GlobalKey` vào vùng chạm của `HomeStoreHeader` (Offline: tham số mới `targetKey`;
  Online: header dựng trực tiếp trong `home_page.dart`).
- Hiện hướng dẫn: sau frame đầu tiên của Home, nếu cờ `home_store_guide_seen` trong
  `SharedPreferences` chưa có và widget còn `mounted`.
- Hình dạng vùng sáng: `RRect` quanh logo + tên. Bong bóng chữ nằm phía dưới, có tiêu đề, nội
  dung và nút "Đã hiểu".
- Kết thúc: nút đóng, bỏ qua, hay chạm nền đều ghi cờ đã xem. Chạm đúng vùng Store thì ghi cờ,
  đóng lớp phủ và mở luôn màn chọn Store (cùng hàm `_onChangeStore` /
  `_onChangeStorePressed` hiện có).
- Chồng popup (Offline, chỉ mobile): hướng dẫn hiện trước, `_maybeShowOnlineAppPopup` chờ đến khi
  hướng dẫn đóng rồi mới chạy.
- Chuỗi hiển thị: key mới `home_store_guide_title`, `home_store_guide_body` (dùng lại key
  "Đã hiểu" nếu đã có), thêm vào 11 locale của Offline; Online theo cách quản lý chuỗi hiện có.
- Online giữ khác biệt đã biết: không đổi logic quyền (`canEdit`), `RouteAware`, tên route.

## Việc để người xây tự quyết

- Nội dung văn bản chính xác, màu và độ mờ của lớp phủ theo theme.
- Chọn vị trí bong bóng chữ cho màn nhỏ và màn Windows rộng.
- Chạy `flutter pub get` và kiểm tra build trên máy; Offline không có test tự động.
