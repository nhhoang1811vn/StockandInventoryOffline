const String _markdownDataSupplierCustomerEN = """
 ### You can keep track of your Customers and Suppliers. Fill in their data manually or import from Contacts.
 
 ### Tap on Supplier when editing Document to select Supplier for Incoming document.
 
 ### Tap on Customer when editing Document to select Customer for Outgoing document.
 
 ### Long tap on a Supplier or a Customer to:
 - ### Access all document of item. 
 - ### Delete item.

 """;
const String _markdownDataSupplierCustomerVN = """
 ### Bạn có thể lưu trữ danh sách các Khách Hàng(KH), Nhà Cung Cấp(NCC). Điền thông tin của họ bằng tay hoặc import từ danh bạ.
 
 ### Nhấn trường Nhà Cung Cấp khi chỉnh sửa Giao Dich để chọn Nhà Cung Cấp cho loại Giao Dịch Nhập.
 
 ### Nhấn trường Khách Hàng khi chỉnh sửa Giao Dich để chọn Khách Hàng cho loại Giao Dịch Xuất.
 
 ### Nhấn giữ ở một Nhà Cung Cấp hoặc một Khách Hàng để:
 - ### Xem các Giao Dịch của NCC/KH.
 - ### Xoá NCC/KH.

 """;

const String _markdownDataStoreVN = """
 ### Bạn có thể luu trữ các sản phẩm theo cửa hàng (nhà kho, cửa tiệm).
 ### Mỗi cửa hàng giữ số lượng Sản phẩm riêng. Mỗi giao dich giao hàng cũng liên kết tới một cửa hàng cụ thể.
 ### Ở Trang chủ bạn có thể chọn cửa hàng mà bạn muốn thao tác, theo dõi. 
 ### Bạn có thể thêm cửa hàng ở menu "Cửa hàng" trong menu chính "Khác".
 """;
const String _markdownDataStoreEN = """
 ### You can keep track of items by Stores (Shops, Warehouses).
 ### Every Store keeps its own quantity in stock. Every document's transactions are also attached to specific Store.
 ### In the Home Menu you can select current Store to work with
 ### You can add more stores using "Stores" item in More Menu.
 ### In the free version you can work with 2 stores. If you need more Stores you can buy a subscription "Multiple Stores" or "Complete Pro". Every subscription provides 7-days free trial.
 """;

const String _markdownDataGoodsVN = """
 ### Màn hình Sản Phẩm chứa các Sản phẩm, mặt hàng trong cửa hàng của bạn, bao gồm cả thông tin số lượng tồn kho của sản phẩm. 
 ### Khi tạo các Giao Dịch, bạn sẽ chọn các sản phẩm từ danh sách này. Hơn nữa, nếu một sản phẩm có mã vạch, thì nó có thể được chọn trong giao dich một cách nhanh chóng bằng việc quét mã vạch đó với camera. Số lượng tồn kho không thể chỉnh sửa, mà được tính toán thông qua các dữ liệu trong các giao dich.
 
 - ### Trong quá trình nhập thông tin sản phẩm, bạn có thể dùng camera để quét mã vạch bằng cách nhấn nút bên cạnh trường mã vạch.
 - ### Để xoá sản phẩm thì hãy nhấn giữ trên sản phẩm đó.
 - ### Để tìm kiếm, sắp xếp, thì sử dụng các nút ở trên thanh công cụ
 
 ### Bạn có thể tạo SP mới trong quá trình tạo Giao Dịch.
 """;
const String _markdownDataGoodsEN = """
 ### Screen Goods contains list(catalog) of all your goods including information about quantity in stock.
 ### You add items to documents selecting them  from this catalog. Moreover, if item has a barcode it can be added to document very quickly simply by scanning this barcode with camera. Quantity in stock is not editable, it is calculated using data in your documents.
 
 - ### During manual entry you can read product barcode with camera by pressing button next to barcode field.
 - ### To delete item from the list long press the item.
 - ### For search and sorting you can use top toolbar buttons.
 
 ### You can start working without filling in Goods catalog - you can create Incoming document, enter information about new products these manually and these positions will be added to catelog automatically. Next time you will be able to use barcode scanner and add these items to document by barcode.
 """;

const String _markdownDataDocumentsVN = """
### Có 2 loại giao dịch:

- ### Nhập - Bạn tạo loại giao dịch này khi mà bạn nhập các sản phẩm/ hàng hoá về cửa hàng của mình (ví dụ, bạn mua sản phẩm từ NCC nào đó). Số lượng của những sản phẩm trong giao dịch này sẽ tự động tăng lên trong kho của bạn. 
- ### Xuất - Bạn tạo loại giao dịch này khi mà bạn xuất các sản phẩm từ cửa hàng của mình (ví dụ, bạn bán sản phẩm cho Khách hàng nào đó). Số lượng của những sản phẩm trong giao dịch này sẽ tự động trừ đi trong kho của bạn.
 
### Bạn có thể thêm sản phẩm trong giao dịch bằng cách chọn chúng trong danh sách các sản phẩm, hoặc quét mã vạch của sản phẩm.
### Cụ thể hơn, ứng dụng cung cấp chế độ "quét 1 trùm". Trong chế độ này bạn có thể liên tục quét mã vach của sản phẩm và số lượng của chúng sẽ được tăng thêm 1 sau mỗi lần quét, hoặc bạn nhập bằng tay số lượng SP sau mỗi lần quét. 
### Để mà xoá các giao dịch, hoặc các sản phẩm trong giao dịch thì nhấn giữ chúng (để hiên tuỳ chọn).
### Xoá các giao dịch thì dẫn đến sự thay đổi số lượng SP trong cửa hàng. Các giao dịch có thể được xoá chỉ khi nó là giao dịch cuối cùng, vì việc xoá các giao dịch trước sẽ gây ra lỗi trong việc tính toán số lượng SP.

### Sử dụng các nút trên thanh công cụ để sắp xếp và lọc các giao dịch. 
 
 """;
const String _markdownDataDocumentsEN = """
### There are 2 types of documents:

- ### Incoming - You create this type of document when items arrive at your warehouse. Items in documents are added to quantities in stock.
- ### Outgoing - You create this type of documents when goods leave warehouse (e.g. you send goods to somebody). Items in document are subtracted from the stock.

### You can add item to document simply selecting it from Goods catalog or scanning item's barcode.
### In addition, application provides "batch scan" mode. In this mode you continuously scan items' barcodes and these items are added to document in background. Quantity is increased by 1 with each scan or, alternatively, after each scan you enter item's quantity manually in the input field - you can choose from these options in "Settings".
### When you add item to document and there is no such item in Goods catalog, it will be added there automatically, if you entered full info about the product. But, it is impossible to add item to Outgoing document if there is no such item in Goods catalog, since we can't ship goods which are out of stock.
### To delete document or document's line use long press (to show popup menu)
### Deletion obviously leads to changes in quantities in stock. Inventory documents can be deleted only in case if it is the last document, because deletion of any previous Inventory documents could result in erroneous data about quantities in stock.

### Use top toolbar buttons to filter and sort documents in the list.
 """;

const String _markdownDataExpenseVN = """
 ### Dòng tiền là số tiền hiện có của cửa hàng đó. 
 ### Mỗi cửa hàng đều mất chi phí để vận hành chúng (tiền điện, tiền nước, tiền nhân viên), bạn có thể tạo ra các lệnh dòng tiền âm, để theo dõi chúng.
 ### Khi nhập hàng thì chủ cửa hàng cũng mất 1 luợng tiền, lúc này bạn cũng có thể tạo ra lệnh dòng tiền âm, để theo dõi.
 ### Khi xuất hàng thì bạn tạo ra các lệnh dòng tiền dương, để theo dõi. 
 ### Như vậy, với bất kì điều gì làm số tiền trong kho thay đổi, bạn có thể tạo các lệnh tương úng. Chúng ta sẽ tổng kết được, doanh thu của cửa hàng mỗi tháng, lời lỗ ra sao :D 
 """;
const String _markdownDataExpenseEN = """
 ### We have added a simple function to track your revenue of your stores in the application. These can be cost of fuel, rent, wages...
 ### After create a incoming document, you can create negative amount command to decrease store's money
 ### After create a outgoing document, you can create positive amount command to increase store's money.
 ### So each month, we can track your revenue of your stores.
 """;

const String _markdownDataWhatsNewVN = """
 ## Phiên bản 1.0.0
 
 ### Lần đầu tiên ra mắt chưa có gì để nói cả :), mọi người chọn nút trợ giúp ở từng màn hình để hiểu rõ nhé.
 """;
const String _markdownDataWhatsNewEN = """
 ## Version 1.0.0
 
 ### First Release.
 """;
enum HelpType{
  STORE,
  SUPPLIER_AND_CUSTOMER,
  GOODS,
  DOCUMENTS,
  EXPENSE,
  WHATSNEW
}
class HelpUtils {
  static String getMarkdownData(String code, HelpType help){
    if (code == "vi"){
      switch(help){
        case HelpType.STORE:
          return _markdownDataStoreVN;
          break;
        case HelpType.SUPPLIER_AND_CUSTOMER:
          return _markdownDataSupplierCustomerVN;
          break;
        case HelpType.GOODS:
          return _markdownDataGoodsVN;
          break;
        case HelpType.DOCUMENTS:
          return _markdownDataDocumentsVN;
          break;
        case HelpType.WHATSNEW:
          return _markdownDataWhatsNewVN;
          break;
        case HelpType.EXPENSE:
          return _markdownDataExpenseVN;
              break;
        default:
      }
    }else{
      switch(help){
        case HelpType.STORE:
          return _markdownDataStoreEN;
          break;
        case HelpType.SUPPLIER_AND_CUSTOMER:
          return _markdownDataSupplierCustomerEN;
          break;
        case HelpType.GOODS:
          return _markdownDataGoodsEN;
          break;
        case HelpType.DOCUMENTS:
          return _markdownDataDocumentsEN;
          break;
        case HelpType.WHATSNEW:
          return _markdownDataWhatsNewEN;
          break;
        case HelpType.EXPENSE:
          return _markdownDataExpenseEN;
          break;
        default:
      }
    }
  }
}
