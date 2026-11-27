# Import from contacts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** Trên `SuppliersPage` và `CustomersPage`, chuyển nút help vào overflow menu (⋮) và thêm mục
"Import from contacts" chọn một liên hệ, map vào model rồi mở trang Save điền sẵn.

**Architecture:** Một mapper thuần (`mapContact`) biến `Contact` của plugin thành `ContactFields`;
một service tĩnh (`ContactImportService`) xin quyền + mở picker + gọi mapper; một widget overflow
dùng chung cho cả 4 màn hình. Cubit kiểm tra giới hạn free trước khi mở picker, rồi
`onAddItem(item)` (luồng Save sẵn có). Không đổi DI, state freezed hay data layer.

**Tech Stack:** Flutter, `flutter_bloc`, `easy_localization`, `permission_handler` (đã có),
`flutter_native_contact_picker_plus ^1.3.2` (mới, người dùng đã duyệt).

**Spec:**
`D:\WorkSpace\StockandInventoryOffline\docs\superpowers\specs\2026-11-27-import-from-contacts-design.md`

## Global Constraints

- Không commit, không push; người dùng xem diff và commit riêng (CLAUDE.md workspace). Plan này
  không có bước commit.
- Làm ở Offline trước (`D:\WorkSpace\StockandInventoryOffline`), Task 7 port sang Online
  (`D:\WorkSpace\StockandInventoryOnline`). Hai app không có package chung: mã dùng chung được copy
  nguyên văn.
- Không đụng `repo/`, `data/`, `domain/`. Không sửa `di.config.dart`, `*.freezed.dart`, `*.g.dart`;
  không đổi constructor cubit, không đổi `*_state.dart`.
- Chuỗi mới `action_import_from_contacts` phải có trong cả 11 file `assets/translations/` (sửa JSON
  trực tiếp). Help dùng lại `action_help`.
- Mục Import ẩn trên nền tảng không phải Android/iOS.
- Offline: trước khi sửa đã đọc `AGENTS.md` và `CONTEXT.md`; sau khi sửa chạy `flutter analyze` và
  `flutter test`.
- Online: chạy `git status` trước khi port; repo đang có thay đổi chưa commit của người khác ở
  `assets/translations/*.json`, `home_page.dart`, `main_page.dart`, `menu_page.dart`,
  `revenuecat_purchase_manager.dart`, `windows/flutter/*`: chỉ chèn thêm dòng, không revert hay
  format lại.
- Quyền: `READ_CONTACTS` (Android), `NSContactsUsageDescription` + `PERMISSION_CONTACTS=1` (iOS). Bị
  từ chối quyền thì vẫn import tên + số, không báo lỗi.

## Review Focus

1. Liên hệ không có `fullName` nhưng có công ty → `name` = công ty (Task 2 test).
2. Chuỗi toàn khoảng trắng coi như rỗng; cả tên lẫn công ty rỗng → không import (Task 2 test).
3. Địa chỉ thiếu một số phần → không thừa dấu phẩy (Task 2 test).
4. Quyền bị từ chối: danh sách email/địa chỉ rỗng hoặc `null`, không crash, `description` rỗng (Task
   2 test).
5. iOS: `selectedPhoneNumber == null`, `phoneNumbers` có nhiều số → số đầu là `phone`, các số còn
   lại vào `description` (Task 2 test).
6. Đã chạm giới hạn free → popup có sẵn hiện, picker KHÔNG mở (Task 6 xác minh trên emulator).
7. Người dùng đóng picker (kết quả `null`) → không điều hướng, không thêm gì (Task 6 xác minh trên
   emulator).

## File Structure

Mới (Offline, copy nguyên sang Online):

- `lib/presentation/pages/contact_import/contact_import_mapper.dart` — `ContactFields`,
  `mapContact`. Thuần Dart, không phụ thuộc store hay UI.
- `lib/presentation/pages/contact_import/contact_import_service.dart` — `ContactImportService`
  (isSupported, pickContact).
- `lib/presentation/pages/contact_import/person_list_overflow_button.dart` —
  `PersonListOverflowButton`.
- `test/contact_import_mapper_test.dart`, `test/person_list_overflow_button_test.dart`,
  `test/contact_import_translations_test.dart`.

Sửa: `pubspec.yaml`, `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`,
`ios/Podfile`, `assets/translations/*.json` (11), `suppliers_cubit.dart`, `customers_cubit.dart`,
`suppliers_page.dart`, `customers_page.dart`, `CONTEXT.md`.

---

### Task 1: Chuỗi dịch `action_import_from_contacts`

**Files:**

- Modify:
  `assets/translations/{ar-SA,de-DE,en-US,es-ES,fr-FR,hi-IN,ja-JP,pt-BR,ru-RU,vi-VN,zh-CN}.json`
  (chèn ngay sau dòng `"action_help"`)
- Test: `test/contact_import_translations_test.dart`

**Interfaces:**

- Produces: key `action_import_from_contacts` trong cả 11 locale.

- [ ] **Step 1: Viết test thất bại**
  `contact imports: every locale defines action_import_from_contacts` — đọc từng
  `assets/translations/*.json` bằng `File` + `jsonDecode`, `expect` giá trị của key là `String`
  không rỗng, và `expect` số file tìm thấy == 11.
- [ ] **Step 2: Chạy** `flutter test test/contact_import_translations_test.dart`. Kỳ vọng: FAIL (key
  thiếu).
- [ ] **Step 3: Thêm key vào 11 file** với đúng các chuỗi: en `Import from contacts`, vi
  `Nhập từ danh bạ`, ar `استيراد من جهات الاتصال`, de `Aus Kontakten importieren`, es
  `Importar desde contactos`, fr `Importer depuis les contacts`, hi `संपर्कों से आयात करें`, ja
  `連絡先からインポート`, pt-BR `Importar dos contatos`, ru `Импорт из контактов`, zh-CN
  `从通讯录导入`. Giữ nguyên thụt lề, dấu phẩy và thứ tự dòng khác.
- [ ] **Step 4: Chạy lại test.** Kỳ vọng: PASS.

### Task 2: Mapper `mapContact` + dependency plugin

**Files:**

- Modify: `pubspec.yaml` (thêm `flutter_native_contact_picker_plus: ^1.3.2` cạnh
  `permission_handler`), rồi `flutter pub get`.
- Create: `lib/presentation/pages/contact_import/contact_import_mapper.dart`
- Test: `test/contact_import_mapper_test.dart`

**Interfaces:**

- Produces:
    -
    `class ContactFields { const ContactFields({required this.name, this.phone = '', this.email = '', this.address = '', this.description = ''}); final String name, phone, email, address, description; }`
    - `ContactFields? mapContact(Contact contact)` (`Contact` từ
      `package:flutter_native_contact_picker_plus/model/contact_model.dart`). Trả `null` khi cả tên
      lẫn công ty rỗng.

- [ ] **Step 1: Viết test thất bại**, mỗi test dựng `Contact(...)` trực tiếp:
    - `maps a full contact`: `fullName 'Nguyen Van An'`, `selectedPhoneNumber '0901234567'`,
      `phoneNumbers ['0901234567']`, `emailAddresses [EmailAddress(email:'an@example.com')]`,
      `postalAddresses [PostalAddress(street:'12 Le Loi', city:'HCM')]`,
      `organizationInfo OrganizationInfo(company:'Cong ty ABC', jobTitle:'Giam doc')`,
      `notes 'Ghi chu'` → `name 'Nguyen Van An'`, `phone '0901234567'`, `email 'an@example.com'`,
      `address '12 Le Loi, HCM'`, `description 'Cong ty ABC - Giam doc\nGhi chu'`.
    - `falls back to company when name is blank`: `fullName '  '`, `company 'Cong ty ABC'` →
      `name 'Cong ty ABC'`, `description ''`.
    - `returns null when name and company are blank`.
    - `permission denied: only name and phone`: `emailAddresses: []`, `postalAddresses: null`,
      `organizationInfo: null` → `email ''`, `address ''`, `description ''`.
    - `address skips empty parts`: `PostalAddress(street:' ', city:'HCM', country:'VN')` →
      `'HCM, VN'`.
    - `extra emails go to description`: hai email → `email` là email đầu, `description == 'b@x.com'`
      (email thứ hai).
    - `iOS: first of phoneNumbers is phone, the rest go to description`:
      `selectedPhoneNumber: null`, `phoneNumbers ['111','222']` → `phone '111'`,
      `description '222'`.
    - Thứ tự `description`: công ty/chức danh, ghi chú, email thừa, số thừa; mỗi mục một dòng; bỏ
      qua mục rỗng; bỏ phần công ty khi nó trùng `name`.
- [ ] **Step 2: Chạy** `flutter test test/contact_import_mapper_test.dart`. Kỳ vọng: FAIL (file chưa
  có).
- [ ] **Step 3: Thêm dependency** rồi implement `mapContact` đúng signature trên. Mọi chuỗi
  `trim()`; lọc rỗng trước khi chọn "đầu tiên". `phone = selectedPhoneNumber` nếu không rỗng, ngược
  lại phần tử đầu của `phoneNumbers`.
- [ ] **Step 4: Chạy lại test.** Kỳ vọng: PASS toàn bộ.

### Task 3: `ContactImportService` + cấu hình quyền nền tảng

**Files:**

- Create: `lib/presentation/pages/contact_import/contact_import_service.dart`
- Modify: `android/app/src/main/AndroidManifest.xml` (thêm
  `<uses-permission android:name="android.permission.READ_CONTACTS"/>` cùng nhóm các
  `uses-permission` khác), `ios/Runner/Info.plist` (thêm `NSContactsUsageDescription`, chuỗi tiếng
  Anh: `Used to import a supplier or customer from your contacts.`), `ios/Podfile` (trong vòng
  `target.build_configurations.each` đã có ở `post_install`, thêm
  `config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'PERMISSION_CONTACTS=1']`).

**Interfaces:**

- Consumes: `mapContact`, `ContactFields` (Task 2).
- Produces:
    -
    `class ContactImportService { static bool get isSupported; static Future<ContactFields?> pickContact(); }`
    - `isSupported` =
      `!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)`.
    - `pickContact`: `await Permission.contacts.request()` (bỏ qua kết quả) →
      `FlutterContactPickerPlus().selectContact()` → `null` nếu người dùng hủy hoặc
      `PlatformException`; ngược lại `mapContact(contact)`.

- [ ] **Step 1: Implement** service đúng signature, không DI (static, để khỏi đổi constructor
  cubit).
- [ ] **Step 2: Sửa ba file cấu hình** như trên.
- [ ] **Step 3: Chạy** `flutter analyze lib/presentation/pages/contact_import`. Kỳ vọng: không có
  lỗi.

### Task 4: `PersonListOverflowButton`

**Files:**

- Create: `lib/presentation/pages/contact_import/person_list_overflow_button.dart`
- Test: `test/person_list_overflow_button_test.dart`

**Interfaces:**

- Produces: `enum PersonListOverflowMenu { importFromContacts, help }` và
  `class PersonListOverflowButton extends StatelessWidget { const PersonListOverflowButton({super.key, required this.importLabel, required this.helpLabel, required this.onImportFromContacts, required this.onHelp, this.showImport = true}); }`
    - `showImport == false` → chỉ còn mục Help. Thứ tự: Import, Help.
    - Dựa trên `PopupMenuButton<PersonListOverflowMenu>` của `goods_view.dart`:
      `offset: Offset(0, 8)`, bo góc 12.
    - Label truyền từ ngoài (không gọi `context.tr`) để test không cần `EasyLocalization`.

- [ ] **Step 1: Viết test thất bại** (`testWidgets`, bọc
  `MaterialApp(home: Scaffold(appBar: AppBar(actions:[…])))`):
    - `shows import then help`: bấm `Icons.more_vert` → `find.text('Import X')` và
      `find.text('Help X')` đều có, Import nằm trên Help.
    - `selecting import calls onImportFromContacts only` và `selecting help calls onHelp only`.
    - `showImport false hides import`: chỉ thấy Help.
- [ ] **Step 2: Chạy** test. Kỳ vọng: FAIL.
- [ ] **Step 3: Implement** widget đúng signature.
- [ ] **Step 4: Chạy lại test.** Kỳ vọng: PASS.

### Task 5: Suppliers — cubit + page

**Files:**

- Modify: `lib/presentation/pages/suppliers/bloc/suppliers_cubit.dart`,
  `lib/presentation/pages/suppliers/suppliers_page.dart` (`_buildAppBar`).

**Interfaces:**

- Consumes: `ContactImportService.pickContact/isSupported`, `PersonListOverflowButton`.
- Produces: `Future<void> SuppliersCubit.onImportFromContactsClicked()`:
    1. `if (!await isValidToAddMoreSupplier())` → (nếu `isClosed` thì return)
       `emit(state.copyWith(state: OpenBuySubscriptionDialogState()))`, return.
    2. `final f = await ContactImportService.pickContact();` → `if (isClosed || f == null) return;`
    3. `Supplier()` với `storeId = AppSettings.getSelectedStoreId()`,
       `name/phone/email/address/description` từ `f`; `onAddItem(item)`.

- [ ] **Step 1: Thêm `onImportFromContactsClicked`** vào cubit (đặt cạnh `onAddButtonClicked`).
  Không thêm test cubit: `isValidToAddMoreSupplier` gọi `RevenueCatService.isPro()` và `AppSettings`
  tĩnh, repo không có cách giả sẵn; hành vi xác minh ở Task 6.
- [ ] **Step 2: Sửa AppBar**: bỏ `IconButton` help, thay bằng
  `PersonListOverflowButton(importLabel: context.tr('action_import_from_contacts'), helpLabel: context.tr('action_help'), showImport: ContactImportService.isSupported, onImportFromContacts: () => context.read<SuppliersCubit>().onImportFromContactsClicked(), onHelp: () => context.read<SuppliersCubit>().onHelpMenuClick())`.
  Giữ nút `+` và `SizedBox(width: 16)`.
- [ ] **Step 3: Chạy** `flutter analyze`. Kỳ vọng: không lỗi mới.

### Task 6: Customers — cubit + page, rồi xác minh trên emulator

**Files:**

- Modify: `lib/presentation/pages/customers/bloc/customers_cubit.dart`,
  `lib/presentation/pages/customers/customers_page.dart`.

**Interfaces:**

- Produces: `Future<void> CustomersCubit.onImportFromContactsClicked()`, y hệt Task 5 với
  `Customer`, `isValidToAddMoreCustomer()` (xác nhận tên hàm thật trong file trước khi gọi) và
  `FreeLimits.customerLimit`.

- [ ] **Step 1: Làm đúng Task 5 Step 1–2 cho Customers** (tên hàm giới hạn lấy từ
  `customers_cubit.dart`).
- [ ] **Step 2: Chạy** `flutter analyze` rồi `flutter test`. Kỳ vọng: analyze không lỗi mới, mọi
  test PASS (gồm test của Task 1, 2, 4).
- [ ] **Step 3: Chạy app trên emulator** `emulator-5554` (`flutter run -d emulator-5554`) và kiểm
  tra tay, ghi kết quả từng mục:
    - Cả hai màn: AppBar có `+` và ⋮; ⋮ mở menu Import rồi Help; Help mở trang help như cũ.
    - Chọn "Nguyen Van An" (dòng số `0901234567`) khi đã cấp quyền: trang Save mở với `name`,
      `phone`, `email`, `address` điền, `description` chứa `Cong ty ABC - Giam doc` và
      `Ghi chu thu`.
    - Từ chối quyền: vẫn mở Save với `name` + `phone`, `email`/`address` trống.
    - Đóng picker không chọn: không điều hướng.
    - Thêm đủ 5 supplier (Pro tắt) rồi Import: hiện popup `buy_subscription_to_add_more_entity`,
      picker không mở. Lặp lại cho 5 customer.
- [ ] **Step 4: Cập nhật tài liệu** theo AGENTS.md: thêm dòng
  `Contacts | flutter_native_contact_picker_plus (+ permission_handler)` vào bảng Technology stack
  của `CONTEXT.md`.

### Task 7: Port sang Online

**Files (Online):** `pubspec.yaml`, `AndroidManifest.xml`, `Info.plist`, `ios/Podfile`,
`assets/translations/*.json` (11), 3 file `contact_import/` + 3 file test (copy nguyên văn từ
Offline), `suppliers_cubit.dart`, `customers_cubit.dart`, `suppliers_page.dart`,
`customers_page.dart`.

**Khác biệt cần giữ (KNOWN_DIFFERENCES.md):**

- `Supplier`/`Customer` không có `storeId`: bỏ dòng gán `storeId`.
- Số lượng hiện có lấy qua `repo.getCount()` — dùng nguyên `isValidToAddMoreSupplier/Customer` sẵn
  có của Online.
- AppBar Online bọc `+` trong `RoleGuard(condition: AppSettings.getSelectedStoreRole().canEdit)`:
  `showImport: ContactImportService.isSupported && AppSettings.getSelectedStoreRole().canEdit`; thêm
  `tooltip` nếu nút gốc có.
- `ios/Podfile` Online chưa có vòng `build_configurations`: thêm vòng đó trong `post_install` để đặt
  `PERMISSION_CONTACTS=1` mà không đổi gì khác.
- `permission_handler` Online là `^11.4.0` (giữ nguyên, không nâng).

- [ ] **Step 1: `git status` ở Online**, ghi lại các file đã bị sửa sẵn (xem Global Constraints).
- [ ] **Step 2: Port** theo bảng trên; dùng `/port-ui` cho phần page nếu tiện, phần cubit + dịch +
  cấu hình làm tay.
- [ ] **Step 3: Chạy** `flutter pub get`, `flutter analyze`, `flutter test` ở Online. Kỳ vọng: không
  lỗi mới, test mới PASS.
- [ ] **Step 4: Báo kết quả** cho người dùng, kèm: chưa chạy được trên iOS; Online chưa kiểm tra
  trên thiết bị nếu không đăng nhập Firebase được.

---

## Self-Review

- **Spec coverage:** overflow menu + thứ tự (Task 4–6); kiểm tra giới hạn trước picker (Task 5–6);
  mapping `name/phone/email/address/description` (Task 2); quyền + đường lùi (Task 3); ẩn trên
  Windows (Task 3 `isSupported`, Task 4 `showImport`); chuỗi dịch (Task 1); Online (Task 7); docs
  (Task 6 Step 4).
- **Chỗ plan khác spec (quyết định của plan):** spec ghi `phone ← selectedPhoneNumber`; plan thêm
  "nếu rỗng thì lấy số đầu của `phoneNumbers`" vì iOS không có `selectedPhoneNumber`; số thừa vào
  `description` theo đề xuất lúc brainstorm. Quyền bị từ chối vĩnh viễn: không snackbar, chỉ rút về
  tên + số (spec để builder quyết). Service tĩnh để khỏi đổi DI.
- **Nhất quán tên:** `ContactFields`, `mapContact`, `ContactImportService.pickContact/isSupported`,
  `PersonListOverflowButton`, `PersonListOverflowMenu`, `onImportFromContactsClicked` dùng đồng nhất
  ở mọi task.
- **Chưa kiểm chứng:** iOS; hành vi cubit chỉ được xác minh bằng chạy tay.
