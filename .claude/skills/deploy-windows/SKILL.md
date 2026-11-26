---
name: deploy-windows
description: Build the Windows release of StockandInventory, zip it, publish the unzipped build to a new orphan branch plus tag on GitHub, and create a GitHub Release with the zip attached. Use only when the user asks to deploy or release the Windows version.
disable-model-invocation: true
---

# Deploy the Windows version

Publishes the Windows build of this app to
`https://github.com/nhhoang1811vn/StockandInventoryOffline` (the repo behind
`Config.windowsReleaseUrl` in `lib/constant/config.dart`). `origin` of this project is GitLab and is
never touched.

For version `X.Y.Z` (read from `pubspec.yaml`, build number dropped) it produces:

| What | Value |
|---|---|
| Zip (local) | `dist/StockandInventory-X.Y.Z-windows.zip` |
| Branch (GitHub) | `windows/vX.Y.Z`, an orphan branch holding only the unzipped `Release` folder |
| Tag (GitHub) | `vX.Y.Zw`, annotated, on the orphan commit |
| GitHub Release | titled after the tag, with the zip attached |

## Prerequisites (check, do not install silently)

- Flutter on PATH and Visual Studio "Desktop development with C++" (the debug build already works here).
- `gh` CLI installed and logged in (`gh auth status`). It was **not installed** when this skill was
  written: tell the user to install it and run `gh auth login`, then continue.
- Git can push to GitHub (credential manager or token). If the push is rejected for auth, stop and
  tell the user.

## Procedure

1. **Phase 1, build and zip (local only).** From the repo root run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .claude/skills/deploy-windows/deploy-windows.ps1
   ```

   It reads the version, adds the `github` remote if missing, refuses to continue if the branch or tag
   already exists on GitHub, runs `flutter build windows --release`, checks the exe exists and that no file
   is over GitHub's 100 MB limit, and writes the zip to `dist/`. A release build takes a few minutes: run
   it with a long timeout or in the background.

2. **Confirm with the user before publishing.** Show: version, branch, tag, zip path and size, number of
   uncommitted changes (the build uses the working tree as it is), and that publishing pushes to GitHub
   and creates a public Release. Publish only after a clear yes.

3. **Phase 2, publish.** Add `-Publish` and `-SkipBuild` (reuses the build and zip just made):

   ```powershell
   powershell -ExecutionPolicy Bypass -File .claude/skills/deploy-windows/deploy-windows.ps1 -Publish -SkipBuild
   ```

   It creates the orphan branch in a temporary worktree (this working copy is not switched), commits the
   unzipped `Release` contents with `core.autocrlf=false`, tags it, pushes the branch and the tag to
   `github`, creates the Release with `gh release create --verify-tag`, then removes the worktree and the
   local branch.

4. **Report** the Release URL (`https://github.com/nhhoang1811vn/StockandInventoryOffline/releases/tag/vX.Y.Zw`)
   and what was pushed.

5. **Remind the user** that `Config.windowsReleaseUrl` still points to the previous tag. Changing it is a
   code change for the app: do it only if they ask.

## Rules

- Never force-push, never delete remote branches or tags, never overwrite an existing tag. If the tag or
  branch exists, stop and ask.
- Do not touch `origin`, and do not commit or switch branches in this working copy.
- If the build or any git/gh step fails, report the exact error; do not retry with different flags to
  get around it.
- `dist/` is git-ignored; the zip is never committed.
