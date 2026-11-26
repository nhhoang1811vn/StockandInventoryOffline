# Stock & Inventory Manager — Windows

Stock & Inventory Manager for Windows 10 / 11 (64-bit). No installation needed, no account and no
internet connection required: everything runs and is stored on your computer.

## How to open the app

1. Open the [latest release](https://github.com/nhhoang1811vn/StockandInventoryOffline/releases/latest)
   and download `StockandInventory-<version>-windows.zip` (for example
   `StockandInventory-1.0.97-windows.zip`).
2. Right-click the zip, choose **Extract All...** and pick a folder (for example
   `C:\StockandInventory`). Do not run the app from inside the zip: it will not start.
3. Open the extracted folder and double-click **`StockandInventory.exe`**.
4. Keep all files in the folder together. You can create a desktop shortcut to
   `StockandInventory.exe`.

If Windows shows **"Windows protected your PC"** (the app is not code-signed yet), click
**More info**, then **Run anyway**.

To update, download the new zip, extract it to a new folder and run it. Your data is kept (see
below), and you can delete the old folder.

The unzipped files of each release are also on the branch `windows/v<version>` (for example
`windows/v1.0.97`).

## Your data

- Data is stored locally in `main.db` under `Documents\AppViet_GoodManager\`. It is not inside the
  app folder, so deleting or replacing the app folder does not delete your data.
- **Back up:** open **Settings > Backup and restore > Back up data**. A `backup_<number>.json`
  file is created in `Documents\backups\`. Copy it somewhere safe.
- **Restore:** open **Settings > Backup and restore > Restore data** and select a backup `.json`
  file.
- You can also copy the `Documents\AppViet_GoodManager\` folder to back up by hand.

## Not available on Windows

- Barcode scanning with the camera.
- Taking a photo with the camera (choose an image file instead). The image size and crop settings
  are not shown.
- Buying Pro (free-tier limits apply).
- Low-stock notifications.

---

# Stock & Inventory Manager — bản Windows (Tiếng Việt)

Dành cho Windows 10 / 11 (64-bit). Không cần cài đặt, không cần tài khoản và không cần kết nối
internet: mọi thứ chạy và được lưu ngay trên máy của bạn.

## Cách mở ứng dụng

1. Vào [bản phát hành mới nhất](https://github.com/nhhoang1811vn/StockandInventoryOffline/releases/latest)
   và tải file `StockandInventory-<phiên bản>-windows.zip` (ví dụ
   `StockandInventory-1.0.97-windows.zip`).
2. Chuột phải vào file zip, chọn **Extract All...** (Giải nén) và chọn một thư mục (ví dụ
   `C:\StockandInventory`). Không chạy trực tiếp từ bên trong file zip, ứng dụng sẽ không khởi động.
3. Mở thư mục vừa giải nén và nhấp đúp vào **`StockandInventory.exe`**.
4. Giữ nguyên tất cả các file trong thư mục. Bạn có thể tạo shortcut ra Desktop cho
   `StockandInventory.exe`.

Nếu Windows hiện cảnh báo **"Windows protected your PC"** (ứng dụng chưa được ký số), bấm
**More info**, rồi **Run anyway**.

Để cập nhật, tải file zip mới, giải nén ra một thư mục mới rồi chạy. Dữ liệu của bạn vẫn được giữ
nguyên (xem bên dưới), bạn có thể xoá thư mục cũ.

File đã giải nén của mỗi bản phát hành cũng có trên nhánh `windows/v<phiên bản>` (ví dụ
`windows/v1.0.97`).

## Dữ liệu của bạn

- Dữ liệu lưu trên máy trong file `main.db` tại `Documents\AppViet_GoodManager\`. Dữ liệu không
  nằm trong thư mục ứng dụng, nên xoá hoặc thay thư mục ứng dụng sẽ không làm mất dữ liệu.
- **Sao lưu:** mở **Cài đặt > Sao lưu và khôi phục > Sao lưu dữ liệu**. File
  `backup_<số>.json` được tạo trong `Documents\backups\`. Hãy sao chép file này đến nơi an toàn.
- **Khôi phục:** mở **Cài đặt > Sao lưu và khôi phục > Khôi phục dữ liệu** rồi chọn file sao lưu
  `.json`.
- Bạn cũng có thể sao chép thư mục `Documents\AppViet_GoodManager\` để tự sao lưu.

## Chưa hỗ trợ trên Windows

- Quét mã vạch bằng camera.
- Chụp ảnh bằng camera (hãy chọn file ảnh). Các cài đặt kích thước và cắt ảnh không hiển thị.
- Mua gói Pro (áp dụng giới hạn của bản miễn phí).
- Thông báo sắp hết hàng.
