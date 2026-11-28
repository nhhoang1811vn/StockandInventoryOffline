# Home Skeleton Loading Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Home spinners and the fake "0" numbers shown while loading with skeleton placeholders of the same size as the real blocks, in Offline and Online.

**Architecture:** One file `home_skeleton.dart` per app holds a pulsing bone primitive and one skeleton widget per Home block. `HomeSkeletonBone` copies the text line height of the real text by laying out an invisible `Text`, so skeleton and real card have the same height. Pages and `HomeWalletsSection` show a skeleton while the matching loading flag in `HomeState` is true.

**Tech Stack:** Flutter, flutter_bloc, freezed, flutter_test. No new packages.

**Spec:** `docs/superpowers/specs/2026-11-28-home-skeleton-loading-design.md` (Offline repo)

## Global Constraints

- No new dependency (AGENTS.md of Offline: ask before adding one).
- Do not touch `repo/`, `data/`, `domain/`. No cubit restructuring, no partial-emit changes.
- Do not commit or push (workspace CLAUDE.md). Leave a reviewable diff in each repo.
- Do not hand-edit `*.freezed.dart`; run `dart run build_runner build --delete-conflicting-outputs` after changing `HomeState`.
- Offline uses `Dimens.cardGap` / `Dimens.cardRadius`; Online uses literal `12` / `16` (KNOWN_DIFFERENCES.md). Keep each app's variant.
- Online `home_page.dart` has uncommitted edits by someone else: edit only the lines named here, never rewrite the file. Run `git status` and `git diff` on it before and after.
- Header, search row and "add document/payment" shortcuts stay unchanged.

## Review Focus

1. Dark theme: bones must stay visible on the card colour (alpha based on `onSurface`, not a fixed grey).
2. Return to Home (Offline calls `initState()` again): skeleton must NOT reappear, because flags stay false after first load.
3. Skeleton must use the same decisions as the real block that are known synchronously: `AppSettings.isMinQuantityEnabled()` decides 2 or 3 stat cards; `showPriceFor(...)` decides whether document rows have an amount bone. Otherwise the layout jumps.
4. Narrow width (320) and text scale 2.0: no overflow.
5. System "reduce motion" (`MediaQuery.disableAnimations`): bones stay static, no endless animation in tests (`pumpAndSettle` must finish).
6. Online: a stream that emits nothing keeps its skeleton; empty collections emit `[]`, which must flip the flag.

---

### Task 1: Skeleton widgets (Offline)

**Files:**
- Modify (replace the earlier 3-row draft): `lib/presentation/pages/home/home_skeleton.dart`
- Test: `test/home_skeleton_test.dart`

**Interfaces:**
- Produces, all in `home_skeleton.dart`, all `const`-constructible, none take data:
  - `HomeSkeletonBone({double? width, double? height, TextStyle? textStyle, double radius = 6})` — a rounded box in the pulse colour. When `textStyle` is given, its height is the line height of that style (invisible `Opacity(0)` `Text('0', style: textStyle)` inside), `height` is ignored.
  - `HomeSkeleton({required Widget child})` — wraps a subtree: owns the one `AnimationController` (1100 ms, reverse repeat), exposes the pulse colour to descendant bones through an `InheritedWidget`, wraps content in `ExcludeSemantics`, stops the controller when `MediaQuery.disableAnimationsOf(context)` is true.
  - `HomeStatCardSkeleton()` mirrors `_buildStatCard`: padding 12, icon box 38x38 radius 12, 8 gap, value line (`titleMedium`), 2 gap, label line (12 px).
  - `HomeStatsRowSkeleton()` — `Row` of `HomeStatCardSkeleton`s separated by the card gap; 3 cards if `AppSettings.isMinQuantityEnabled()` else 2.
  - `HomeDocumentsCardSkeleton()` mirrors `_buildDocumentsEntry`: header row (icon box, title bone, count bone) and two summary rows; the amount bone is present only when `AppSettings.getGoodPropertiesSettings().showPriceFor(type)` is true for that row's `DocumentType`.
  - `HomePartnersCardsSkeleton()` — the two-card row of `_buildQuickActionCard` (icon box, 12 gap, one `titleSmall` line).
  - `HomeRowCardsSkeleton({int rows = 3})` — row cards for recent documents/payments: icon box 38, title line (`titleMedium`), subtitle line (12 px), trailing bone.
  - `HomeWalletsSkeleton()` — total-balance row card, then a wallet face card bone of height 156 and radius 22 (values from `_buildWalletList`), then 3 `HomeRowCardsSkeleton` rows.
- Rule for every card skeleton: same background (`theme.cardTheme.color ?? theme.colorScheme.surface`), same radius, same padding as the real card.

- [ ] **Step 1: Write the failing tests** in `test/home_skeleton_test.dart` (read `test/home_store_header_test.dart` first for how this repo wraps widgets that need `AppSettings`/localization):
  - `bone pulses`: pump `HomeSkeleton(child: HomeSkeletonBone(width: 40, height: 10))`, read the bone's colour, `pump(Duration(milliseconds: 550))`, colour differs.
  - `bone with textStyle is as tall as that text`: `HomeSkeletonBone(textStyle: ts)` height equals the height of `Text('0', style: ts)` laid out in the same tree (compare `tester.getSize`).
  - `no animation when reduce motion is on`: wrap in `MediaQuery(data: MediaQueryData(disableAnimations: true))`, `pumpAndSettle()` completes and colour does not change over time.
  - `skeleton is excluded from semantics`: `find.byType(ExcludeSemantics)` finds one under `HomeSkeleton`.
  - `each block skeleton builds in light and dark at width 320 and textScale 2.0 without overflow`: loop over the six block skeletons × both brightness values, `expect(tester.takeException(), isNull)`.
  - `stats row shows 2 cards when low stock is off, 3 when on` (set the `AppSettings` flag the way other tests do, e.g. `good_properties_settings_test.dart`).
- [ ] **Step 2:** Run `flutter test test/home_skeleton_test.dart`. Expected: FAIL (names not defined).
- [ ] **Step 3:** Implement the widgets above in `home_skeleton.dart`, deleting the old draft classes. Pulse colour: `onSurface.withValues(alpha: 0.06 + 0.06 * Curves.easeInOut.transform(t))`.
- [ ] **Step 4:** Run `flutter test test/home_skeleton_test.dart`. Expected: all PASS.

### Task 2: Wire Offline Home

**Files:**
- Modify: `lib/presentation/pages/home/home_page.dart` (builder around the `Column` at ~L197, `_buildStatsRow`, `_buildDocumentsEntry`, `_buildPartnersSection`, recent-documents block at ~L210)
- Modify: `lib/presentation/pages/home/home_wallets_section.dart` (the `isLoading` branch at ~L55)
- Test: `test/home_wallets_section_loading_test.dart`

**Interfaces:**
- Consumes: Task 1 widgets. Existing `HomeState.isLoadingRecentDocuments` and `isLoadingWallets`.
- Flag mapping (Offline emits once, so both flags flip together): stats row, documents card, partners cards and recent documents use `state.isLoadingRecentDocuments`; wallets section keeps `isLoading: state.isLoadingWallets`.

- [ ] **Step 1: Write the failing test** `HomeWalletsSection(isLoading: true, ...)` shows `HomeWalletsSkeleton`, finds no `CircularProgressIndicator` and no "total_balance" text; with `isLoading: false` it shows no `HomeSkeleton`.
- [ ] **Step 2:** Run `flutter test test/home_wallets_section_loading_test.dart`. Expected: FAIL.
- [ ] **Step 3:** In `home_wallets_section.dart` return `const HomeWalletsSkeleton()` in the loading branch (keep the section title above it). In `home_page.dart`: while `isLoadingRecentDocuments`, `_buildStatsRow` returns `HomeStatsRowSkeleton`, `_buildDocumentsEntry` returns `HomeDocumentsCardSkeleton`, `_buildPartnersSection` keeps its title and replaces the `Row` with `HomePartnersCardsSkeleton`, and the recent-documents loader becomes `HomeRowCardsSkeleton()`. Keep the section titles visible. Skeleton replaces the card, so out-of-stock/low-stock/total-items cards are not tappable while loading.
- [ ] **Step 4:** `flutter test`, then `flutter analyze`. Expected: no new failures or warnings.
- [ ] **Step 5:** Run the Offline app (use the `run` skill), open Home, confirm skeleton to data transition does not shift layout, then open a page and go back: no skeleton flash. Report what was and was not verified.

### Task 3: Online loading flags

**Files:**
- Modify: `lib/presentation/pages/home/bloc/home_state.dart` (+ regenerate freezed)
- Modify: `lib/presentation/pages/home/bloc/home_cubit.dart` (`init()` ~L141, goods listener ~L151, suppliers ~L239, customers ~L245)
- Test: `test/home_cubit_loading_flags_test.dart`

**Why this task exists:** the approved design said to reuse `isLoadingWallets`. That is true for Offline, which emits once. Online's streams arrive independently (goods, documents, wallets, suppliers, customers), so a single reused flag would clear skeletons before their data arrives. Raised with the user in the plan handoff.

**Interfaces:**
- Produces: `HomeState` fields `@Default(true) bool isLoadingGoods` and `@Default(true) bool isLoadingPartners`. `isLoadingRecentDocuments` already flips when the documents stream emits, so it also drives the documents card.
- `isLoadingGoods` becomes false in the goods listener's `emit`. `isLoadingPartners` becomes false once both the suppliers and the customers stream have emitted at least once (private `_suppliersLoaded`, `_customersLoaded`, same pattern as `_walletsLoaded`; reset in `init()`). `init()` sets both flags to true in its first `emit`.

- [ ] **Step 1: Write the failing test** with fake repositories (use the fakes pattern of existing Online cubit tests, or `StreamController`s): after `init()`, `isLoadingGoods` and `isLoadingPartners` are true; goods emit `[]` → `isLoadingGoods` false while `isLoadingPartners` still true; suppliers emit `[]` → still true; customers emit `[]` → false.
- [ ] **Step 2:** Run it. Expected: FAIL (fields not defined).
- [ ] **Step 3:** Add the fields, run `dart run build_runner build --delete-conflicting-outputs`, add the flag changes in `init()` and the listeners. Change nothing else in the cubit.
- [ ] **Step 4:** Run the test. Expected: PASS.

### Task 4: Port skeleton to Online

**Files:**
- Create: `lib/presentation/pages/home/home_skeleton.dart` (copy of the Offline file; replace `Dimens.cardGap` with `12`, `Dimens.cardRadius` with `16`, wallet face radius stays `22`)
- Modify: `lib/presentation/pages/home/home_page.dart` (named places only), `lib/presentation/pages/home/home_wallets_section.dart`
- Test: copy `test/home_skeleton_test.dart` and `test/home_wallets_section_loading_test.dart`, adjusted to Online's `HomeWalletsSection` constructor and imports

**Interfaces:**
- Consumes: Task 1 widgets, Task 3 flags. Follow `KNOWN_DIFFERENCES.md` (keep `canEdit` logic, `Pages.savePayment`, no role removal).
- Flag mapping: stats row → `isLoadingGoods`; documents card and recent documents → `isLoadingRecentDocuments`; partners cards → `isLoadingPartners`; wallets → `isLoadingWallets`.

- [ ] **Step 1:** `git status` and `git diff lib/presentation/pages/home/home_page.dart` in Online; note the other person's edits.
- [ ] **Step 2:** Copy and adjust the two tests, run them. Expected: FAIL (widgets missing in Online).
- [ ] **Step 3:** Create the skeleton file; wire `home_page.dart` (`_buildSectionLoading` at ~L738 becomes `const HomeRowCardsSkeleton()`, plus stats/documents/partners as in Task 2) and `home_wallets_section.dart`.
- [ ] **Step 4:** `flutter test` (the new tests), `flutter analyze`, and `git diff` to confirm only the intended lines changed in `home_page.dart` and the other person's edits are intact.
- [ ] **Step 5:** Run the Online app, check the skeleton-to-data transition per block. Report what was and was not verified. Update `KNOWN_DIFFERENCES.md` only after the user agrees (new row: Online has per-block loading flags `isLoadingGoods`, `isLoadingPartners`).
