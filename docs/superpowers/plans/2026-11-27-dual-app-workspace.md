# Dual-app workspace Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** Một workspace cho phép sửa UI một lần rồi port sang app còn lại bằng skill `/port-ui`.

**Architecture:** Thư mục workspace nằm ngoài hai repo, chỉ chứa tài liệu và skill (không code
Flutter). Skill đọc diff ở app nguồn, áp dụng sang app đích, đối chiếu bảng khác biệt đã biết.

**Tech Stack:** Markdown, JSON (`.code-workspace`), Claude Code skills, git, `flutter analyze`.

**Spec:** `docs/superpowers/specs/2026-11-27-dual-app-workspace-design.md`

## Global Constraints

- Offline: `D:\WorkSpace\StockandInventoryOffline`. Online: `D:\WorkSpace\StockandInventoryOnline`.
  Workspace: `D:\WorkSpace\StockandInventoryWorkspace`.
- Không tự commit/push trong code của hai app. Skill không được commit.
- Không đụng data layer (`repo/`, `data/`, `domain/`) khi port UI.
- Không thêm dependency. Không sửa file generated (`*.freezed.dart`, `*.g.dart`, `di.config.dart`).
- Offline: user-visible string phải thêm vào cả 11 locale trong `assets/translations/` (AGENTS.md).
- Online không có AGENTS.md/CONTEXT.md (chỉ README.md); đã kiểm tra.
- Chỉ đổi cấu hình git toàn cục khi người dùng đã đồng ý (đã đồng ý cho `safe.directory`).

## Review Focus

- Port sang app đích khi file tương ứng không tồn tại (26 file chỉ có ở Online): skill báo "không có
  file tương ứng", không tự tạo.
- Diff nguồn chứa thay đổi logic/cubit lẫn với UI: skill chỉ port phần UI và liệt kê phần bỏ qua.
- Thay đổi chạm mục trong KNOWN_DIFFERENCES (ví dụ `canEdit`): giữ nguyên biến thể của app đích.
- String mới ở đích Offline: phải có đủ 11 locale, nếu thiếu thì báo.
- Cả hai repo đang có thay đổi chưa commit: skill nói rõ lấy diff nào, không trộn.

---

### Task 1: Dựng workspace và cho phép git đọc repo Online

**Files:**

- Create: `D:\WorkSpace\StockandInventoryWorkspace\StockandInventory.code-workspace`
- Create: `D:\WorkSpace\StockandInventoryWorkspace\CLAUDE.md`

**Interfaces:**

- Produces: đường dẫn workspace và cách mở session (`claude --add-dir ...`) mà Task 2 và 3 tham
  chiếu.

- [ ] **Step 1: Chạy
  `git config --global --add safe.directory D:/WorkSpace/StockandInventoryOnline`**

- [ ] **Step 2: Kiểm tra** `git -C D:\WorkSpace\StockandInventoryOnline status --short` chạy được,
  không còn "dubious ownership".

- [ ] **Step 3: Tạo `StockandInventory.code-workspace`** với hai `folders` (tên hiển thị "Offline",
  "Online") trỏ tới hai repo.

- [ ] **Step 4: Tạo `CLAUDE.md`** gồm: đường dẫn hai repo; lệnh mở session
  `claude --add-dir D:\WorkSpace\StockandInventoryOffline --add-dir D:\WorkSpace\StockandInventoryOnline`;
  quy tắc: đọc `AGENTS.md`+`CONTEXT.md` của Offline và `README.md` của Online trước khi sửa; không
  commit; không đụng data layer khi port UI; link tới `KNOWN_DIFFERENCES.md` và skill `/port-ui`.

- [ ] **Step 5: Kiểm tra** file JSON hợp lệ: `Get-Content ...code-workspace -Raw | ConvertFrom-Json`
  không lỗi và có 2 folder.

### Task 2: Bảng khác biệt đã biết

**Files:**

- Create: `D:\WorkSpace\StockandInventoryWorkspace\KNOWN_DIFFERENCES.md`

**Interfaces:**

- Consumes: kết quả so sánh home trong spec (mục "Thiết kế đã chốt").
- Produces: bảng 3 cột `Khía cạnh | Online | Offline` mà skill đọc và bổ sung (Task 3).

- [ ] **Step 1: Tạo bảng** với các dòng đã xác minh: quyền
  (`AppSettings.getSelectedStoreRole().canEdit` / luôn cho sửa); route (`Pages.savePayment` /
  `Pages.save_payment`); khoảng cách (`EdgeInsetsDirectional.fromSTEB(16,…)`, số cứng /
  `EdgeInsets.fromLTRB(12,…)`, `Dimens.cardGap`, `Dimens.cardRadius`); `HomePage` (`RouteAware` +
  `onOpenMenuPage` / `initState` + `RevenueCatService` + `_maybeShowOnlineAppPopup`); widget chỉ có
  ở Offline (`home_online_app_promo`, `home_store_header`, `home_windows_banner`); widget chỉ có ở
  Online (`wallet_card.dart`, 26 file trong `presentation/pages`). Mỗi dòng ghi file chứng minh.

- [ ] **Step 2: Kiểm tra từng dòng** bằng `Grep` tên symbol trong repo tương ứng; dòng nào không tìm
  thấy thì sửa hoặc xoá.

### Task 3: Skill `/port-ui`

**Files:**

- Create: `D:\WorkSpace\StockandInventoryWorkspace\.claude\skills\port-ui\SKILL.md`

**Interfaces:**

- Consumes: `KNOWN_DIFFERENCES.md` (Task 2), quy tắc trong `CLAUDE.md` (Task 1).
- Produces: lệnh `/port-ui <offline|online> <file hoặc trang>` (đối số đầu là app nguồn).

- [ ] **Step 1: Viết SKILL.md** (frontmatter `name: port-ui`, description tiếng Anh nêu khi nào
  dùng) với các bước cố định:
    1. Xác định app nguồn từ đối số; nếu thiếu thì hỏi.
    2. Lấy diff nguồn: `git diff` chưa commit của file/thư mục đó; nếu rỗng, hỏi commit nào. Không
       trộn diff của hai repo.
    3. Tìm file tương ứng ở đích cùng đường dẫn `lib/...`; không có thì báo và dừng cho file đó.
    4. Tách thay đổi UI khỏi logic/cubit/repo; chỉ port UI.
    5. Áp dụng vào đích, giữ các mục trong `KNOWN_DIFFERENCES.md` theo biến thể của đích.
    6. Nếu đích là Offline và có string mới: thêm vào cả 11 file trong `assets/translations/`.
    7. Chạy `flutter analyze` ở đích; báo kết quả.
    8. Báo cáo: đã port, bỏ qua và lý do, khác biệt mới phát hiện (thêm vào bảng sau khi người dùng
       đồng ý).
    9. Không commit, không push.

- [ ] **Step 2: Kiểm tra cú pháp** frontmatter đúng (`name`, `description`), file nằm đúng đường
  dẫn.

### Task 4: Cập nhật ADR 0001 và kiểm thử thực tế

**Files:**

- Modify: `D:\WorkSpace\StockandInventoryOffline\docs\adr\0001-online-repo-as-visual-source.md`
- Modify: `D:\WorkSpace\StockandInventoryOffline\CONTEXT.md` (thêm một dòng trỏ tới workspace, trong
  mục References)

**Interfaces:**

- Consumes: workspace và skill đã tạo (Task 1-3).

- [ ] **Step 1: Sửa ADR 0001**: thay câu "The online repo stays read-only" bằng việc Online được sửa
  khi port UI qua workspace (`D:\WorkSpace\StockandInventoryWorkspace`), hai app vẫn release độc
  lập, không có package chung. Không đổi phần còn lại.

- [ ] **Step 2: Thêm một dòng vào `CONTEXT.md` → References** trỏ tới workspace và skill `/port-ui`.

- [ ] **Step 3: Chạy thử**: mở session với `--add-dir` hai repo từ thư mục workspace, chạy
  `/port-ui offline lib/presentation/pages/home/home_wallets_section.dart` trên một thay đổi nhỏ (ví
  dụ đổi `_cardGap`) rồi xác nhận: skill tìm đúng file Online, giữ `canEdit`, chạy `flutter analyze`
  ở Online. Hoàn tác thay đổi thử.

- [ ] **Step 4: Báo cáo** những gì đã chạy và chưa kiểm chứng được (ví dụ nếu `flutter analyze` ở
  Online lỗi sẵn từ trước).
