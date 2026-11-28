# Home Store Guide Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Lần đầu vào Home, hiện coach mark làm nổi vùng Store và nói "chạm vào đây để đổi Store đang chọn", một lần duy nhất.

**Architecture:** Một helper nhỏ `HomeStoreGuide` giữ cờ `SharedPreferences` và dựng `TutorialCoachMark`. `HomeStoreHeader` nhận `GlobalKey` cho vùng chạm. `HomePage` chạy hướng dẫn sau frame đầu, rồi mới cho popup Online app chạy. Làm ở Offline trước, sau đó port sang Online bằng `/port-ui`.

**Tech Stack:** Flutter, `tutorial_coach_mark ^1.3.4`, `shared_preferences`, `easy_localization`.

**Spec:** `docs/superpowers/specs/2026-11-28-home-store-guide-design.md` (trong repo Offline)

## Global Constraints

- Cả hai app dùng `tutorial_coach_mark: ^1.3.4`; SDK `>=3.3.0 <4.0.0`.
- Cờ `SharedPreferences`: `home_store_guide_seen` (bool). Không có cờ thì hiện (áp dụng cả user cũ lẫn mới).
- Key dịch mới: `home_store_guide_title`, `home_store_guide_body`, `got_it`; thêm vào đủ 11 locale trong `assets/translations/` (ar-SA, de-DE, en-US, es-ES, fr-FR, hi-IN, ja-JP, pt-BR, ru-RU, vi-VN, zh-CN) ở cả hai app.
- Không đụng `repo/`, `data/`, `domain/`. Không commit, không push (CLAUDE.md của workspace); mỗi repo xem diff và commit riêng.
- Online: giữ nguyên `canEdit`, `RouteAware`, tên route (`Pages.storeList`). Chạy `git status` ở Online trước khi sửa.
- Popup Online app (Offline, chỉ mobile) chỉ được chạy sau khi hướng dẫn đóng. Lưu ý `OnlineAppPromo.shouldShowPopup` tăng bộ đếm khi được gọi, nên không được gọi nó trong lúc hướng dẫn còn mở.

## Review Focus

- Vùng Store chưa layout hoặc `key.currentContext == null` khi hiện: không crash, không ghi cờ đã xem, thử lại lần mở sau.
- Chạm đúng vùng Store: chỉ mở màn chọn Store một lần (không bị `onClickTarget` và `onFinish` cùng điều hướng), và không bật popup Online app trong lần đó.
- Người dùng rời Home hoặc `HomePage` bị dispose khi hướng dẫn đang chờ: không crash (kiểm tra `mounted`).
- Tên store rất dài và ngôn ngữ RTL (ar-SA): vùng sáng và bong bóng chữ không tràn màn hình.
- Mở Home lần hai sau khi đã xem: không hiện lại, và popup Online app vẫn chạy theo luật cũ (tối đa 3 lần).

---

### Task 1: Offline — helper, dependency, chuỗi dịch

**Files:**
- Modify: `pubspec.yaml` (thêm dependency dưới `shared_preferences`)
- Create: `lib/presentation/pages/home/home_store_guide.dart`
- Modify: 11 file `assets/translations/*.json` (thêm 3 key ở cuối)
- Test: `test/home_store_guide_test.dart`, `test/home_store_guide_translations_test.dart`

**Interfaces:**
- Produces (trong `home_store_guide.dart`):
  - `class HomeStoreGuide` (không khởi tạo được) với:
  - `static const String seenKey = 'home_store_guide_seen'`
  - `static Future<bool> shouldShow(SharedPreferences prefs)` — true nếu chưa có cờ; không ghi gì.
  - `static Future<void> markSeen(SharedPreferences prefs)`
  - `static TutorialCoachMark build({required GlobalKey target, required String title, required String body, required String buttonLabel, required VoidCallback onTapTarget, required VoidCallback onClose})` — `onClose` gọi khi bấm nút, bỏ qua, hoặc chạm nền; `onTapTarget` gọi khi chạm vào vùng sáng.

- [ ] **Step 1: Viết test cờ (fail)** trong `test/home_store_guide_test.dart`, dùng `SharedPreferences.setMockInitialValues`:
  - `'shows when the flag is absent'`: `shouldShow(prefs)` là `true`.
  - `'reading does not mark it seen'`: gọi `shouldShow` hai lần, cả hai `true`.
  - `'markSeen hides it for good'`: sau `markSeen`, `shouldShow` là `false`.
- [ ] **Step 2: Viết test dịch (fail)** trong `test/home_store_guide_translations_test.dart`, theo mẫu `test/contact_import_translations_test.dart`: với cả 11 file, mỗi key trong `['home_store_guide_title', 'home_store_guide_body', 'got_it']` là `String` không rỗng.
- [ ] **Step 3: Chạy hai test, xác nhận fail.** Run: `flutter test test/home_store_guide_test.dart test/home_store_guide_translations_test.dart` — Expected: FAIL (thiếu file, thiếu key).
- [ ] **Step 4: Thêm dependency.** `tutorial_coach_mark: ^1.3.4` vào `pubspec.yaml`, chạy `flutter pub get`.
- [ ] **Step 5: Tạo `home_store_guide.dart`** với đúng chữ ký ở Interfaces. `build` trả về một `TutorialCoachMark` có một `TargetFocus(keyTarget: target, shape: ShapeLightFocus.RRect, radius: 16, enableOverlayTab: false)`, nội dung gồm tiêu đề, nội dung và một nút bấm gọi `controller.skip()` rồi `onClose`; `onClickTarget` gọi `onTapTarget`; `onSkip` và `onFinish` gọi `onClose`. Màu chữ và bong bóng lấy từ `Theme.of(context)`.
- [ ] **Step 6: Thêm chuỗi** vào 11 locale. Giữ nguyên định dạng file (key cuối không có dấu phẩy thừa). Nội dung chuẩn:
  - en-US: `home_store_guide_title` = "Switch Store here", `home_store_guide_body` = "Tap here to change the Store you are working in.", `got_it` = "Got it".
  - vi-VN: "Đổi cửa hàng tại đây", "Chạm vào đây để đổi Store đang chọn.", "Đã hiểu".
  - 9 locale còn lại: dịch sát nghĩa hai câu trên; riêng "Store" giữ thuật ngữ mà locale đó đã dùng cho `Store` trong các key sẵn có.
- [ ] **Step 7: Chạy test, xác nhận pass.** Run: `flutter test test/home_store_guide_test.dart test/home_store_guide_translations_test.dart` — Expected: PASS.
- [ ] **Step 8: Không commit** (xem Global Constraints).

### Task 2: Offline — nối vào HomeStoreHeader và HomePage

**Files:**
- Modify: `lib/presentation/pages/home/home_store_header.dart` (thêm tham số, gắn key vào `GestureDetector`)
- Modify: `lib/presentation/pages/home/home_page.dart:48-63` (`initState`, `_maybeShowOnlineAppPopup`) và `:200-215` (`_buildHeader`)
- Test: `test/home_store_header_test.dart`

**Interfaces:**
- Consumes: `HomeStoreGuide.shouldShow/markSeen/build` từ Task 1; `_onChangeStore()` có sẵn trong `HomePage`.
- Produces: `HomeStoreHeader({..., GlobalKey? targetKey})` — `targetKey` gắn vào `GestureDetector` bao logo và tên.

- [ ] **Step 1: Viết widget test (fail)** trong `test/home_store_header_test.dart`: dựng `HomeStoreHeader` với `targetKey: GlobalKey()`, `storeName: 'Shop A'`, `logoBytes: null`, `isPro: false`, `premiumLabel: 'PREMIUM'`, `onTap` đếm số lần gọi.
  - `'targetKey is attached to the tappable area'`: sau `pumpWidget`, `key.currentContext` khác `null`.
  - `'tapping the target calls onTap once'`: `tester.tap(find.byKey(key))` → bộ đếm bằng 1.
- [ ] **Step 2: Chạy test, xác nhận fail.** Run: `flutter test test/home_store_header_test.dart` — Expected: FAIL (chưa có tham số `targetKey`).
- [ ] **Step 3: Thêm `targetKey` vào `HomeStoreHeader`** và gán `key: targetKey` cho `GestureDetector` hiện có.
- [ ] **Step 4: Chạy test, xác nhận pass.** Run: `flutter test test/home_store_header_test.dart` — Expected: PASS.
- [ ] **Step 5: Sửa `HomePage`.**
  - Thêm `final GlobalKey _storeKey = GlobalKey();` và truyền `targetKey: _storeKey` trong `_buildHeader`.
  - Thêm `Future<void> _runHomeIntros()` thay cho lời gọi `_maybeShowOnlineAppPopup()` trong `initState`: chờ post-frame đầu tiên; thoát nếu `!mounted`; đọc `SharedPreferences`; nếu `HomeStoreGuide.shouldShow` và `_storeKey.currentContext != null` thì gọi `HomeStoreGuide.build(...).show(context: context)`, ngược lại gọi `_maybeShowOnlineAppPopup()` luôn.
  - `onClose`: `markSeen`, rồi (nếu `mounted`) `_maybeShowOnlineAppPopup()`.
  - `onTapTarget`: `markSeen`, đặt cờ trạng thái để `onClose` không mở popup trong lần này, rồi gọi `_onChangeStore()` đúng một lần.
  - Khi `currentContext == null` thì không `markSeen`.
- [ ] **Step 6: Chạy phân tích và toàn bộ test.** Run: `flutter analyze` rồi `flutter test` — Expected: không có lỗi mới, mọi test PASS.
- [ ] **Step 7: Kiểm tra thủ công trên Windows** (`flutter run -d windows`, xóa cờ bằng cách xóa dữ liệu app hoặc đổi tên key tạm thời):
  - Lần đầu: lớp phủ hiện, vùng sáng đúng logo + tên + mũi tên.
  - Bấm "Đã hiểu": đóng, mở lại Home không hiện lại.
  - Chạm vào vùng sáng: mở màn chọn Store một lần.
  - Thu nhỏ cửa sổ: bong bóng chữ không tràn.
  - Mobile (nếu có thiết bị): hướng dẫn đóng xong thì popup Online app mới hiện.
- [ ] **Step 8: Không commit.**

### Task 3: Port sang Online

**Files:**
- Modify: `D:\WorkSpace\StockandInventoryOnline\pubspec.yaml`
- Create: `D:\WorkSpace\StockandInventoryOnline\lib\presentation\pages\home\home_store_guide.dart` (cùng nội dung Task 1)
- Modify: `...\lib\presentation\pages\home\home_page.dart` (header `GestureDetector` ở khoảng dòng 206; `initState`/`build`)
- Modify: 11 file `...\assets\translations\*.json`
- Test: `...\test\home_store_guide_test.dart`, `...\test\home_store_guide_translations_test.dart`

**Interfaces:**
- Consumes: kết quả của Task 1 và Task 2 (chữ ký `HomeStoreGuide`, tên key dịch, cờ `home_store_guide_seen`).
- Produces: cùng hành vi ở Online.

- [ ] **Step 1: Chạy `/port-ui offline lib/presentation/pages/home`** (hoặc làm tay theo các bước dưới) sau khi chạy `git status` ở Online và ghi lại thay đổi chưa commit của người khác; không đụng các file đó ngoài chỗ cần.
- [ ] **Step 2: Thêm dependency** `tutorial_coach_mark: ^1.3.4`, chạy `flutter pub get`.
- [ ] **Step 3: Chép hai test của Task 1** sang `test/` của Online (cùng tên, cùng assertion) và xác nhận chúng fail. Run: `flutter test test/home_store_guide_test.dart test/home_store_guide_translations_test.dart`.
- [ ] **Step 4: Chép `home_store_guide.dart` và chuỗi dịch** (cùng giá trị 11 locale).
- [ ] **Step 5: Sửa `home_page.dart` của Online.** Gắn `_storeKey` vào `GestureDetector` của `_buildHeader`; trong `initState` gọi hướng dẫn sau frame đầu, theo cùng luật như Task 2 Step 5, nhưng `onTapTarget` gọi `_onChangeStorePressed()` và không có popup Online app để chờ. Giữ nguyên `RouteAware`, `canEdit`, `Pages.storeList`.
- [ ] **Step 6: Chạy `flutter analyze` và `flutter test`** ở Online — Expected: không lỗi mới, test PASS.
- [ ] **Step 7: Kiểm tra thủ công** theo danh sách Step 7 của Task 2 (bỏ mục popup).
- [ ] **Step 8: Cập nhật `KNOWN_DIFFERENCES.md`** (workspace) chỉ nếu phát sinh khác biệt mới và người dùng đồng ý. Không commit.
