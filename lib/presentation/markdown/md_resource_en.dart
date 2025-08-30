class MarkdownResourceEN {
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

https://me.momo.vn/qr/nguyen-huy-hoang-z2kUuMD7go

With gratitude,
AppViet Team
  """;
  static const String whatNews = """
 ### Version 1.0.40 - 2025 Jul 25    
  * Fixed issue can not scan barcode on Android platform.
  * Fixed issue low stock alert not displayed when start app. 
  * Fixed reported bugs.
  * Support more app languages. 
  * Updated UI/UX.  
 
  ### Version 1.0.45 - 2025 Jul 12  
  * Fixed reported bugs.  
 
 ### Version 1.0.30 - 2025 May 30  
  * Fixed reported bugs.  
  * Added Minimum quantity feature
  * Added Company information feature
  * Added Dark mode, Passcode lock
  * Added new type of report: REORDER
 
 ### Version 1.0.25 - 2025 Apr 14  
  * Fixed reported bugs.
  * Added Payment features. 
  * Added Wallet features. 
  * Added new 5 report types. 
 
 
 ### Version 1.0.8 - Dec 6  
  * Fixed reported bugs. 
  * Added List Settings on Goods Page.
  * Modified Search function on Goods Page
  * Added Quick Sync option
  
  ### Version 1.0.7 - Sep 27  
  * Fixed reported bugs. 
  * Support iOS platform.
  ### Version 1.0.6 - July 07  
  * Fixed reported bugs. 
  * Added Quick create document on SaveGood page. 
  * Added Good History page. 
  
 ### Version 1.0.5 - June 14
  * Added Login/SignUp system.
  * User's data saved to cloud safety
  * Fixed reported bugs. 
 
 ### Version 1.0.4 - April 18
 
  * Fixed bug could not scroll vertically on Report Detail Page. 
 
 ### Version 1.0.3 - April 15
 
  * Added Report - Select Range Date 
  * Fixed bug on Select Group page    
 
 ### Version 1.0.2 - April 12
 
  * Support for window platform. 
  * Added Report - List of Good. 
  * Added Report - Export PDF, CSV.  
  * Added Setting - Backup, Restore. 
 
 ### Version 1.0.1 - April 4
 
  * Modified Table Transaction.Quantity from INT to REAL.
  * Added Sound and Vibration effect when a barcode scanned.
  * Updated to Material 3 Design. 
 
 ### Version 1.0.0
 
  * First Release.
 """;

  static const String helpDocuments = """
  ## Document Management Guide  

There are two types of documents:

### 📥 Incoming  
- Create this when items **arrive at your warehouse**.  
- Items listed in the document will be **added to the stock**.

### 📤 Outgoing  
- Create this when items **leave the warehouse** (e.g. sent to a customer).  
- Items will be **subtracted from the stock**.

---

### ➕ Adding Items to a Document  
- Select items from the **Goods catalog** or  
- **Scan the barcode** using your device’s camera.

---

### 🔄 Batch Scan Mode  
The app supports **Batch Scan Mode** for quick entry:
- Continuously scan item barcodes — each scan **adds the item and increases its quantity by 1**.
- Or, after each scan, **manually enter the quantity**.
- You can choose your preferred mode in **Settings**.

---

### 📦 Auto-Creation from Documents  
- If you add a **new item** (not yet in the Goods catalog) to an **Incoming** document and provide complete info, the item will be **automatically added to the catalog**.  
- You **cannot** add new items to an **Outgoing** document unless they already exist in the catalog, as items must be in stock to be shipped.

---

### 🗑️ Deleting Documents or Lines  
- **Long-press** on a document or its item line to access delete options.

🛑 **Important Note**:  
- Deleting a document affects your stock levels.  
- You can only delete the **last (most recent) inventory document** — deleting earlier ones could cause stock quantity errors.

---

### 📊 Filter and Sort  
- Use the toolbar buttons at the top to **filter** or **sort** documents.

Keep your documents organized for accurate inventory tracking and smooth operations! ✅  
""";

  static const String helpGoods = """
  ## Goods Management Guide  

The **Goods** screen displays a catalog of all your products, along with their current stock levels.

You can add items to documents by selecting them from this catalog.  
If a product has a barcode, you can quickly add it to a document by **scanning the barcode using your camera**.  
Note: **Stock quantity is not editable manually** – it is calculated automatically based on your documents.

---

### 🔍 Features and Actions  

- During manual entry, you can scan a product barcode by tapping the **camera button** next to the barcode field.  
- To **delete an item**, long-press on it in the list.  
- Use the **top toolbar buttons** to search or sort your goods.

---

### ⚙️ Auto-Creation of Goods  

You can begin working without pre-filling the goods catalog.  
Just create an **Incoming Document** and manually enter new product details —  
These items will then be **automatically added to your catalog**.  
Next time, you’ll be able to use the barcode scanner to add them instantly.

Efficient goods management helps speed up your workflow and maintain accurate stock control. ✅  
""";

  static const String helpStores = """
  ## Store Management Guide  

You can organize and track items by **Stores** (e.g. Shops, Warehouses).

---

### 🏪 Store-Specific Inventory  
- Each Store maintains its **own stock levels**.  
- All documents (invoices, transactions) are linked to a **specific Store**.

---

### 📍 Selecting a Store  
- In the **Home Menu**, you can choose the **current Store** you're working with.  

---

### ➕ Adding More Stores  
- To add more Stores, go to the **"Stores"** section in the **More Menu**.  

---

### 💡 Store Limits & Subscriptions  
- The **free version** supports up to **2 Stores**.  
- To unlock more, upgrade to:  
  - **"Stock Premium"**  
- Each subscription includes a **7-day free trial**.

Managing stores separately helps you maintain accurate stock tracking across multiple locations. ✅  
""";
  static const String helpSupplierCustomers = """
  ## Supplier & Customer Management Guide  

You can manage and track both your **Suppliers** and **Customers** in one place.  
Add their details manually or **import directly from your device's Contacts**.

---

### 🏷️ Assigning to Documents  
- When editing a document:  
  - Tap **Supplier** to assign to an **Incoming (Purchase)** document.  
  - Tap **Customer** to assign to an **Outgoing (Sales)** document.

---

### 🗂️ Manage Records  
- **Long-press** on a Supplier or Customer to:  
  * View all related documents  
  * Delete the record (if no longer needed)

Keeping your supplier and customer information organized ensures smoother transactions and accurate reporting. ✅  
""";
  static const String helpPayments = """
  ## Payment Management Guide  

There are two types of payments:

### 💰 Inbound (Received)  
- Record this when you **receive money** from a customer.  
- Typically linked to a **sale** or **outgoing document**.  
- Helps track **incoming cash flow**.

### 💸 Outbound (Paid)  
- Record this when you **make a payment** to a supplier.  
- Typically linked to a **purchase** or **incoming document**.  
- Helps track **expenses and outgoing cash flow**.

---

### ➕ Adding a Payment  
- Go to the **Payments** section or use the shortcut from a document detail screen.  
- Choose the **type** (Inbound or Outbound).  
- Enter the **amount**, **date**, **payer/payee**, and optional **notes**.
- You can link it to an existing **document** for better tracking.

---

### 📄 Linked Documents  
- Payments can be linked to **documents** to show what the payment is for.
- If a payment covers part of a document's total, it will be marked as **Partial**.
- Fully paid documents will be marked as **Paid**.

---

### 📝 Edit or Delete Payments  
- **Long-press** a payment to edit or delete it.  
- Be careful: deleting payments may affect document payment status.

---

### 📊 Filter and Sort  
- Use the toolbar buttons at the top to **filter** or **sort** payments.

Keep your payment records up to date to ensure accurate financial tracking! ✅  
""";

//  static const String helpSavePayment = """
//   ## Payment Saving Guide
//
// This page helps you accurately record your payments.
//
// ### 📂 Select a Payment Category
// - Choose the appropriate category to easily track expenses or income.
// - Examples: **Food, Transportation, Salaries, Sales Revenue**, etc.
// - If no suitable category exists, you can create a new one.
//
// ### ✏️ Edit or Delete a Category
// - **Long-press** on a category in the list to show the options to **edit** or **delete**.
// - If a category is deleted, related payments will be assigned to a default category.
//
// ### 🧾 Select an Invoice
// - You can **link a payment to an invoice** for better tracking.
// - If the invoice is not in the list, check again or create a new one.
// - The system will automatically assign the payment amount based on the selected invoice.
//
// ### 💾 Save Payment
// - Enter all required details: **Amount, Payment Date, Notes (if any)**.
// - Double-check before clicking **Save** to avoid mistakes.
//
// ### 🗑️ Delete a Payment
// - To delete a payment, **long-press** on the item in the list.
//
// Ensure accurate entries for better financial tracking! ✅
//
// """;

  static const String helpMinQuan = """
  ## Minimum Quantity Guide  

This page helps you manage stock levels by setting a **Minimum Quantity** for each product.  

### 📦 What is Minimum Quantity?  
- The **Minimum Quantity** is the lowest stock level allowed before you need to reorder.  
- When stock drops below this level, the item will appear in the **Reorder Report**.  

### 🛠️ Set Minimum Quantity  
- Go to the **Item Settings** when adding or editing a product.  
- Enter a number in the **Min Quantity** field (e.g., 5 or 10).  
- This value represents the minimum units you'd like to keep in stock.  

### 📉 Monitor Low Stock  
- Use the **Reorder Report** to view all items that are below their set Minimum Quantity.  
- This helps prevent stockouts and improves inventory planning.  

### 🔄 Update Minimum Quantity  
- You can update the Min Quantity anytime by editing the product.  
- Adjust levels based on sales trends or seasonal demand.  

### ✅ Best Practices  
- Set higher Min Quantity for fast-selling or critical items.  
- Review and adjust regularly to ensure accurate alerts.  

Keep your stock levels under control and avoid unexpected shortages! 🔔  
""";
}
