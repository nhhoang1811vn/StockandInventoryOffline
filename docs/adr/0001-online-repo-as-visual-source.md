# Online repo as visual source

This app copies and adapts presentation from StockAndInventoryOnline instead of extracting a shared
UI package. Files here will diverge as we strip RoleGuard, stock-taking, and collaboration chrome.
UI changes may be edited in either repo and ported to the other with the `/port-ui` skill in
`D:\WorkSpace\StockandInventoryWorkspace` (2026-11-27); the Online repo is no longer treated as
read-only, but nothing is shared at build time. A shared package would couple two products that must
ship
independently.
