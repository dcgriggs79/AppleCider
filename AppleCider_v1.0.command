#!/bin/zsh

# ─────────────────────────────────────────────────────────────
# AppleCider v1.0 – Forensic + Session Hygiene Script for macOS Sequoia 15.5+
# Author: Chris Griggs
# Includes full forensic cleanup, GUI reset, and warnings for macOS 26+
# License: MIT
# ─────────────────────────────────────────────────────────────

setopt +o nomatch

# Step 0: Initialization
clear
OS_VERSION=$(sw_vers -productVersion | awk -F '.' '{print $1}')
echo "\n📘 AppleCider v1.0 – Forensic Session Hygiene for macOS Sequoia"
echo "────────────────────────────────────────────────────────────────────"
echo "Author: Chris Griggs"
echo "License: MIT"
echo ""
echo "This tool performs a forensic cleanup of common user- and system-level"
echo "residual artifacts on macOS 15.5+ (Sequoia), including:"
echo "• Safari and Chrome session/histories"
echo "• QuickTime & VLC recent files"
echo "• UI preferences, thumbnails, cache, and metadata"
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
echo "• Open AppleCider_v1.0.command in TextEdit or your preferred editor"
echo "• Use ChatGPT or another assistant to add code for your specific apps"
echo "• For example, adding support for Brave browser, Arc, or proprietary tools"
echo ""
echo "✅ You only need to approve permissions the first time the tool runs."
echo "────────────────────────────────────────────────────────────────────"
read "?Press ENTER to begin secure wipe... "
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

# Step 1: VeraCrypt dismount (harmless if unused)
echo "🔐 Step 1: Dismounting VeraCrypt and clearing recent volumes..."
/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt -d -f 2>/dev/null
osascript -e 'quit app "VeraCrypt"' 2>/dev/null
sleep 2
defaults delete org.idrix.VeraCrypt History 2>/dev/null
defaults delete org.idrix.VeraCrypt FavoriteVolumes 2>/dev/null
echo "✅ VeraCrypt dismounted and cleaned."

# Step 2: Overwrite Safari session with benign tabs
echo "🌐 Step 2: Rewriting Safari session with clean tabs..."
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

# Step 3: Full Safari wipe
echo "🧹 Step 3: Wiping Safari files..."
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

# Step 4: Chrome forensic wipe
echo "🧹 Step 4: Wiping Chrome session and history (safe)..."
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
  echo "⚠️ Chrome not found. Skipping Step 4."
fi

# Step 5: QuickTime and VLC
echo "🎞 Step 5: Clearing QuickTime and VLC recent files..."
defaults delete com.apple.QuickTimePlayerX.LSSharedFileList RecentDocuments 2>/dev/null
rm -f ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.QuickTimeRecentDocuments.sfl2
rm -f ~/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Preferences/com.apple.QuickTimePlayerX.LSSharedFileList.plist
open -a VLC 2>/dev/null
sleep 2
osascript <<EOF
tell application "System Events"
    tell process "VLC"
        set frontmost to true
        delay 1
        try
            click menu item "Clear Menu" of menu "Open Recent" of menu bar item "File" of menu bar 1
        end try
    end tell
end tell
EOF
osascript -e 'quit app "VLC"' 2>/dev/null
killall VLC 2>/dev/null
echo "✅ QuickTime and VLC recent file history cleared."

# Step 6: Downloads, Desktop images/videos/screenshots
echo "📁 Step 6: Deleting Downloads, Desktop files, Screenshots..."
rm -rf ~/Downloads/*
find ~/Desktop -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.heic" \) -exec rm {} \;
find ~/Desktop -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.webm" \) -exec rm {} \;
find ~/Desktop ~/Pictures -type f -name "Screen Shot*" -delete
echo "✅ Visual Desktop and Downloads traces removed."

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

# Step 9: Clipboard
echo "📋 Step 9: Clearing clipboard contents..."
pbcopy < /dev/null
killall pboard 2>/dev/null
echo "✅ Clipboard wiped."

# Step 10: Trash
echo "🗑 Step 10: Emptying Trash folders..."
rm -rf ~/.Trash/*
rm -rf /Volumes/*/.Trashes 2>/dev/null
echo "✅ Trash emptied."

# Step 11: Spotlight
echo "🔍 Step 11: Refreshing Spotlight metadata..."
sudo mdutil -i on / > /dev/null 2>&1
sudo mdutil -E / > /dev/null 2>&1
defaults delete com.apple.Spotlight "Recent Searches" 2>/dev/null
echo "✅ Spotlight reindexing initiated."

# Step 12: Quarantine DB
echo "🚫 Step 12: Removing QuarantineEvents DB..."
rm -f ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
echo "✅ QuarantineEventsV2 removed."

# Step 13: Unified logs
echo "🪵 Step 13: Wiping Unified System Logs..."
sudo log erase --all
echo "✅ System logs erased."

# Step 14: KnowledgeC
echo "🧠 Step 14: Purging KnowledgeC app usage data..."
rm -rf ~/Library/Application\ Support/Knowledge/*
sudo rm -rf /private/var/db/CoreDuet/Knowledge/*
echo "✅ KnowledgeC logs cleared."

# Step 14.5: Sleepimage removal
echo "🛏️ Step 14.5: Removing sleepimage RAM snapshot..."
sudo rm /private/var/vm/sleepimage 2>/dev/null
echo "✅ sleepimage deleted."

# Step 14.6: Extended attributes
echo "📎 Step 14.6: Removing extended file metadata..."
xattr -rc ~/Downloads ~/Desktop ~/Documents 2>/dev/null
echo "✅ Extended attributes cleared."

# Step 14.7: System logs
echo "🪵 Step 14.7: Deleting traditional system logs..."
sudo rm -f /var/log/*.log /var/log/asl/*.asl 2>/dev/null
echo "✅ System logs purged."

# Step 14.8: App logs
echo "🧾 Step 14.8: Deleting user and container app logs..."
rm -rf ~/Library/Logs/* 2>/dev/null
find ~/Library/Containers -type d -name Logs -exec rm -rf {} \; 2>/dev/null
echo "✅ App logs cleared."

# Keychain warning
echo "🔐 REMINDER: Your Keychain is currently UNLOCKED."
echo "⚠️ AppleCider does not delete Keychain entries to avoid corruption."
echo "💡 For maximum privacy, use FileVault and shut down between sessions."

# Step 15: APFS Snapshots
echo "📸 Step 15: Deleting APFS local snapshots..."
for snap in $(tmutil listlocalsnapshots / | awk -F. '{print $4}'); do
  sudo tmutil deletelocalsnapshots "$snap"
done
echo "✅ Snapshots deleted."

# Step 16: DNS cache
echo "🌐 Step 16: Flushing DNS cache..."
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
echo "✅ DNS cache flushed."

# Step 17: Shell History
echo "📜 Step 17: Removing shell command history..."
unset HISTFILE
rm -f ~/.zsh_history ~/.bash_history ~/.zsh_history.lock ~/.bash_history.lock 2>/dev/null
history -p
echo "✅ Shell history wiped."

# Step 18: Secure free space wipe
echo "💾 Step 18: Overwriting free disk space..."
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
echo "\n🎉 AppleCider v1.0 completed successfully. Forensic and UI traces removed."
osascript -e 'tell application "Terminal" to close (every window whose name contains "AppleCider")' & exit
