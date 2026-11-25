# IDM Patcher GUI — user interface changelog

This file lists **only changes to this GUI**, not changes to the separately maintained GitHub backend. For the upstream backend's own commit history, click **API Changelog** inside the app (or open `backend_changelog.txt` after it has been refreshed).

## v1.11.2 — Build freshness and compact header

- Updated the GUI build process to check for a newer verified upstream commit before producing the portable EXE, while preserving an offline fallback with a clear warning.
- Fixed the default 150% DPI compact header after adding the two changelog buttons: both histories remain visible without forcing the upper options to scroll.
- Clarified Update API's confirmation reason for Python-code updates versus README-only/commit-metadata changes.
- Added an offline build-staging smoke test to verify the initial portable files and prevent misleading first-run update notices when the installed revision already matches upstream.
- Expanded the README with first-run, updater, DPI and EXE-building guidance. **No upstream backend patching changes are included.**

## v1.11.1 — First-run portable backend staging

- Fixed the Windows build scripts to copy the verified initial backend, supported-version README, and integrity metadata beside the generated EXE.
- Added post-build SHA-256 verification, so the EXE can launch offline without requiring an initial **Update API** operation.
- Clarified first-run setup and how to preserve existing backend updates when replacing the GUI files.

## v1.11 — Separate UI and API changelog controls

- Renamed the updater button to **Update API** to match the user-facing backend terminology (the upstream component is a local Python script, not a web API).
- Added a **UI Changelog** button that opens the local `GUI_CHANGELOG.md` without contacting GitHub.
- Renamed **Changelog** to **API Changelog**, preserving the installed revision, GitHub commit history, offline cache, and automatic refresh on backend updates.
- Reflowed the toolbar at narrower widths so the two changelog buttons are visible without text clipping at high DPI.
- Updated help text and README; did not change the patching algorithms.

## v1.10.1 — UTF-8 backend worker output fix

- Fixed a Windows `charmap` `UnicodeEncodeError` in the isolated GUI worker when the updated backend prints Unicode symbols such as ✔.
- Set UTF-8 for the launched subprocess and explicitly configured child stdout/stderr before running the upstream script.
- Preserved the GUI layout, progress bar, updater, portable files and original backend unchanged.

## v1.10 — Responsive update progress and documentation

- Added a **slowly moving green activity fill** and an independent moving glossy shine while checking/installing backend updates.
- Displayed text describing each update stage while the interface remains responsive.
- Automatically refresh the separate upstream changelog after a successful update; show its refresh status in the result popup.
- Corrected first-run scripts to establish a verified portable backend record rather than downloading a script without matching metadata.
- Expanded `README.md` to document each GUI control, operation flow, portable files and Windows x86 build instructions.

## v1.9 — Updater result messages

- Added **success**, **no update**, **failure**, and **cancelled** popups after pressing Update.
- Included installed revision, supported version text or an actionable explanation of failure/no-change.

## v1.8 — Portable GUI settings and updater files

- Kept all persistent updater files next to the application rather than in AppData.
- Added a write-permission check and portable-folder guidance.

## v1.7 — GUI updater controls

- Added **Update** and **Changelog** buttons beside GitHub without redesigning the compact layout.
- Added a dynamically refreshed supported-version display based on the installed upstream README.

## v1.6 — Smoother actions

- Moved long-running backend operations to a separate process so the GUI can continue responding to window resizing.
- Kept the log and progress animation on the Tk event loop, with bounded per-frame log processing.

## v1.5 — Compact windowed layout

- Smaller default window with actions, progress area and log visible together at simulated 150% scaling.
- Freely resizable main window and independently adjustable log panel.

## v1.4 — DPI and maximized layout

- Reworked DPI-aware spacing and control sizing for 100%, 125%, 150% and 200% simulated scaling.
- Added scrolling where required to prevent options or buttons from being cut off.

## v1.3 — IDM-inspired visual refresh

- Added Light (default) and Dark themes, blue Windows-style controls, a glossy green progress bar and IDM-inspired typography.
- Improved icon handling and the styling of the installation panel and operation log.
