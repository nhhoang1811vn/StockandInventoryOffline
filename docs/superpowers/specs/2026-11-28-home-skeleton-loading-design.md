# Home skeleton loading (Offline + Online)

## Intent
Home shows the real numbers as 0 and a spinner while `HomeCubit.initState()` runs, because it emits
once at the end. Replace that with skeleton placeholders on every block that has no data yet, so
users never see fake zeros. Same change in both apps.

## Goals
- Skeleton for: stats row (out of stock, low stock, total items), documents card counts,
  suppliers/customers cards, recent documents, wallets section.
- Skeleton has the same size as the real block, so the layout does not jump when data arrives.
- Cards that open lists (out of stock, low stock, ...) are not tappable while skeleton shows.

## Non-goals / anti-goals
- No new package (AGENTS.md: ask before adding dependencies). Own pulsing widget.
- No cubit restructuring, no partial emits, no change in `repo/`, `data/`, `domain/`.
- Header, search row and "add document/payment" shortcuts stay as they are (they need no data).

## Approaches
1. One loading flag for the whole page, skeletons sized like the real blocks. **Chosen.**
2. Split `initState()` into several emits so each block appears on its own. Rejected: changes cubit
   behaviour, differs between Offline (SQLite) and Online (Firebase), more than a UI change.

## Design
- New `home_skeleton.dart` in `pages/home/` of each app: `HomeSkeletonBox` (pulsing bone, honors
  theme light/dark) plus block variants (stat card, row card, wallet section).
- `HomeState`: keep `isLoadingRecentDocuments` and `isLoadingWallets` (both flip together today).
  Decision for the builder: reuse `isLoadingWallets` as the page-level flag, or add one
  `isLoading` field (needs freezed codegen). Prefer reuse to avoid codegen.
- `home_page.dart`: when loading, stats row / documents card / partners cards render their skeleton
  variant; otherwise unchanged.
- Online keeps its own constants (`16`, `_cardGap = 12`), and its uncommitted edits in
  `home_page.dart` must not be overwritten; edit only the needed lines.

## Verification
`flutter analyze` on both apps; run each app once and watch the skeleton-to-data transition.
Not verified yet: draft `home_skeleton.dart` already written in both apps (3 generic rows) is
replaced by the block variants above.
