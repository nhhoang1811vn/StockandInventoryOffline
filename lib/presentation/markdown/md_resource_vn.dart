class MarkdownResourceVN{
 static const String donationText = """
 ## Momo cho SDT của mình nhé. 0975 997 203
  """;
  static const String helpStores = """
 ### Bạn có thể luu trữ các Hàng Hoá theo cửa hàng (nhà kho, cửa tiệm).
 ### Mỗi cửa hàng giữ số lượng Hàng Hoá riêng. Mỗi Hoá Đơn giao hàng cũng liên kết tới một cửa hàng cụ thể.
 ### Ở "MENU TRÁI", bạn có thể chọn cửa hàng mà bạn muốn thao tác, theo dõi. 
 ### Bạn có thể thêm cửa hàng ở menu "MENU TRÁI: Cửa Hàng"
 """;
  static const String helpSupplierCustomers = """
 ### Bạn có thể lưu trữ danh sách các Khách Hàng(KH), Nhà Cung Cấp(NCC). Điền thông tin của họ bằng tay hoặc import từ danh bạ.
 
 ### Nhấn trường Nhà Cung Cấp khi chỉnh sửa Hoá Đơn để chọn Nhà Cung Cấp cho loại Hoá Đơn Nhập.
 
 ### Nhấn trường Khách Hàng khi chỉnh sửa Hoá Đơn để chọn Khách Hàng cho loại Hoá Đơn Xuất.
 
 ### Nhấn giữ ở một Nhà Cung Cấp hoặc một Khách Hàng để:
 - ### Xem các Hoá Đơn của NCC/KH.
 - ### Xoá NCC/KH.

 """;
  static const String helpGoods = """
 ### Màn hình "Hàng Hoá" chứa các Hàng Hoá, mặt hàng trong cửa hàng của bạn, bao gồm cả thông tin số lượng tồn kho của từng Hàng Hoá. 
 ### Khi tạo các "Hoá Đơn", Bạn sẽ chọn các "Hàng hoá" từ danh sách này. Ngoài ra, nếu một "Hàng Hoá" có mã vạch, thì nó có thể được thêm vào "Hoá Đơn" một cách nhanh chóng bằng việc quét mã vạch đó với camera. Số lượng tồn kho không thể chỉnh sửa, mà được tính toán thông qua các dữ liệu trong các "Hoá Đơn".
 
 - ### Trong quá trình nhập thông tin "Hàng Hoá", bạn có thể dùng camera để quét mã vạch bằng cách nhấn nút bên cạnh trường mã vạch.
 - ### Để xoá Hàng Hoá thì hãy nhấn giữ trên "Hàng Hoá" đó.
 - ### Để tìm kiếm, sắp xếp, thì sử dụng các nút ở trên thanh công cụ.
 
 ### Bạn có thể tạo "Hàng Hoá" mới trong quá trình tạo "Hoá Đơn".
 """;
  static const String helpDocuments = """
### Có 2 loại "Hoá Đơn":

- ### NHẬP - Bạn tạo loại "Hoá Đơn" này khi mà bạn mua các "Hàng Hoá" về "Cửa Hàng". Số lượng của những "Hàng Hoá" trong "Hoá Đơn" này sẽ tự động tăng lên trong "Cửa Hàng" của bạn. 
- ### XUẤT - Bạn tạo loại "Hoá Đơn" này khi mà bạn bán các "Hàng Hoá" từ "Cửa Hàng". Số lượng của những "Hàng Hoá" trong "Hoá Đơn" này sẽ tự động trừ đi trong "Cửa Hàng" của bạn.
 
### Bạn có thể thêm "Hàng Hoá" trong "Hoá Đơn" bằng cách chọn chúng trong danh sách các hàng hoá, hoặc quét mã vạch của hàng hoá.
### Cụ thể hơn, ứng dụng cung cấp chế độ "quét 1 trùm". Trong chế độ này bạn có thể liên tục quét mã vach của Hàng Hoá và số lượng của chúng sẽ được tăng thêm 1 sau mỗi lần quét, hoặc bạn nhập bằng tay số lượng SP sau mỗi lần quét. 
### Để mà xoá các "Hoá Đơn", hoặc các Hàng Hoá trong Hoá Đơn thì nhấn giữ chúng (để hiên tuỳ chọn).
### Xoá các Hoá Đơn thì dẫn đến sự thay đổi số lượng SP trong cửa hàng. Các Hoá Đơn có thể được xoá chỉ khi nó là Hoá Đơn cuối cùng, vì việc xoá các Hoá Đơn trước sẽ gây ra lỗi trong việc tính toán số lượng SP.

### Sử dụng các nút trên thanh công cụ để sắp xếp và lọc các Hoá Đơn. 
 
 """;
  static const String helpExpenses = """
 ### Mỗi cửa hàng đều mất chi phí để vận hành chúng (tiền điện, tiền nước, tiền nhân viên).
 ### Chúng tôi đã tạo ra chức năng đơn giản này để theo dõi các chi tiêu của bạn cho một cửa hàng. 
 """;
  static const String whatNews = """
 ## Phiên bản 1.0.0
 
 ### Lần đầu tiên ra mắt chưa có gì để nói cả :), mọi người chọn nút trợ giúp ở từng màn hình để hiểu rõ nhé.
 """;
}