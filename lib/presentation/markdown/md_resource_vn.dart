class MarkdownResourceVN {
  static const String helpStores = """
  Bạn có thể luu trữ các Hàng Hoá theo cửa hàng (nhà kho, cửa tiệm).
 
  Mỗi cửa hàng giữ số lượng Hàng Hoá riêng. Mỗi Hoá Đơn giao hàng cũng liên kết tới một cửa hàng cụ thể.
 
  Ở "MENU TRÁI", bạn có thể chọn cửa hàng mà bạn muốn thao tác, theo dõi. 
 
  Bạn có thể thêm cửa hàng ở menu "MENU TRÁI: Cửa Hàng"
 """;
  static const String helpSupplierCustomers = """
 Bạn có thể lưu trữ danh sách các Khách Hàng(KH), Nhà Cung Cấp(NCC). Điền thông tin của họ bằng tay hoặc import từ danh bạ.
 
 Nhấn trường Nhà Cung Cấp khi chỉnh sửa Hoá Đơn để chọn Nhà Cung Cấp cho loại Hoá Đơn Nhập.
 
 Nhấn trường Khách Hàng khi chỉnh sửa Hoá Đơn để chọn Khách Hàng cho loại Hoá Đơn Xuất.
 
 Nhấn giữ ở một Nhà Cung Cấp hoặc một Khách Hàng để:
 * Xem các Hoá Đơn của NCC/KH.
 * Xoá NCC/KH.

 """;
  static const String helpGoods = """
 Màn hình "Hàng Hoá" chứa các Hàng Hoá, mặt hàng trong cửa hàng của bạn, bao gồm cả thông tin số lượng tồn kho của từng Hàng Hoá. 
 
 Khi tạo các "Hoá Đơn", Bạn sẽ chọn các "Hàng hoá" từ danh sách này. Ngoài ra, nếu một "Hàng Hoá" có mã vạch, thì nó có thể được thêm vào "Hoá Đơn" một cách nhanh chóng bằng việc quét mã vạch đó với camera. Số lượng tồn kho không thể chỉnh sửa, mà được tính toán thông qua các dữ liệu trong các "Hoá Đơn".
 
 * Trong quá trình nhập thông tin "Hàng Hoá", bạn có thể dùng camera để quét mã vạch bằng cách nhấn nút bên cạnh trường mã vạch.
 * Để xoá Hàng Hoá thì hãy nhấn giữ trên "Hàng Hoá" đó.
 * Để tìm kiếm, sắp xếp, thì sử dụng các nút ở trên thanh công cụ.
 
 Bạn có thể tạo "Hàng Hoá" mới trong quá trình tạo "Hoá Đơn".
 """;
  static const String helpDocuments = """
Có 2 loại "Hoá Đơn":

* NHẬP - Bạn tạo loại "Hoá Đơn" này khi mà bạn mua các "Hàng Hoá" về "Cửa Hàng". Số lượng của những "Hàng Hoá" trong "Hoá Đơn" này sẽ tự động tăng lên trong "Cửa Hàng" của bạn. 
* XUẤT - Bạn tạo loại "Hoá Đơn" này khi mà bạn bán các "Hàng Hoá" từ "Cửa Hàng". Số lượng của những "Hàng Hoá" trong "Hoá Đơn" này sẽ tự động trừ đi trong "Cửa Hàng" của bạn.
 
Bạn có thể thêm "Hàng Hoá" trong "Hoá Đơn" bằng cách chọn chúng trong danh sách các hàng hoá, hoặc quét mã vạch của hàng hoá.

Cụ thể hơn, ứng dụng cung cấp chế độ "quét 1 trùm". Trong chế độ này bạn có thể liên tục quét mã vach của Hàng Hoá và số lượng của chúng sẽ được tăng thêm 1 sau mỗi lần quét, hoặc bạn nhập bằng tay số lượng SP sau mỗi lần quét. 

Để mà xoá các "Hoá Đơn", hoặc các Hàng Hoá trong Hoá Đơn thì nhấn giữ chúng (để hiên tuỳ chọn).

Xoá các Hoá Đơn thì dẫn đến sự thay đổi số lượng SP trong cửa hàng. Các Hoá Đơn có thể được xoá chỉ khi nó là Hoá Đơn cuối cùng, vì việc xoá các Hoá Đơn trước sẽ gây ra lỗi trong việc tính toán số lượng SP.


Sử dụng các nút trên thanh công cụ để sắp xếp và lọc các Hoá Đơn. 
 
 """;
  static const String helpExpenses = """
 Mỗi cửa hàng đều mất chi phí để vận hành chúng (tiền điện, tiền nước, tiền nhân viên).
 
 Chúng tôi đã tạo ra chức năng đơn giản này để theo dõi các chi tiêu của bạn cho một cửa hàng. 
 """;
  static const String whatNews = """
  ### Phiên bản 1.0.45 - 12/07/2025  
  * Sửa lỗi được báo cáo.
  ### Phiên bản 1.0.25 - 14/04/2025  
  * Sửa lỗi được báo cáo.
  * Thêm chức năng giao dịch. 
  * Thêm chứ năng Ví tiền. 
  * Thêm 5 dạng báo cáo mới. 
  
  ### Phiên bản 1.0.8 - 6/11/24  
  * Thêm cài đặt danh sách ở màn hình hàng hóa
  * Sửa chức năng tìm kiếm ở màn hình hàng hóa
  * Thêm chức năng Quick Sync
  
  ### Phiên bản 1.0.7 - 27/09/2024
  * Sữa lỗi được báo cáo.   
  * Hỗ trợ trên iOS.  
  
  ### Phiên bản 1.0.6 - 11/07/2024
  * Thêm chức năng tạo Hóa đơn nhanh ở màn hình lưu hàng hóa. 
  * Thêm chức năng kiểm tra lịch sử nhập xuất của hàng hóa. 
  * Sữa lỗi được báo cáo.    
  
  ### Phiên bản 1.0.5 - 14/06/2024
  * Thêm hệ thống người dùng, dữ liệu của người dùng được lưu trên CLOUD. 
  * Hệ thống tự lưu dữ liệu của người dùng lên cloud vào cuối ngày, hoặc mỗi lần người dùng đăng xuất. 
  * Người dùng có thể đẩy dữ liệu của mình lên CLOUD trong menu cài đặt/Lưu dữ liệu trên cloud.
  * Dữ liệu người dùng được phục hồi ở trên thiết bị mới, sau khi đăng nhập thành công tài khoản cũ.
  * Dữ liệu người dùng được quản lý theo từng gmail.
  * Sửa lỗi giao diện.
  
  ### Phiên bản 1.0.4 - 18/04/2024
 
  * Sửa lỗi không thể cuộn xuống được ở màn hình Thống Kê chi tiết. 
  
  ### Phiên bản 1.0.3 - 15/04/2024
 
  * Thêm thống kê - tự chọn ngày. 
  * Sửa lỗi ở màn hình chọn nhóm. 
  
  ### Phiên bản 1.0.2 - 12/04/2024
 
  * Hỗ trợ nền tảng Window. 
  * Thêm thống kê - Danh sách hàng hóa. 
  * Thêm thống kê - Xuất PDF,CSV tệp.  
  * Thêm cài đặt - sao lưu, phục hồi. 
  
 ### Phiên bản 1.0.1 04/04/2024
 
 * Cho phép nhập số THỰC ở trường số lượng.
 * Cập nhât chức năng rung và âm thanh khi quét mã vạch. 
 * Cập nhật lên thiết kế Material 3.
 
 ### Phiên bản 1.0.0
 
 * Lần đầu tiên ra mắt chưa có gì để nói cả :), mọi người chọn nút trợ giúp ở từng màn hình để hiểu rõ nhé.
 """;

  static const String helpPayments = """
  ## Hướng Dẫn Quản Lý Thanh Toán  

Có hai loại thanh toán:

### 💰 Thanh Toán Thu (Inbound)  
- Tạo khi bạn **nhận tiền** từ khách hàng.  
- Thường liên kết với **phiếu xuất kho**.  
- Giúp theo dõi **dòng tiền vào**.

### 💸 Thanh Toán Chi (Outbound)  
- Tạo khi bạn **trả tiền** cho nhà cung cấp.  
- Thường liên kết với **phiếu nhập kho**.  
- Giúp theo dõi **dòng tiền ra**.

---

### ➕ Thêm Thanh Toán  
- Vào phần **Thanh Toán** hoặc sử dụng phím tắt từ màn hình chi tiết phiếu.  
- Chọn **loại thanh toán** (Thu hoặc Chi).  
- Nhập **số tiền**, **ngày**, **người trả/người nhận**, và ghi chú nếu có.  
- Bạn có thể liên kết với **phiếu chứng từ** để dễ quản lý hơn.

---

### 📄 Liên Kết Với Phiếu  
- Thanh toán có thể liên kết với **phiếu nhập/xuất** để hiển thị rõ mục đích.  
- Nếu thanh toán chỉ một phần, phiếu sẽ được đánh dấu là **Thanh Toán Một Phần**.  
- Khi đã thanh toán đủ, phiếu sẽ được đánh dấu là **Đã Thanh Toán**.

---

### 📝 Sửa hoặc Xóa Thanh Toán  
- **Nhấn giữ** vào một thanh toán để chỉnh sửa hoặc xóa.  
- ⚠️ Lưu ý: Xóa thanh toán có thể ảnh hưởng đến trạng thái thanh toán của phiếu liên quan.

---

### 📊 Lọc và Theo Dõi  
- Sử dụng bộ lọc phía trên để xem **chỉ thanh toán Thu, Chi**, hoặc các phiếu **Chưa thanh toán/Thanh toán một phần**.  
- Theo dõi thường xuyên để đảm bảo quản lý tài chính chính xác.

Giữ thông tin thanh toán rõ ràng để kiểm soát dòng tiền hiệu quả! ✅  
""";

  static const String helpMinQuan = """
  ## Hướng Dẫn Sử Dụng Số Lượng Tối Thiểu  

Trang này giúp bạn quản lý tồn kho bằng cách thiết lập **Số lượng tối thiểu** cho từng sản phẩm.  

### 📦 Số Lượng Tối Thiểu Là Gì?  
- **Số lượng tối thiểu** là mức tồn kho thấp nhất mà bạn muốn duy trì.  
- Khi tồn kho giảm xuống dưới mức này, sản phẩm sẽ xuất hiện trong **Báo cáo cần đặt hàng**.  

### 🛠️ Thiết Lập Số Lượng Tối Thiểu  
- Vào phần **Cài đặt sản phẩm** khi thêm hoặc chỉnh sửa sản phẩm.  
- Nhập số vào ô **Số lượng tối thiểu** (ví dụ: 5 hoặc 10).  
- Đây là số lượng tối thiểu bạn muốn luôn có trong kho.  

### 📉 Theo Dõi Tồn Kho Thấp  
- Sử dụng **Báo cáo cần đặt hàng** để xem các sản phẩm có tồn kho thấp hơn số lượng tối thiểu.  
- Giúp bạn đặt hàng đúng lúc và tránh hết hàng.  

### 🔄 Cập Nhật Số Lượng Tối Thiểu  
- Bạn có thể thay đổi số lượng tối thiểu bất kỳ lúc nào bằng cách chỉnh sửa sản phẩm.  
- Điều chỉnh dựa trên tốc độ bán hàng hoặc theo mùa vụ.  

### ✅ Mẹo Sử Dụng  
- Thiết lập số lượng tối thiểu cao hơn cho các mặt hàng bán chạy hoặc quan trọng.  
- Xem lại và điều chỉnh thường xuyên để đảm bảo cảnh báo chính xác.  

Quản lý tồn kho hiệu quả và tránh thiếu hàng bất ngờ! 🔔  
""";
}
