class MarkdownResourceVN {
  static const String helpStores = """
## Cửa hàng

Dùng Cửa hàng để tách tồn kho theo từng nơi (cửa tiệm, nhà kho).

### Tồn kho theo cửa hàng
- Mỗi cửa hàng có **tồn kho riêng**.
- Mỗi tài liệu nhập/xuất thuộc **một cửa hàng**.

### Đổi cửa hàng
- Ở **Trang chủ**, nhấn tên hoặc ảnh cửa hàng để chọn cửa hàng đang làm việc.

### Thêm và quản lý
- Mở **Cửa hàng** trong Cài đặt để thêm, sửa hoặc xóa.

### Giới hạn
- Bản miễn phí dùng tối đa **2 cửa hàng**.
- Nâng cấp **Stock Premium** để thêm cửa hàng. Gói có **7 ngày dùng thử**.
""";

  static const String helpSupplierCustomers = """
## Nhà cung cấp và khách hàng

Lưu thông tin nhà cung cấp và khách hàng ở một nơi. Nhập tay hoặc **thêm từ danh bạ**.

### Gán vào tài liệu
- Tài liệu **Nhập hàng**: nhấn **Nhà cung cấp**.
- Tài liệu **Xuất hàng**: nhấn **Khách hàng**.

### Quản lý
- **Nhấn giữ** nhà cung cấp hoặc khách hàng để:
  - Xem tài liệu liên quan
  - Xóa bản ghi
""";

  static const String helpGoods = """
## Hàng hóa

Màn hình Hàng hóa là danh mục trong cửa hàng, kèm số lượng tồn.

Khi tạo tài liệu, chọn hàng từ danh sách này. Nếu hàng có mã vạch, quét camera để thêm nhanh.

> Không sửa tồn kho bằng tay. Tồn kho được tính từ tài liệu nhập/xuất.

### Thao tác
- Khi sửa hàng, nhấn **camera** cạnh ô mã vạch để quét.
- **Nhấn giữ** hàng hóa để xóa.
- Dùng thanh công cụ để **tìm** hoặc **sắp xếp**.

### Tạo tự động
- Không cần nhập hết danh mục trước.
- Tạo tài liệu Nhập hàng và điền hàng mới. Hàng đó được **lưu vào danh mục**.
- Lần sau có thể thêm bằng cách quét mã vạch.
""";

  static const String helpDocuments = """
## Tài liệu

Tài liệu ghi hàng vào hoặc ra khỏi cửa hàng.

### Nhập hàng
- Tạo khi hàng **về cửa hàng**.
- Số lượng trong tài liệu được **cộng** vào tồn kho.

### Xuất hàng
- Tạo khi hàng **rời cửa hàng** (ví dụ bán cho khách).
- Số lượng trong tài liệu được **trừ** khỏi tồn kho.

### Thêm hàng
- Chọn từ danh mục hàng hóa, hoặc
- **Quét mã vạch** bằng camera.

### Quét liên tục
- Quét mã lần lượt. Mỗi lần quét **thêm hàng và tăng số lượng thêm 1**.
- Hoặc nhập số lượng **bằng tay** sau mỗi lần quét.
- Chọn chế độ trong **Cài đặt**.

### Tạo hàng tự động
- Hàng **mới** thêm vào tài liệu Nhập hàng (đủ thông tin) được **lưu vào danh mục**.
- Không thêm hàng mới vào tài liệu Xuất hàng. Hàng phải đã có trong tồn kho.

### Xóa
- **Nhấn giữ** tài liệu hoặc dòng hàng để xóa.

> Xóa tài liệu làm thay đổi tồn kho. Chỉ xóa được tài liệu **mới nhất**. Xóa tài liệu cũ có thể làm sai số lượng.

### Lọc và sắp xếp
- Dùng thanh công cụ để **lọc** hoặc **sắp xếp**.
""";

  static const String helpExpenses = """
Mỗi cửa hàng đều có chi phí vận hành (điện, nước, nhân viên).

Dùng chức năng này để theo dõi chi tiêu theo từng cửa hàng.
""";

  static const String whatNews = """
### Phiên bản 1.0.95 - 20/11/2026
* Báo cáo Bán hàng mới trên màn hình Báo cáo: theo ngày, theo hàng hoá, theo khách hàng và theo tháng, có bộ lọc nhóm, khách hàng và năm.
* Báo cáo Mua hàng mới: theo ngày, theo hàng hoá, theo nhà cung cấp và theo tháng, có bộ lọc nhà cung cấp.
* Báo cáo của tháng này và năm nay giờ kết thúc ở ngày hôm nay.
* Sửa lỗi dịch sai từ "số tiền" ở một số ngôn ngữ.

### Phiên bản 1.0.94 - 17/11/2026
* Đã có phiên bản Windows. Xem banner mới ở Trang chủ để tải về.
* Có thể sao chép hàng hóa hoặc nhóm: nhấn giữ, chọn Sao chép, rồi chọn cửa hàng và nhóm.
* Mở khóa bằng vân tay (Face ID trên iPhone) khi đã bật khóa mật mã.
* Ứng dụng tự khóa sau một khoảng thời gian không hoạt động (mặc định 30 phút, có thể chỉnh trong Cài đặt).
* Thêm cài đặt kích thước ảnh và tùy chọn ẩn cửa sổ cắt ảnh khi thêm hình.
* Thêm cài đặt độ trễ giữa các lần quét khi quét hàng loạt.
* Đặt lại đánh số chứng từ giờ có hỏi xác nhận.
* Sửa lỗi thoát ứng dụng khi ngoại tuyến, khi không tải được ảnh đại diện hoặc khi nhập giá, số tiền không hợp lệ.
* Sửa lỗi thoát ứng dụng ở danh sách Chứng từ, Thanh toán và Lịch sử sau khi xóa hoặc lọc mục, và khi từ chối quyền camera hoặc thông báo.

### Phiên bản 1.0.93 - 30/10/2026
* Thông báo mới hiện đại hơn, trượt xuống từ phía trên. Vuốt lên hoặc chạm để đóng.
* Mọi thông báo dùng chung một kiểu, có màu riêng cho thành công, cảnh báo và lỗi.
* Ứng dụng đổi tên thành Stock & Inventory Manager.
* Khoảng cách và kích thước của thẻ và danh sách đồng nhất hơn giữa các màn hình.
* Menu khi nhấn giữ item gọn gàng hơn.
* Sửa nút Đánh giá ứng dụng trong Cài đặt để mở đúng trang cửa hàng.

### Phiên bản 1.0.92 - 12/10/2026
* Hiện số lượng và tổng tiền nhập/xuất trên thẻ chứng từ ở Trang chủ.
* Thêm thanh tóm tắt ở Hàng hóa, Lịch sử, Chứng từ, Thanh toán, Cửa hàng, Nhà cung cấp và Khách hàng.
* Tóm tắt chứng từ và thanh toán theo tab đang chọn.
* Nhà cung cấp dùng icon xe tải. Khách hàng dùng icon nhóm người.
* Trợ giúp và ghi chú phiên bản có đủ ngôn ngữ của ứng dụng.

### Phiên bản 1.0.91 - 08/10/2026
* Thêm nhập và xuất Excel trên menu Tồn kho.
* Thêm thao tác nhấn giữ cho chứng từ gần đây trên Trang chủ.
* Thêm thao tác nhấn giữ cho kết quả tìm kiếm.
* Đổi mục Danh mục thành Danh mục thanh toán trong Cài đặt.

### Phiên bản 1.0.90 - 06/10/2026
* Cập nhật Trang chủ, Hàng hóa, Thanh toán, Báo cáo và Cài đặt.
* Thêm ảnh cho cửa hàng, nhóm, khách hàng và nhà cung cấp.
* Cập nhật danh sách, trạng thái trống và màn bắt đầu.
* Cải thiện bản dịch.
* Sửa lỗi được báo cáo.

### Phiên bản 1.0.80 - 23/04/2026
* Sửa lỗi được báo cáo.
* Thêm hướng dẫn chuyển sang bản online.
* Làm mới giao diện.

### Phiên bản 1.0.75 - 16/04/2026
* Sửa lỗi được báo cáo.
* Thêm loại tiền tệ.
* Sửa lỗi trùng mã vạch hàng hóa.

### Phiên bản 1.0.70 - 06/02/2026
* Sửa lỗi được báo cáo.
* Thêm loại tiền tệ.
* Cập nhật đồng bộ dữ liệu.
* Cập nhật logo (chuẩn bị bản online).

### Phiên bản 1.0.65 - 20/09/2025
* Sửa lỗi được báo cáo.
* Thêm báo cáo: Thông tin hàng hóa.

### Phiên bản 1.0.60 - 09/09/2025
* Sửa lỗi không đăng nhập được tài khoản Apple.
* Sửa lỗi được báo cáo.
* Thêm đổi giao diện, ngôn ngữ, tiền tệ.
* Cập nhật logo, thêm tệp khi lưu hàng hóa.
* Cập nhật đăng nhập.
* Cập nhật giao diện.

### Phiên bản 1.0.45 - 12/07/2025
* Sửa lỗi được báo cáo.

### Phiên bản 1.0.40 - 25/07/2025
* Sửa lỗi không quét được mã vạch trên Android.
* Sửa lỗi cảnh báo tồn thấp không hiện khi mở ứng dụng.
* Sửa lỗi được báo cáo.
* Hỗ trợ ngôn ngữ trong menu.
* Cập nhật giao diện.

### Phiên bản 1.0.30 - 30/05/2025
* Sửa lỗi được báo cáo.
* Thêm số lượng tối thiểu.
* Thêm thông tin công ty.
* Thêm chế độ tối, khóa mã.
* Thêm báo cáo đặt hàng lại.

### Phiên bản 1.0.25 - 14/04/2025
* Sửa lỗi được báo cáo.
* Thêm thanh toán.
* Thêm ví.
* Thêm 5 loại báo cáo.

### Phiên bản 1.0.8 - 06/12/2024
* Sửa lỗi được báo cáo.
* Thêm cài đặt danh sách ở màn hình hàng hóa.
* Sửa tìm kiếm ở màn hình hàng hóa.
* Thêm Quick Sync.

### Phiên bản 1.0.7 - 27/09/2024
* Sửa lỗi được báo cáo.
* Hỗ trợ iOS.

### Phiên bản 1.0.6 - 07/07/2024
* Sửa lỗi được báo cáo.
* Thêm tạo tài liệu nhanh khi lưu hàng hóa.
* Thêm lịch sử nhập xuất hàng hóa.

### Phiên bản 1.0.5 - 14/06/2024
* Thêm đăng nhập / đăng ký. Dữ liệu người dùng lưu trên cloud.
* Hệ thống tự lưu dữ liệu lên cloud cuối ngày, hoặc khi đăng xuất.
* Có thể đẩy dữ liệu lên cloud trong Cài đặt.
* Dữ liệu được khôi phục trên thiết bị mới sau khi đăng nhập.
* Dữ liệu được quản lý theo từng email.
* Sửa lỗi giao diện.

### Phiên bản 1.0.4 - 18/04/2024
* Sửa lỗi không cuộn được ở báo cáo chi tiết.

### Phiên bản 1.0.3 - 15/04/2024
* Thêm báo cáo theo khoảng ngày tự chọn.
* Sửa lỗi màn hình chọn nhóm.

### Phiên bản 1.0.2 - 12/04/2024
* Hỗ trợ Windows.
* Thêm báo cáo danh sách hàng hóa.
* Thêm xuất PDF, CSV.
* Thêm sao lưu, phục hồi.

### Phiên bản 1.0.1 - 04/04/2024
* Cho phép số thực ở trường số lượng.
* Thêm rung và âm thanh khi quét mã vạch.
* Cập nhật Material 3.

### Phiên bản 1.0.0
* Phiên bản đầu tiên.
""";

  static const String helpPayments = """
## Thanh toán

Thanh toán ghi tiền vào và ra khỏi ví.

### Thu
- Ghi khi **nhận tiền** từ khách hàng.
- Thường gắn với tài liệu **Xuất hàng**.
- Theo dõi tiền vào.

### Chi
- Ghi khi **trả tiền** cho nhà cung cấp.
- Thường gắn với tài liệu **Nhập hàng**.
- Theo dõi tiền ra.

### Thêm thanh toán
- Mở **Thanh toán**, hoặc thêm từ màn hình tài liệu.
- Chọn **Thu** hoặc **Chi**.
- Nhập **số tiền**, **ngày**, người liên quan, và ghi chú nếu có.
- Có thể gắn **tài liệu**.

### Gắn tài liệu
- Thanh toán gắn tài liệu cho biết khoản tiền dùng để làm gì.
- Thanh toán một phần đánh dấu tài liệu là **Thanh toán một phần**.
- Thanh toán đủ đánh dấu tài liệu là **Đã thanh toán**.

### Sửa hoặc xóa
- **Nhấn giữ** một thanh toán để sửa hoặc xóa.

> Xóa thanh toán có thể đổi trạng thái thanh toán của tài liệu.

### Lọc và sắp xếp
- Dùng thanh công cụ để **lọc** hoặc **sắp xếp**.
""";

  static const String helpMinQuan = """
## Số lượng tối thiểu

Đặt **số lượng tối thiểu** cho từng hàng hóa để biết khi nào cần nhập thêm.

### Là gì
- Mức tồn thấp nhất bạn muốn giữ.
- Khi tồn xuống dưới mức này, hàng xuất hiện trong báo cáo **Đặt hàng lại** và trên **Trang chủ** (tồn thấp).

### Thiết lập
- Mở hàng hóa khi thêm hoặc sửa.
- Nhập số vào **Số lượng tối thiểu** (ví dụ 5 hoặc 10).

### Tồn thấp
- Dùng báo cáo **Đặt hàng lại** để xem hàng dưới mức tối thiểu.
- Trang chủ cũng hiện **Hết hàng** và **Tồn thấp**.

### Cập nhật
- Sửa hàng hóa bất kỳ lúc nào để đổi mức tối thiểu.
- Điều chỉnh theo tốc độ bán hoặc mùa vụ.

### Gợi ý
- Đặt mức cao hơn cho hàng bán chạy hoặc hàng quan trọng.
- Xem lại thường xuyên để cảnh báo còn đúng.
""";
}
