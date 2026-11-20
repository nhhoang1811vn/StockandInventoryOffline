class MarkdownResourceEN {
  static const String whatNews = """
### Version 1.0.95 - 20 Nov 2026
* New Sales reports on the Report screen: by date, by item, by customer and by month, with filters for group, customer and year.
* New Purchase reports: by date, by item, by supplier and by month, with a supplier filter.
* Reports for the current month and current year now end today.
* Fixed the wrong translation of "amount" in several languages.

### Version 1.0.94 - 17 Nov 2026
* The Windows version is now available. See the new banner on Home to download it.
* You can now copy a good or a group: long-press it, choose Copy, then pick the store and group.
* Unlock with your fingerprint (Face ID on iPhone) when the passcode lock is on.
* The app now locks automatically after a period of inactivity (30 minutes by default, adjustable in Settings).
* New image size setting, and an option to hide the crop window when adding pictures.
* New delay between scans setting for batch scanning.
* Resetting document numbering now asks for confirmation.
* Fixed crashes when offline, when the profile photo cannot load, or when entering an invalid price or amount.
* Fixed crashes in the Documents, Payments and History lists after deleting or filtering items, and when camera or notification permission is denied.

### Version 1.0.93 - 30 Oct 2026
* New modern notifications that slide in from the top. Swipe up or tap to dismiss.
* All messages now use the same notification style, with colors for success, warning and error.
* The app is now named Stock & Inventory Manager.
* More consistent spacing and sizes for cards and lists across screens.
* Cleaner long-press menu on items.
* Fixed the Review the app button in Settings so it opens the store page.

### Version 1.0.92 - 12 Oct 2026
* Showed incoming and outgoing count and amount on the Home documents card.
* Added a summary bar on Goods, History, Documents, Payments, Stores, Suppliers, and Customers.
* Document and payment summaries follow the selected tab.
* Supplier uses a truck icon. Customer uses a users icon.
* Help and release notes are available in every app language.

### Version 1.0.91 - 08 Oct 2026
* Added Excel import and export on the Inventory menu.
* Added long-press actions for recent documents on Home.
* Added long-press actions for search results.
* Renamed Categories to Payment Categories in Settings.

### Version 1.0.90 - 06 Oct 2026
* Updated Home, Inventory, Payments, Reports, and Settings.
* Added photos for stores, groups, customers, and suppliers.
* Updated lists, empty states, and onboarding.
* Improved translations.
* Fixed reported bugs.

### Version 1.0.80 - 23 Apr 2026
* Fixed reported bugs.
* Added a guide to migrate to the online version.
* Revamped the UI.

### Version 1.0.75 - 16 Apr 2026
* Fixed reported bugs.
* Added a new currency.
* Fixed duplicate barcodes on goods.

### Version 1.0.70 - 06 Feb 2026
* Fixed reported bugs.
* Added a new currency.
* Updated data sync.
* Updated the logo (for the online version).

### Version 1.0.65 - 20 Sep 2025
* Fixed reported bugs.
* Added report type: Good info.

### Version 1.0.60 - 09 Sep 2025
* Fixed Apple account login.
* Fixed reported bugs.
* Added theme, language, and currency settings.
* Updated the logo and files on Save Good.
* Updated authentication.
* Updated the UI.

### Version 1.0.45 - 12 Jul 2025
* Fixed reported bugs.

### Version 1.0.40 - 25 Jul 2025
* Fixed barcode scanning on Android.
* Fixed the low-stock alert not showing at startup.
* Fixed reported bugs.
* Added app language in the menu.
* Updated the UI.

### Version 1.0.30 - 30 May 2025
* Fixed reported bugs.
* Added minimum quantity.
* Added company information.
* Added dark mode and passcode lock.
* Added Reorder report.

### Version 1.0.25 - 14 Apr 2025
* Fixed reported bugs.
* Added payments.
* Added wallets.
* Added 5 report types.

### Version 1.0.8 - 06 Dec 2024
* Fixed reported bugs.
* Added list settings on Goods.
* Updated search on Goods.
* Added Quick Sync.

### Version 1.0.7 - 27 Sep 2024
* Fixed reported bugs.
* Added iOS support.

### Version 1.0.6 - 07 Jul 2024
* Fixed reported bugs.
* Added quick create document on Save Good.
* Added Good History.

### Version 1.0.5 - 14 Jun 2024
* Added login and sign up.
* User data is saved to the cloud.
* Fixed reported bugs.

### Version 1.0.4 - 18 Apr 2024
* Fixed scrolling on Report Detail.

### Version 1.0.3 - 15 Apr 2024
* Added report date range.
* Fixed Select Group.

### Version 1.0.2 - 12 Apr 2024
* Added Windows support.
* Added List of Goods report.
* Added PDF and CSV export.
* Added backup and restore.

### Version 1.0.1 - 04 Apr 2024
* Changed document quantity from integer to decimal.
* Added sound and vibration when scanning a barcode.
* Updated to Material 3.

### Version 1.0.0
* First release.
 """;

  static const String helpDocuments = """
## Documents

Documents record stock moving in or out of a Store.

### Incoming
- Create an Incoming document when goods **arrive** at the Store.
- Quantities in the document are **added** to stock.

### Outgoing
- Create an Outgoing document when goods **leave** the Store (for example, a sale).
- Quantities in the document are **subtracted** from stock.

### Add goods
- Pick goods from the catalog, or
- **Scan a barcode** with the camera.

### Batch scan
- Scan barcodes one after another. Each scan **adds the good and increases quantity by 1**.
- Or enter the quantity **manually** after each scan.
- Choose the mode in **Settings**.

### Auto-create goods
- A **new good** added to an Incoming document (with complete info) is **saved to the catalog**.
- You cannot add a new good to an Outgoing document. The good must already exist in stock.

### Delete
- **Long-press** a document or a line to delete it.

> Deleting a document changes stock. You can delete only the **latest** document. Deleting an older one can make quantities incorrect.

### Filter and sort
- Use the toolbar to **filter** or **sort** documents.
""";

  static const String helpGoods = """
## Goods

The Goods screen is the catalog of everything in the Store, including current stock.

Add goods to a document from this list. If a good has a barcode, scan it with the camera to add it quickly.

> Stock quantity cannot be edited by hand. It is calculated from documents.

### Actions
- When editing a good, tap the **camera** next to the barcode field to scan.
- **Long-press** a good to delete it.
- Use the toolbar to **search** or **sort**.

### Auto-create
- You do not need to fill the catalog first.
- Create an Incoming document and enter a new good. It is **saved to the catalog** automatically.
- Next time, you can add it by scanning the barcode.
""";

  static const String helpStores = """
## Stores

Use Stores to keep stock separate by location (shop, warehouse, and so on).

### Stock by Store
- Each Store has its **own stock**.
- Every document belongs to **one Store**.

### Switch Store
- On **Home**, tap the Store name or avatar to change the current Store.

### Add and manage
- Open **Stores** from Settings to add, edit, or delete a Store.

### Limits
- The free version supports up to **2 Stores**.
- Upgrade to **Stock Premium** for more. The subscription includes a **7-day free trial**.
""";

  static const String helpSupplierCustomers = """
## Suppliers and customers

Keep supplier and customer records in one place. Add details by hand or **import from Contacts**.

### Assign to a document
- On an **Incoming** document, tap **Supplier**.
- On an **Outgoing** document, tap **Customer**.

### Manage records
- **Long-press** a supplier or customer to:
  - View related documents
  - Delete the record
""";

  static const String helpPayments = """
## Payments

Payments record money in and out of a Wallet.

### Inbound
- Record when you **receive money** from a customer.
- Usually linked to an **Outgoing** document.
- Tracks money coming in.

### Outbound
- Record when you **pay** a supplier.
- Usually linked to an **Incoming** document.
- Tracks money going out.

### Add a payment
- Open **Payments**, or add a payment from a document.
- Choose **Inbound** or **Outbound**.
- Enter **amount**, **date**, person, and optional notes.
- Link a **document** when needed.

### Linked documents
- A linked payment shows what the money is for.
- A partial payment marks the document as **Partial**.
- A full payment marks the document as **Paid**.

### Edit or delete
- **Long-press** a payment to edit or delete it.

> Deleting a payment can change the document payment status.

### Filter and sort
- Use the toolbar to **filter** or **sort** payments.
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
## Minimum quantity

Set a **minimum quantity** on each good so you know when to reorder.

### What it is
- The lowest stock you want to keep.
- When stock falls below this number, the good appears in the **Reorder** report and on **Home** as low stock.

### Set it
- Open a good when adding or editing.
- Enter a number in **Min quantity** (for example, 5 or 10).

### Low stock
- Use the **Reorder** report to see goods below the minimum.
- Home also shows **Out of stock** and **Low stock**.

### Update
- Edit the good any time to change the minimum.
- Adjust for sales speed or season.

### Tips
- Use a higher minimum for fast-selling or important goods.
- Review the values regularly so alerts stay useful.
""";
}
