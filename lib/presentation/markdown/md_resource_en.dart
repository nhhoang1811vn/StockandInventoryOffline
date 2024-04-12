class MarkdownResourceEN{
 static const String donationText = """
 
 🌟 Help Us Build a Better App! 🌟

Dear Community

We're reaching out to you because we believe in the power of our app to make a difference in your lives. With your support, we can take it to the next level and bring even more value to you and others in our community.

Our team is dedicated to continually improving the app, adding new features, enhancing user experience, and ensuring it remains a valuable tool for all of us. However, developing and maintaining a high-quality app requires resources, and that's where you come in.

By making a donation, you're directly contributing to the future development and sustainability of our app. Your generosity will enable us to:

Implement exciting new features requested by users like you.
Enhance performance and stability to ensure a smooth user experience.
Invest in cutting-edge technologies to stay ahead of the curve.
Expand our reach and impact, reaching more users who can benefit from our app.
Every donation, no matter how big or small, makes a difference. Your support is not only an investment in the app but also in the community we've built together.

Thank you for being a part of our journey. Together, we can create something truly special.

Donate now and be a driving force behind the app's success!

Contact my email: nhhoang1811vn+goodmanager@gmail.com

With gratitude,
AppViet Team
  """;
 static const String whatNews = """
  Version 1.0.2 - April 12
 
  * Support for window platform. 
  * Added Report - List of Good. 
  * Added Report - Export PDF, CSV.  
  * Added Setting - Backup, Restore. 
 
  Version 1.0.1 - April 4
 
  * Modified Table Transaction.Quantity from INT to REAL.
  * Added Sound and Vibration effect when a barcode scanned.
  * Updated to Material 3 Design. 
 
 Version 1.0.0
 
  * First Release.
 """;
 static const String helpExpenses = """
  We have added a simple function to track your revenue of your stores in the application. These can be cost of fuel, rent, wages...
  
  After create a incoming document, you can create negative amount command to decrease store's money
  
  After create a outgoing document, you can create positive amount command to increase store's money.
  
  So each month, we can track your revenue of your stores.
 """;
 static const String helpDocuments = """
 There are 2 types of documents:

* Incoming - You create this type of document when items arrive at your warehouse. Items in documents are added to quantities in stock.
* Outgoing - You create this type of documents when goods leave warehouse (e.g. you send goods to somebody). Items in document are subtracted from the stock.

 You can add item to document simply selecting it from Goods catalog or scanning item's barcode.
 
 In addition, application provides "batch scan" mode. In this mode you continuously scan items' barcodes and these items are added to document in background. Quantity is increased by 1 with each scan or, alternatively, after each scan you enter item's quantity manually in the input field - you can choose from these options in "Settings".
 
 When you add item to document and there is no such item in Goods catalog, it will be added there automatically, if you entered full info about the product. But, it is impossible to add item to Outgoing document if there is no such item in Goods catalog, since we can't ship goods which are out of stock.
 
 To delete document or document's line use long press (to show popup menu)
 
 Deletion obviously leads to changes in quantities in stock. Inventory documents can be deleted only in case if it is the last document, because deletion of any previous Inventory documents could result in erroneous data about quantities in stock.

 Use top toolbar buttons to filter and sort documents in the list.
 """;
 static const String helpGoods = """
  Screen Goods contains list(catalog) of all your goods including information about quantity in stock.
  You add items to documents selecting them  from this catalog. Moreover, if item has a barcode it can be added to document very quickly simply by scanning this barcode with camera. Quantity in stock is not editable, it is calculated using data in your documents.
 
 * During manual entry you can read product barcode with camera by pressing button next to barcode field.
 * To delete item from the list long press the item.
 * For search and sorting you can use top toolbar buttons.
 
  You can start working without filling in Goods catalog - you can create Incoming document, enter information about new products these manually and these positions will be added to catelog automatically. Next time you will be able to use barcode scanner and add these items to document by barcode.
 """;
 static const String helpStores = """
  You can keep track of items by Stores (Shops, Warehouses).
  
  Every Store keeps its own quantity in stock. Every document's transactions are also attached to specific Store.
  
  In the Home Menu you can select current Store to work with
  
  You can add more stores using "Stores" item in More Menu.
  
  In the free version you can work with 2 stores. If you need more Stores you can buy a subscription "Multiple Stores" or "Complete Pro". Every subscription provides 7-days free trial.
 """;
 static const String helpSupplierCustomers = """
  You can keep track of your Customers and Suppliers. Fill in their data manually or import from Contacts.
 
  Tap on Supplier when editing Document to select Supplier for Incoming document.
 
  Tap on Customer when editing Document to select Customer for Outgoing document.
 
  Long tap on a Supplier or a Customer to:
 *  Access all document of item. 
 *  Delete item.

 """;
}