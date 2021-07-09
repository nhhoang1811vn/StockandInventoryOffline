const String _markdownDataSupplierCustomerEN = """
 You can keep track of your Customers and Suppliers. Fill in their data
 manually or import from Contacts.
 
 Tap on Supplier when editing Document to select Supplier for
 Incoming document.
 
 Tap on Customer when editing Document to select Customer for 
 Outgoing document.
 
 Long tap on a Supplier or a Customer to:
 - Access all document of item. 
 - Delete item.

 """;
const String _markdownDataSupplierCustomerVN = """
 Bạn có thể giữ danh sách các Khách Hàng(KH), Nhà Cung Cấp(NCC).
 Điền thông tin của họ bằng tay hoặc import từ danh bạ.
 
 Nhấn trường Nhà Cung Cấp khi chỉnh sửa Giao Dich để chọn Nhà Cung Cấp
 cho loại Giao Dịch Nhập.
 
 Nhấn trường Khách Hàng khi chỉnh sửa Giao Dich để chọn Khách Hàng
 cho loại Giao Dịch Xuất.
 
 Nhấn giữ ở một Nhà Cung Cấp hoặc một Khách Hàng để:
 - Xem các Giao Dịch của NCC/KH.
 - Xoá NCC/KH.

 """;

const String _markdownDataStoreVN = """
 
 """;
const String _markdownDataStoreEN = """
 
 """;

class HelpUtils {
  static String getMarkdownDataSupplierCustomer() {
    return _markdownDataSupplierCustomerVN;
  }

  static String getMarkdownDataStore() {
    return _markdownDataStoreVN;
  }
}
