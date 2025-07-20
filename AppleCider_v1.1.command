#!/bin/zsh

# ─────────────────────────────────────────────────────────────
# AppleCider v1.1 – Forensic + Session Hygiene Script for macOS Sequoia 15.5+
# Author: Chris Griggs
# Includes full forensic cleanup, GUI reset, and warnings for macOS 26+
# License: MIT
# ─────────────────────────────────────────────────────────────

setopt +o nomatch

# Step 0: Initialization
clear
OS_VERSION=$(sw_vers -productVersion | awk -F '.' '{print $1}')
echo "\n📘 AppleCider v1.1 – Forensic Session Hygiene for macOS Sequoia"
echo "────────────────────────────────────────────────────────────────────"
echo "Author: Chris Griggs"
echo "License: MIT"
echo ""
echo "This tool performs a forensic cleanup of common user- and system-level"
echo "residual artifacts on macOS 15.5+ (Sequoia), including:"
echo "• Safari, Chrome, Firefox (Common browser types) session/histories"
echo "• QuickTime recent files view"
echo "• Recent files lists from other native macOS apps (e.g. Pages, etc.)"
echo "• UI preferences, thumbnails, cache, and metadata"
echo "• ⚠️  IMPORTANT: Deletes user DOWNLOADS from the DOWNLOADS folder ⚠️"
echo "• KnowledgeC, Spotlight, Trash, Clipboard, Logs, and DNS traces"
echo "• Secure overwrite of free disk space"
echo ""
echo "⚠️ IMPORTANT LIMITATIONS (read carefully):"
echo "• AppleCider does NOT modify your Keychain or FileVault settings."
echo "• AppleCider does NOT disable SIP or bypass security enforcement."
echo "• On macOS 26 (Tahoe)+, Apple has introduced NEW forensic artifacts:"
echo "   - Persistent clipboard history (indexed by Spotlight)"
echo "   - Biome DB (replacing knowledgeC.db)"
echo "   - Notes app transcripts, Safari Highlights, and iPhone Mirroring traces"
echo "• These are not script-accessible and remain after AppleCider runs."
echo ""
echo "💡 To customize or extend this script:"
echo "• Open AppleCider_v1.1.command in TextEdit or your preferred editor"
echo "• Use ChatGPT or another assistant to add code for your specific apps"
echo "• For example, adding support for Brave browser, Arc, or proprietary tools"
echo ""
echo "✅ You only need to approve permissions the first time the tool runs."
echo "────────────────────────────────────────────────────────────────────"
read "?Press ENTER to begin secure wipe. You will be prompted to enter your password ... "
clear

# macOS 26+ warning for persistent clipboard and emerging forensic residuals
if [[ "$OS_VERSION" -ge 26 ]]; then
  echo ""
  echo "🚨 macOS 26 (Tahoe) or newer detected"
  echo "❌ Apple has introduced NEW FORENSIC ARTIFACTS AppleCider cannot yet remove:"
  echo "📌 Persistent Clipboard History (Spotlight-indexed)"
  echo "📉 Biome DB replacing knowledgeC.db"
  echo "🔊 Notes app audio transcript logs"
  echo "📢 Safari Highlights + Apple Intelligence traces"
  echo "📱 iPhone Mirroring artifacts"
  echo "⚠️ These items are not yet script-accessible. Future AppleCider builds will address them."
  echo ""
  read "?Press ENTER to acknowledge this warning and proceed... "
fi

# Cache sudo and keep alive throughout
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Step 1: Overwrite Safari session with benign tabs
echo "🌐 Step 1: Rewriting Safari session with clean tabs..."
osascript -e 'quit app "Safari"' 2>/dev/null
killall Safari 2>/dev/null
sleep 2
osascript <<EOF
tell application "Safari"
    activate
    delay 1
    set newTab to make new document with properties {URL:"https://www.google.com"}
    delay 1
    set URL of (make new tab at end of window 1) to "https://www.reuters.com"
    delay 1
    set URL of (make new tab at end of window 1) to "https://www.linkedin.com"
    delay 2
end tell
EOF
osascript -e 'quit app "Safari"' 2>/dev/null
sleep 2
echo "✅ Safari session overwritten with benign tabs."

# Step 2: Full Safari wipe
echo "🧹 Step 2: Wiping Safari files..."
rm -f ~/Library/Safari/History.db*
rm -f ~/Library/Safari/LastSession.plist
rm -f ~/Library/Safari/LastWindow.plist
rm -f ~/Library/Safari/AutosavedSession.plist
rm -f ~/Library/Safari/BrowserState.db
rm -f ~/Library/Safari/Downloads.plist
rm -f ~/Library/Safari/RecentlyClosed*.plist
rm -rf ~/Library/Safari/LocalStorage
rm -rf ~/Library/Safari/Databases
rm -rf ~/Library/Safari/SuspendedTabs
rm -rf ~/Library/Safari/Favicon\ Cache
rm -rf ~/Library/Caches/com.apple.Safari
rm -rf ~/Library/WebKit/com.apple.Safari
rm -f ~/Library/Cookies/Cookies.binarycookies
rm -f ~/Library/Containers/com.apple.Safari/Data/Library/Safari/*.db*
rm -rf ~/Library/Containers/com.apple.Safari/Data/Library/Safari/*Session*
rm -rf ~/Library/Containers/com.apple.Safari/Data/Library/Caches/com.apple.Safari
rm -rf ~/Library/Containers/com.apple.Safari/Data/Library/WebKit
rm -rf ~/Library/Containers/com.apple.Safari/Data/Library/Cookies
rm -rf ~/Library/Containers/com.apple.Safari/Data/Library/Saved\ Application\ State/com.apple.Safari.savedState
find ~/Library/Group\ Containers -type f -name "*Safari*" -exec rm -f {} \;
rm -rf ~/Library/Caches/metadata/Safari
echo "✅ Safari history and session data wiped."

# Step 3: Chrome forensic wipe
echo "🧹 Step 3: Wiping Chrome session and history (safe)..."
osascript -e 'quit app "Google Chrome"' 2>/dev/null
killall "Google Chrome" 2>/dev/null
sleep 2
CHROME_PATH=~/Library/Application\ Support/Google/Chrome/Default
if [ -d "$CHROME_PATH" ]; then
  rm -f "$CHROME_PATH"/History*
  rm -f "$CHROME_PATH"/Last\ Session
  rm -f "$CHROME_PATH"/Last\ Tabs
  rm -rf "$CHROME_PATH"/Sessions
  rm -rf "$CHROME_PATH"/Cache
  rm -f "$CHROME_PATH"/Top\ Sites
  rm -rf ~/Library/Caches/Google/Chrome
  echo "✅ Chrome history and cache cleaned."
else
  echo "⚠️ Chrome not found. Skipping Step 3."
fi

# Step 4: Firefox forensic wipe
echo "🧹 Step 4: Wiping Firefox session and history..."
osascript -e 'quit app "Firefox"' 2>/dev/null
killall "Firefox" 2>/dev/null
sleep 2
FIREFOX_PATH=~/Library/Application\ Support/Firefox/Profiles
if [ -d "$FIREFOX_PATH" ]; then
    find "$FIREFOX_PATH" -maxdepth 2 -type f -name "places.sqlite*" -exec rm -f {} \;
    find "$FIREFOX_PATH" -maxdepth 2 -type f -name "sessionstore.jsonlz4*" -exec rm -f {} \;
    find "$FIREFOX_PATH" -maxdepth 2 -type f -name "webappsstore.sqlite*" -exec rm -f {} \;
    find "$FIREFOX_PATH" -maxdepth 2 -type d -name "cache2" -exec rm -rf {} \;
    rm -rf ~/Library/Caches/Firefox
    echo "✅ Firefox history and cache cleaned."
else
    echo "⚠️ Firefox not found. Skipping Step 4."
fi

# Step 5: QuickTime
echo "🎞 Step 5: Clearing QuickTime recent files..."
defaults delete com.apple.QuickTimePlayerX.LSSharedFileList RecentDocuments 2>/dev/null
rm -f ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.QuickTimeRecentDocuments.sfl2
rm -f ~/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Preferences/com.apple.QuickTimePlayerX.LSSharedFileList.plist
echo "✅ QuickTime recent file history cleared."

# Step 6: Deleting Downloads
echo "📁 Step 6: Deleting Downloads..."
rm -rf ~/Downloads/*
echo "✅ Downloads traces removed."

# Step 7: Quick Look cache
echo "🖼 Step 7: Purging Quick Look thumbnail cache..."
qlmanage -r cache
rm -rf ~/Library/Containers/com.apple.QuickLook.thumbnailcache
echo "✅ Quick Look thumbnails purged."

# Step 8: UI Preferences
echo "🧾 Step 8: Clearing UI plist preferences..."
defaults delete -g NSRecentDocuments 2>/dev/null
rm -f ~/Library/Preferences/com.apple.sidebarlists.plist
rm -f ~/Library/Preferences/com.apple.recentitems.plist
rm -f ~/Library/Preferences/ByHost/com.apple.notificationcenterui.*.plist
defaults delete com.apple.dock recents 2>/dev/null
killall Dock
echo "✅ Recents, sidebar, and Dock state cleared."
# ────────────────────────────────────────────────────────────────────
# Step 9: Clear native macOS app recent files lists via menu action
# (Attempts to open app, clear "Open Recent" submenu, then quit app)
# ────────────────────────────────────────────────────────────────────
echo "📝 Step 9: Clearing native macOS app recent file lists (via menu action)..."

# Helper function to clear recent documents via the app's menu
clear_app_recents_via_menu() {
    local app_name="$1"        # e.g., "Pages" (for open -a and quit app)
    local app_process_name="$2" # e.g., "Pages" (for pgrep, killall, and tell process)

    echo "   Processing $app_name..."

    # 1. Ensure the app is quit before starting to avoid conflicts
    if pgrep -x "$app_process_name" > /dev/null; then
        echo "   Quitting $app_name to ensure proper state..."
        osascript -e "quit app \"$app_name\"" 2>/dev/null
        killall "$app_process_name" 2>/dev/null # Ensure it's fully gone
        sleep 1 # Give app time to quit
    fi

    # 2. Open the app to make its menus accessible
    echo "   Opening $app_name to clear recent files via menu..."
    open -a "$app_name" 2>/dev/null
    sleep 2 # Give the app time to fully launch and draw its UI

    # 3. Execute AppleScript to clear the recent menu
    osascript <<EOF
tell application "System Events"
    # Ensure the target application is frontmost for UI interaction
    set frontmost of process "$app_process_name" to true
    delay 1 # Small delay to ensure frontmost status

    # Properly navigate to "Clear Menu" inside the submenu of "Open Recent"
    try
        # Check if the "Clear Menu" item exists and is enabled before attempting to click
        if exists menu item "Clear Menu" of menu 1 of menu item "Open Recent" of menu "File" of menu bar 1 of process "$app_process_name" then
            click menu item "Clear Menu" of menu 1 of menu item "Open Recent" of menu "File" of menu bar 1 of process "$app_process_name"
            delay 0.5 # Small delay for action to register
        else
            log "AppleScript: 'Clear Menu' not found or not enabled for $app_name."
        end if
    on error errMsg
        log "AppleScript error clearing recents for $app_name: " & errMsg
        # This error can occur if the menu path is fundamentally wrong or permissions issues.
    end try
end tell
EOF

    # 4. Quit the app after clearing recents
    echo "   Quitting $app_name after clearing recents..."
    osascript -e "quit app \"$app_name\"" 2>/dev/null
    killall "$app_process_name" 2>/dev/null
    sleep 1 # Give app time to quit

    echo "   Recent documents for $app_name cleared (via menu action)."
}

# Call the helper function for each desired native app
clear_app_recents_via_menu "TextEdit" "TextEdit"
clear_app_recents_via_menu "Preview" "Preview"
clear_app_recents_via_menu "Pages" "Pages"
clear_app_recents_via_menu "Keynote" "Keynote"
clear_app_recents_via_menu "Numbers" "Numbers"

# Note: Safari's recent documents are handled comprehensively in Step 2.
# Note: Finder's 'recents' are often controlled by the Dock/Sidebar (Step 8) or specific Finder settings,
#       and do not typically have a "Clear Menu" option in the same way.
# Note: QuickTimePlayerX's recent documents are handled in Step 5 using direct file deletion.

echo "✅ Native macOS app recent file lists cleanup attempted via menu action."


# Step 10: Clipboard
echo "📋 Step 10: Clearing clipboard contents..."
pbcopy < /dev/null
killall pboard 2>/dev/null
echo "✅ Clipboard wiped."

# Step 11: Trash
echo "🗑 Step 11: Emptying Trash folders..."
rm -rf ~/.Trash/*
rm -rf /Volumes/*/.Trashes 2>/dev/null
echo "✅ Trash emptied."

# Step 12: Spotlight
echo "🔍 Step 12: Removing Spotlight search artifacts..."
defaults delete com.apple.Spotlight "Recent Searches" 2>/dev/null
echo "✅ Spotlight search artifacts removed."

# Step 13: Quarantine DB
echo "🚫 Step 13: Removing QuarantineEvents DB..."
rm -f ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
echo "✅ QuarantineEventsV2 removed."

# Step 14: Unified logs
echo "🪵 Step 14: Wiping Unified System Logs..."
sudo log erase --all
echo "✅ System logs erased."

# Step 15: KnowledgeC
echo "🧠 Step 15: Purging KnowledgeC app usage data..."
rm -rf ~/Library/Application\ Support/Knowledge/*
sudo rm -rf /private/var/db/CoreDuet/Knowledge/*
echo "✅ KnowledgeC logs cleared."

# Step 16: Sleepimage removal
echo "🛏️ Step 16: Removing sleepimage RAM snapshot..."
sudo rm /private/var/vm/sleepimage 2>/dev/null
echo "✅ sleepimage deleted."

# Step 17: Extended attributes
echo "📎 Step 17: Removing extended file metadata..."
xattr -rc ~/Downloads ~/Desktop ~/Documents 2>/dev/null
echo "✅ Extended attributes cleared."

# Step 18: System logs
echo "🪵 Step 18: Deleting traditional system logs..."
sudo rm -f /var/log/*.log /var/log/asl/*.asl 2>/dev/null
echo "✅ System logs purged."

# Step 19: App logs
echo "🧾 Step 19: Deleting user and container app logs..."
rm -rf ~/Library/Logs/* 2>/dev/null
find ~/Library/Containers -type d -name Logs -exec rm -rf {} \; 2>/dev/null
echo "✅ App logs cleared."

# Keychain warning
echo "🔐 REMINDER: Your Keychain is currently UNLOCKED."
echo "⚠️ AppleCider does not delete Keychain entries to avoid corruption."
echo "💡 For maximum privacy, use FileVault and shut down between sessions."

# Step 20: APFS Snapshots
echo "📸 Step 20: Deleting APFS local snapshots..."
for snap in $(tmutil listlocalsnapshots / | awk -F. '{print $4}'); do
  sudo tmutil deletelocalsnapshots "$snap"
done
echo "✅ Snapshots deleted."

# Step 21: DNS cache
echo "🌐 Step 21: Flushing DNS cache..."
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
echo "✅ DNS cache flushed."

# Step 22: Shell History
echo "📜 Step 22: Removing shell command history..."
unset HISTFILE
rm -f ~/.zsh_history ~/.bash_history ~/.zsh_history.lock ~/.bash_history.lock 2>/dev/null
history -p
echo "✅ Shell history wiped."

# Step 23: Secure free space wipe
echo "💾 Step 23: Overwriting free disk space..."
BUFFER_BYTES=$((2 * 1024 * 1024 * 1024))
AVAILABLE_BYTES=$(df -k ~ | awk 'NR==2 {print $4 * 1024}')
MAX_WRITE_BYTES=$((AVAILABLE_BYTES - BUFFER_BYTES))
if [ "$MAX_WRITE_BYTES" -le 0 ]; then
  echo "⚠️ Not enough free space to safely overwrite. Skipping wipe."
else
  echo "Writing to ~/bigfile — this will continue until disk space is exhausted or forcibly stopped..."
  ( while :; do sleep 2; du -sh ~/bigfile 2>/dev/null; done ) &
  BIGFILE_MONITOR_PID=$!
  cat /dev/zero > ~/bigfile
  kill $BIGFILE_MONITOR_PID
  sync
  rm -f ~/bigfile
  sync
  echo "✅ Free space overwrite complete."
fi

# Final message
echo "\n🎉 AppleCider v1.1 completed successfully. Forensic and UI traces removed."
osascript -e 'tell application "Terminal" to close (every window whose name contains "AppleCider")' & exit