class MarkdownResourceVN{
 static const String donationText = """
 ## Momo cho SDT của mình nhé. 0975 997 203
  """;
  static const String helpStores = """
 ### Bạn có thể luu trữ các sản phẩm theo cửa hàng (nhà kho, cửa tiệm).
 ### Mỗi cửa hàng giữ số lượng Sản phẩm riêng. Mỗi giao dich giao hàng cũng liên kết tới một cửa hàng cụ thể.
 ### Ở Trang chủ bạn có thể chọn cửa hàng mà bạn muốn thao tác, theo dõi. 
 ### Bạn có thể thêm cửa hàng ở menu "Cửa hàng" trong menu chính "Khác".
 """;
  static const String helpSupplierCustomers = """
 ### Bạn có thể lưu trữ danh sách các Khách Hàng(KH), Nhà Cung Cấp(NCC). Điền thông tin của họ bằng tay hoặc import từ danh bạ.
 
 ### Nhấn trường Nhà Cung Cấp khi chỉnh sửa Giao Dich để chọn Nhà Cung Cấp cho loại Giao Dịch Nhập.
 
 ### Nhấn trường Khách Hàng khi chỉnh sửa Giao Dich để chọn Khách Hàng cho loại Giao Dịch Xuất.
 
 ### Nhấn giữ ở một Nhà Cung Cấp hoặc một Khách Hàng để:
 - ### Xem các Giao Dịch của NCC/KH.
 - ### Xoá NCC/KH.

 """;
  static const String helpGoods = """
 ### Màn hình Sản Phẩm chứa các Sản phẩm, mặt hàng trong cửa hàng của bạn, bao gồm cả thông tin số lượng tồn kho của sản phẩm. 
 ### Khi tạo các Giao Dịch, bạn sẽ chọn các sản phẩm từ danh sách này. Hơn nữa, nếu một sản phẩm có mã vạch, thì nó có thể được chọn trong giao dich một cách nhanh chóng bằng việc quét mã vạch đó với camera. Số lượng tồn kho không thể chỉnh sửa, mà được tính toán thông qua các dữ liệu trong các giao dich.
 
 - ### Trong quá trình nhập thông tin sản phẩm, bạn có thể dùng camera để quét mã vạch bằng cách nhấn nút bên cạnh trường mã vạch.
 - ### Để xoá sản phẩm thì hãy nhấn giữ trên sản phẩm đó.
 - ### Để tìm kiếm, sắp xếp, thì sử dụng các nút ở trên thanh công cụ
 
 ### Bạn có thể tạo SP mới trong quá trình tạo Giao Dịch.
 """;
  static const String helpDocuments = """
### Có 2 loại giao dịch:

- ### Nhập - Bạn tạo loại giao dịch này khi mà bạn nhập các sản phẩm/ hàng hoá về cửa hàng của mình (ví dụ, bạn mua sản phẩm từ NCC nào đó). Số lượng của những sản phẩm trong giao dịch này sẽ tự động tăng lên trong kho của bạn. 
- ### Xuất - Bạn tạo loại giao dịch này khi mà bạn xuất các sản phẩm từ cửa hàng của mình (ví dụ, bạn bán sản phẩm cho Khách hàng nào đó). Số lượng của những sản phẩm trong giao dịch này sẽ tự động trừ đi trong kho của bạn.
 
### Bạn có thể thêm sản phẩm trong giao dịch bằng cách chọn chúng trong danh sách các sản phẩm, hoặc quét mã vạch của sản phẩm.
### Cụ thể hơn, ứng dụng cung cấp chế độ "quét 1 trùm". Trong chế độ này bạn có thể liên tục quét mã vach của sản phẩm và số lượng của chúng sẽ được tăng thêm 1 sau mỗi lần quét, hoặc bạn nhập bằng tay số lượng SP sau mỗi lần quét. 
### Để mà xoá các giao dịch, hoặc các sản phẩm trong giao dịch thì nhấn giữ chúng (để hiên tuỳ chọn).
### Xoá các giao dịch thì dẫn đến sự thay đổi số lượng SP trong cửa hàng. Các giao dịch có thể được xoá chỉ khi nó là giao dịch cuối cùng, vì việc xoá các giao dịch trước sẽ gây ra lỗi trong việc tính toán số lượng SP.

### Sử dụng các nút trên thanh công cụ để sắp xếp và lọc các giao dịch. 
 
 """;
  static const String helpExpenses = """
 ### Dòng tiền là số tiền hiện có của cửa hàng đó. 
 ### Mỗi cửa hàng đều mất chi phí để vận hành chúng (tiền điện, tiền nước, tiền nhân viên), bạn có thể tạo ra các lệnh dòng tiền âm, để theo dõi chúng.
 ### Khi nhập hàng thì chủ cửa hàng cũng mất 1 luợng tiền, lúc này bạn cũng có thể tạo ra lệnh dòng tiền âm, để theo dõi.
 ### Khi xuất hàng thì bạn tạo ra các lệnh dòng tiền dương, để theo dõi. 
 ### Như vậy, với bất kì điều gì làm số tiền trong kho thay đổi, bạn có thể tạo các lệnh tương úng. Chúng ta sẽ tổng kết được, doanh thu của cửa hàng mỗi tháng, lời lỗ ra sao :D 
 """;
  static const String whatNews = """
 ## Phiên bản 1.0.0
 
 ### Lần đầu tiên ra mắt chưa có gì để nói cả :), mọi người chọn nút trợ giúp ở từng màn hình để hiểu rõ nhé.
 """;
}