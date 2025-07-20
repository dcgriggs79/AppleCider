
─────────────────────────────────────────────────────────────

🍎 APPLECIDER v1.1
macOS Forensic & Session Hygiene Script (Sequoia 15.5+)

─────────────────────────────────────────────────────────────

SUMMARY
-------
AppleCider is a forensic hygiene and UI trace removal script for macOS Sequoia (15.5+) and later. It performs a deep wipe of session history, cached metadata, visual traces, spotlight indexing, browser artifacts, system logs, and more—all while retaining user files. It is designed for personal privacy protection and forensic awareness, not data destruction.

AUTHORSHIP
----------
Developed by: Chris Griggs

DISCLAIMER
----------
⚠️ USE AT YOUR OWN RISK. This script modifies system-level files and settings.
You are responsible for any unintended data loss or side effects.

AppleCider does NOT touch your Keychain or SIP-protected areas. It does NOT
bypass macOS security models or remove certain artifacts (like persistent
clipboard history on macOS 26+) that are currently inaccessible to scripts.
Your password is required once at the beginning to grant administrative
permission for protected operations (e.g., system log removal, APFS snapshots).

HOW TO USE
----------
1. Place `AppleCider_v1.1.command` on your Desktop (or any convenient location).
2. Double-click the file. macOS will *not* open it the first time.
3. Go to:
   System Settings > Privacy & Security > Security > [Click "Allow" next to AppleCider_v1.1.command]
4. After that, open the Terminal and run:

   chmod +x ~/Desktop/AppleCider_v1.1.command
   ~/Desktop/AppleCider_v1.1.command

5. The script will launch in Terminal and prompt you to enter your macOS password.
6. If you're running macOS 26 or later, you'll be shown a warning about new artifacts that AppleCider cannot yet remove. You must acknowledge it before the script continues.
7. Let the script finish. It takes ~30–90 seconds depending on system size.

REQUIREMENTS
------------
- macOS Sequoia 15.5 or later (built/tested on 15.5+)
- Terminal must have Full Disk Access (grant when prompted)
- Optional apps supported: Safari, Chrome, Firefox, QuickTime, VeraCrypt (VeraCrypt dismount only)

WHAT IT CLEANS
--------------
✔️ Safari session, history, cache, closed tabs
✔️ Chrome history and cache (if installed)
✔️ Firefox history and cache (if installed)
✔️ QuickTime recent files view
✔️ Recent files lists from other native macOS apps (e.g., Pages, Keynote, Numbers, TextEdit, Preview)
✔️ UI preferences, thumbnails, cache, and metadata
✔️ **⚠️ IMPORTANT: Deletes user DOWNLOADS from the DOWNLOADS folder ⚠️**
✔️ Quick Look preview cache
✔️ Clipboard contents (basic wipe)
✔️ Trash folders
✔️ Spotlight search artifacts
✔️ QuarantineEvents DB
✔️ Unified system logs
✔️ KnowledgeC.db and related app usage traces
✔️ Extended file metadata (xattr)
✔️ Traditional log files in /var/log
✔️ App container logs
✔️ APFS local Time Machine snapshots
✔️ DNS cache
✔️ Shell history (.bash_history, .zsh_history)
✔️ Secure free space overwrite (optional, auto-sized)

WHAT IT DOES *NOT* CLEAN
------------------------
❌ Keychain entries (to avoid corruption)
❌ SIP-protected system files
❌ Persistent clipboard history (won't be relevant until macOS 26+ release)
❌ Biome database (Apple Intelligence)
❌ Notes transcripts, Safari Highlights, iPhone mirroring artifacts

CUSTOMIZING APPLECIDER
----------------------
AppleCider v1.1 targets the most common forensic residuals for modern macOS. However, your setup may vary. You can use ChatGPT (https://chat.openai.com) or Gemini (https://gemini.google.com) to quickly customize the script to add or remove functionality.

To manually edit AppleCider:

1. Right-click `AppleCider_v1.1.command` and select **Open With > TextEdit**.
2. Make changes (add your own cleanup paths, tools, apps).
3. Save the file.
4. If necessary, re-make executable with:

   chmod +x ~/Desktop/AppleCider_v1.1.command

IMPORTANT NOTES
---------------
• The `sleepimage` RAM snapshot file is removed, but FileVault remains untouched.
• The final overwrite step safely fills free disk space with junk and deletes it.

VERSION
-------
AppleCider v1.1
Release Date: July 2025
macOS Target: Sequoia 15.5+

LICENSE
-------
This script is provided "as-is" with no warranty. You may modify and redistribute it freely for personal or educational use. Do not sell this script without permission from the author.

MIT License

Copyright (c) 2025 Chris Griggs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
─────────────────────────────────────────────────────────────
```
