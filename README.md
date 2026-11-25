# IDM Patcher GUI — v1.11.2 (portable Windows x86)

A compact Windows desktop **graphical front end** for the separately maintained [IDM-Unlock-Script](https://github.com/Th3C0D3R/IDM-Unlock-Script). It provides file selection, a preview operation, optional backup and restore, a progress/activity display, and a readable log. The GUI doesn't implement or expand the upstream script's patching logic.

**This README documents the GUI and *only GUI changes*.** The upstream backend's changes are intentionally **not listed in this README or in [`GUI_CHANGELOG.md`](GUI_CHANGELOG.md)**. The GUI's separate **API Changelog** button retrieves upstream commit information and saves it in `backend_changelog.txt` beside the EXE.

## What's on the screen

- **IDM installation / Browse:** Select an installed 32-bit `IDMan.exe`. The GUI can also try standard installation folders.
- **Create .bak backup:** Save the original file on first patch; preserve an existing backup for later restoration.
- **Overwrite original:** When checked, request the upstream `--overwrite` mode; when unchecked, request a separate `.xex` output.
- **Force-close IDM:** When selected, closes matching IDM processes before changing files. **Any active downloads can be interrupted or lost.**
- **Preview:** Use the upstream `--dry-run` mode to display matches without making changes.
- **Patch IDM:** Confirm warnings, optionally close IDM and back up the original, then run the installed upstream backend.
- **Restore Backup:** Copy the existing `.bak` file over the selected original executable.
- **Update API:** Check the upstream GitHub repository, compare the installed commit and script, offer to install a newer backend, and show a result popup.
- **API Changelog:** Display the separate upstream commit history; it is not the GUI release changelog. The last saved history is available offline if GitHub cannot be reached.
- **UI Changelog:** Open local `GUI_CHANGELOG.md`, listing only GUI updates and fixes; it does not contact GitHub.
- **GitHub:** Open the original upstream project.
- **Stop:** Ask a running task to stop at the next safe checkpoint; it might not interrupt a file write instantly.
- **Clear:** Clear the on-screen operation log. **? Buttons:** Show the full command mapping.
- **Light / Dark:** Switch IDM-inspired colours, icons, fonts and panels; Light is the default.

## Update API: what happens

1. Click **Update API**. The same **glossy, shining green activity bar** used for patching begins animating. It moves smoothly through a slow cycle, but **does not claim a percentage** because the upstream script does not expose reliable completion percentages.
2. A background worker checks the specific upstream GitHub repository, downloads files pinned to a commit and checks integrity/syntax. The UI should remain interactive and resize normally.
3. If the installed script and commit match, a **No backend update available** popup explains why. If a change is found, you can confirm or cancel installation.
4. For a successful update, the GUI updates portable `idmPatcher.py`, `UPSTREAM_README.md` and `backend_version.json`, refreshes the supported IDM version label from the installed README, and attempts to refresh `backend_changelog.txt` automatically.
5. An **Update successful** popup shows the installed revision, supported versions, and changelog refresh status. **Update failed** explains the actual error; **Update cancelled** explains why nothing was installed. A changelog-only refresh failure is reported distinctly from a successful backend installation.

An updated backend doesn't require rebuilding your GUI EXE **as long as the upstream script's expected arguments/entrypoint stay compatible**. The GUI does **not** guarantee support for any specific future IDM build; it displays what the installed upstream README documents, or **Unknown** if it can't verify a range.

**Security:** Updating downloads executable Python code from the original GitHub repository. Review and trust the source before installing it. Hash verification helps detect transfer/storage inconsistencies; it does not establish that downloaded code is safe.

## Portable files

Persistent update files are stored **beside the EXE** (or beside `gui.py` while running from source), not in AppData:

```text
IDM Patcher GUI/
  IDM_Patcher_GUI_x86.exe          # after Windows build
  README.md                        # this guide: GUI changes only
  GUI_CHANGELOG.md                 # GUI release history only
  idmPatcher.py                    # installed updated upstream backend, if updated
  UPSTREAM_README.md               # documentation for that backend revision
  backend_version.json             # verified installed revision and digests
  backend_changelog.txt            # upstream commit history, auto-refreshed on update
  _internal/                       # PyInstaller's bundled runtime for onedir builds
```

The GUI's backup of the installed program is named `IDMan.exe.bak` **next to the IDM executable**, not in the portable app folder, so that Restore Backup can find it. This is separate from the GUI's persistent data files.

The application folder must be writable for updates. If you put the portable EXE in `Program Files`, move the complete folder to a user-writable location instead. No AppData fallback is used.

## Run without building (your existing Python 3.14.6 64-bit)

1. Extract the entire source ZIP to a new writable folder.
2. Double-click **`run_with_existing_python_64bit.bat`**.
3. On the first **source-mode** run, `initialize_backend.py` automatically downloads and records a pinned, verified initial backend if none is installed. The compiled build additionally checks for a newer revision while it is being created. Internet is required for that initial source setup. You do **not** have to click **Update API** to get started.
4. Select `IDMan.exe` with Browse if auto-detection doesn't find it.

## Build a genuine Windows 32-bit (x86) EXE

1. Install a **32-bit** build of Python 3.14 (or the compatible 32-bit version the build script detects), alongside your existing 64-bit Python. You do not need to uninstall the 64-bit one.
2. Verify: `py -3.14-32 -c "import struct; print(struct.calcsize('P') * 8)"` should print `32`.
3. Double-click **`build_x86.bat`**. It checks GitHub for the latest upstream revision, verifies/downloads a backend as needed, installs PyInstaller, builds the app, and **copies the verified script, README, and revision metadata beside the EXE**. If GitHub is temporarily unreachable but an already-verified backend exists, the build will say the included revision **may not be the latest**. If IDM is installed, the script also attempts to extract its icon for the Windows title bar/taskbar. Internet access is needed for the initial build if the backend is not already present.
4. The result is `dist\IDM_Patcher_GUI_x86\IDM_Patcher_GUI_x86.exe`. **Copy the entire output folder**, including `_internal` and the three verified backend files, to a 32-bit Windows computer. The target computer needs neither Python nor an Internet connection on the first launch, and it does not require an initial **Update API** click.

Optional: `build_x64_python_314.bat` makes a **64-bit** EXE with your current Python. That EXE will not run on 32-bit Windows.

## Layout and activity behaviour

The GUI starts in a smaller window (about **1320×810 physical pixels** in simulated 1920×1080 at 150% DPI). It is freely resizable, has a draggable divider for the bottom log, and provides scrolling for the upper controls when you make the window unusually small. Patch and update work run outside Tk's main event handler so the interface and the progress-bar shine continue to animate.

The included tests use a virtual display at 100%, 125%, 150% and 200% scaling. The two preview PNGs were captured from the real Tk GUI using a virtual Linux desktop. **Windows x86 builds, live per-monitor DPI changes, and modification of IDM itself have not been verified in this environment.**

### Local offline tests (do not modify IDM)

```bash
python -B portable_update_test.py
xvfb-run -a python -B update_popup_test.py
xvfb-run -a -s '-screen 0 1920x1080x24' python -B compact_window_test.py 144
```

On Windows, use `py -3.14 -B portable_update_test.py` and `py -3.14 -B update_popup_test.py` (Tk must be available); the virtual-display test is Linux-specific.

**License and safety:** Follow the licensing conditions of IDM and the upstream source. The original repository describes its code as GPL-3.0. Only modify software you're authorized to change, and keep a backup before modifying executables.

## GUI hotfix v1.10.1: updated backend Unicode output

The upstream backend may print Unicode symbols such as a checkmark (✔) during its preview scan. On Windows, a separate Python worker previously used the active legacy console encoding (often cp1252), causing an error even when scanning succeeded. This GUI-only fix forces **UTF-8** for the child process output and explicitly configures its output streams before loading an updated backend. The GUI continues to decode child output as UTF-8. This does **not** modify the upstream backend or erase your installed portable backend metadata.

**Upgrade an existing portable installation:** Rebuild with `build_x86.bat`, then replace the old EXE and its `_internal` runtime folder in your existing portable installation. **Preserve** your `idmPatcher.py`, `UPSTREAM_README.md`, `backend_version.json`, and `backend_changelog.txt` files beside the EXE—these store your latest installed backend. Don't delete, rename or manually edit them. If you run from source instead, put the refreshed GUI source files in the same portable folder. You do **not** need to press Update Backend again to fix this encoding issue.

**Tested:** A fake backend containing Unicode output is run through the real GUI subprocess entrypoint with a deliberately legacy cp1252 console-encoding environment. It must return the symbols intact and exit cleanly. This does not constitute a test against a live IDM installation or a 32-bit Windows build.

## UI release v1.11: clearly separated histories

The toolbar now presents **Update API**, **UI Changelog**, **API Changelog** and **GitHub** as separate controls:

- **UI Changelog** opens this GUI's local `GUI_CHANGELOG.md`. It lists only design, usability, DPI, animation, portability and updater-interface changes.
- **API Changelog** reads the current/upstream backend GitHub commit history, optionally refreshing `backend_changelog.txt` in the portable folder. It is not used as the GUI's release history.
- **Update API** checks for a compatible upstream Python backend revision; if installed, the GUI refreshes supported IDM versions based on the installed upstream README, and refreshes the separate API changelog where possible.

The word **API** in these button labels means the separately updated Python backend. The upstream project is a local Python script rather than a hosted web service. The GUI remains portable, and no backend algorithm changes are included in v1.11.

## First-run packaging fix in v1.11.1

A newly built portable EXE should **not** prompt you to install a backend before you can use the GUI. Earlier build scripts initialized the backend in the *source* folder but did not copy the external backend and its verification record into the final `dist` folder. The new `stage_portable_backend.py` step copies and SHA-256-verifies all three required files beside the EXE after PyInstaller finishes, so moving the complete folder retains the initial backend.

- `idmPatcher.py` — verified Python backend downloaded during build.
- `UPSTREAM_README.md` — documentation with the supported IDM versions for that revision.
- `backend_version.json` — commit and integrity record.

**Update API remains optional:** it checks for new upstream revisions after the app is installed. If you have already updated the backend in an existing portable folder, **keep** your current three files when replacing the GUI; copying an older build's backend files over newer installed copies would downgrade them.

## UI release v1.11.2: update status and compact toolbar fixes

- Changed the 32-bit and optional 64-bit **build scripts** to check GitHub at build time, instead of silently packaging a verified but potentially older copy. The verified backend and its revision metadata are staged beside the portable EXE. If the network check fails, the builder clearly warns that its locally verified version may be older.
- Fixed the 150% DPI default window layout after adding both changelog buttons: **theme buttons share the title row**, and **Update API / UI Changelog / API Changelog / GitHub** use a compact second row. All action buttons, options, the shiny progress bar and a multiline log fit in the default window, without maximizing. Smaller windows can still scroll.
- Improved the **Update API** confirmation to distinguish a Python-code update from a documentation-only or commit-metadata change. GitHub may publish a different commit even when the Python script itself is unchanged; in that case the popup now explains the reason rather than inaccurately claiming patcher code changed.
- Added an offline build-staging test that verifies SHA-256 metadata and confirms a fresh, matching backend does **not** prompt to update immediately.

**Why Update API might offer an update on the first run:** A new upstream GitHub commit may have appeared *after* your build, or your earlier EXE may have been packaged without matching version metadata. The v1.11.2 builder fixes the metadata issue and checks GitHub at build time. It cannot guarantee that the repository won't change afterward. A documentation-only update is still a repository revision, and the UI will explain that distinction.
