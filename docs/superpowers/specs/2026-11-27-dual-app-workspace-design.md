# Workspace sửa đồng thời Offline + Online — thiết kế (ngắn)

## Mục đích

Sửa UI (ví dụ trang home) hiện phải làm hai lần, ở hai repo. Mục tiêu: sửa một lần, phần còn lại
được áp dụng sang app kia có kiểm soát. Dữ liệu khác nhau (Offline: SQLite, Online: Firebase
Realtime DB) nhưng nằm sau `repo/`, nên đổi layout không đụng tới.

## Mục tiêu

- Một session Claude làm việc trên cả hai repo.
- Lệnh `/port-ui`: lấy thay đổi UI ở app A, áp dụng tương đương sang app B.
- Danh sách "khác biệt đã biết" giữa hai app để port không phá chúng.

## Không phải mục tiêu / phản mục tiêu

- Không tách package UI chung, không refactor hai app (xem Approaches).
- Không tự commit, không tự push. Mỗi repo commit riêng, bạn duyệt diff trước.
- Không làm hai app phụ thuộc nhau khi build hay release.

## Ràng buộc

- ADR 0001 giữ nguyên: hai app là hai sản phẩm độc lập, UI lệch dần là chấp nhận được.
  Chỉ bổ sung: Online giờ cũng được sửa khi port.
- Vị trí repo: Offline `D:\WorkSpace\StockandInventoryOffline`,
  Online `D:\WorkSpace\StockandInventoryOnline` (git đang báo
  "dubious ownership", cần `safe.directory`, sửa cấu hình git toàn cục nên cần bạn đồng ý).
- Không có sẵn: Online chỉ đọc theo ADR cũ, chưa rõ nó có AGENTS.md riêng (UNKNOWN, sẽ kiểm tra).

## Approaches

1. **Workspace chung + skill port UI** (đã chọn). Giữ ADR, làm nhanh, không rủi ro cho code hiện có;
   đổi lại vẫn là hai bản code, đồng bộ nhờ skill chứ không nhờ compiler.
2. Package UI chung: một nơi sửa, nhưng widget đang kéo cubit/repo/AppSettings/route nên là
   dự án vài tuần và ràng buộc release hai app. Để lại cho sau.
3. Làm 1 trước rồi tách dần widget thuần UI sang package: mở sẵn cho tương lai.

## Thiết kế đã chốt

Thư mục mới `D:\WorkSpace\StockandInventoryWorkspace` (không phải git repo, nằm ngoài hai repo):

- `StockandInventory.code-workspace`: mở cả hai repo như hai folder.
- `CLAUDE.md`: đường dẫn hai repo, quy tắc (đọc AGENTS.md/CONTEXT.md của từng repo trước khi sửa,
  không commit, không đụng data layer khi port UI), cách mở session:
  `claude --add-dir <Offline> --add-dir <Online>`.
- `KNOWN_DIFFERENCES.md`: bảng khác biệt đã biết, khởi tạo từ so sánh vừa làm (RoleGuard/
  `AppSettings.getSelectedStoreRole`, `RouteAware`/`onOpenMenuPage`, `Dimens.*` so với
  số cứng, `Pages.savePayment` so với `Pages.save_payment`, `EdgeInsetsDirectional` so với
  `EdgeInsets`, promo/Windows banner/RevenueCat chỉ có ở Offline, 26 file chỉ có ở Online).
- `.claude/skills/port-ui/SKILL.md`: quy trình: (1) bạn nói app nguồn + file/trang; (2) đọc diff
  nguồn (uncommitted hoặc commit chỉ định); (3) tìm file tương ứng ở app đích; (4) áp dụng phần
  thay đổi giao diện, bỏ qua mục trong KNOWN_DIFFERENCES; (5) chạy `flutter analyze` ở app đích; (6)
  báo cáo phần không port được và lý do; (7) thêm khác biệt mới phát hiện vào bảng.

## Việc để builder tự quyết (đánh dấu "my call")

- Cách đặt tên và định dạng bảng KNOWN_DIFFERENCES.
- Có tạo thêm lệnh `/diff-ui` (liệt kê file lệch giữa hai app) hay không. Mặc định: không, YAGNI.

## Việc cần bạn xác nhận

- Tạo `D:\WorkSpace\StockandInventoryWorkspace`, hay đặt chỗ khác?
- Cho phép chạy `git config --global --add safe.directory` cho repo Online?
- Đổi ADR 0001 cho đúng thực tế (Online được sửa khi port), hay để nguyên?
