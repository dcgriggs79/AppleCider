
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

### Method 1: GUI Double-Click (Recommended for beginners)
1. Place `AppleCider_v1.1.command` on your Desktop (or any convenient location).
2. Double-click the file. macOS will *not* open it the first time.
3. Go to:
   System Settings > Privacy & Security > Security > [Click "Allow" next to AppleCider_v1.1.command]
4. Double-click the file again to run it.

### Method 2: Terminal (Direct execution)
1. Open Terminal (Applications > Utilities > Terminal or press Cmd+Space and type "Terminal").
2. Navigate to where you placed the script:
   ```bash
   cd ~/Desktop
   ```
   (or wherever you placed the AppleCider_v1.1.command file)

3. Make the script executable:
   ```bash
   chmod +x AppleCider_v1.1.command
   ```

4. Run the script:
   ```bash
   ./AppleCider_v1.1.command
   ```

5. **Optional**: If you get a "cannot be opened because it is from an unidentified developer" error, remove the quarantine attribute:
   ```bash
   xattr -d com.apple.quarantine AppleCider_v1.1.command
   ```

### After Starting (Both Methods)
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

SUGGESTED IMPROVEMENTS
----------------------
The following enhancements could be added to make AppleCider more robust and user-friendly:

### 🔧 Core Functionality Improvements
• **Dry Run Mode**: Add `--dry-run` flag to preview what would be deleted without executing
• **Selective Cleanup**: Interactive menu to choose specific operations (browsers only, logs only, etc.)
• **Better Error Handling**: Detailed logging of successful/failed operations instead of silent failures
• **Progress Indicators**: Show real-time progress during lengthy operations
• **Backup Creation**: Automatically backup critical preference files before deletion

### 🛡️ Safety & Recovery Features
• **Pre-flight Checks**: Verify sufficient disk space and warn about running applications
• **Verification Mode**: Post-cleanup verification to confirm files were actually removed
• **Smart Free Space Wiping**: User-configurable size limits for disk overwrite operations
• **Configuration File Support**: Allow users to create `~/.applecider_config` for custom settings
• **Summary Reports**: Generate detailed cleanup reports with statistics

### 📱 Enhanced macOS Support
• **Extended Attributes Cleanup**: Target specific forensic attributes like:
  ```bash
  xattr -d com.apple.quarantine <file>
  xattr -d com.apple.metadata:kMDItemDownloadedDate <file>
  xattr -d com.apple.metadata:kMDItemWhereFroms <file>
  ```
• **Modern Browser Support**: Add cleanup for Arc, Brave, Edge, Opera browsers
• **Apple Intelligence Traces**: Future-proof cleanup for Biome database (macOS 26+)
• **Enhanced Memory Cleanup**: Clear swap files and force memory purge with `sudo purge`

### 🔍 Advanced Forensic Features
• **Network Traces**: Clear WiFi logs, DNS caches, and multicast DNS records
• **App-Specific Cleanup**: Dedicated functions for Adobe, Microsoft Office, development tools
• **Container Isolation**: Better handling of sandboxed app data in `~/Library/Containers/`
• **Metadata Removal**: More thorough extended attributes and resource fork cleanup

### 💻 Developer Experience
• **Modular Structure**: Break script into functions for easier maintenance
• **Command Line Arguments**: Support for flags like `--verbose`, `--skip-downloads`, `--browsers-only`
• **Exit Codes**: Proper exit codes for automation and error handling
• **Logging Levels**: Configurable verbosity (silent, normal, verbose, debug)

### Example Implementation Snippets:
```bash
# Dry run mode
if [[ "$1" == "--dry-run" ]]; then
    echo "🔍 DRY RUN MODE - Showing what would be deleted:"
    DRY_RUN=true
fi

# Selective cleanup
echo "Select cleanup operations:"
echo "[1] Browser data only"
echo "[2] System logs and caches"
echo "[3] Downloads folder"
echo "[4] All operations"

# Better error handling
if [ -f ~/Library/Safari/History.db ]; then
    rm -f ~/Library/Safari/History.db* && echo "✅ Safari history removed" || echo "⚠️ Failed to remove Safari history"
fi

# Enhanced extended attributes cleanup
FORENSIC_ATTRS=("com.apple.quarantine" "com.apple.metadata:kMDItemDownloadedDate" "com.apple.metadata:kMDItemWhereFroms")
for attr in "${FORENSIC_ATTRS[@]}"; do
    find ~/Downloads ~/Desktop ~/Documents -type f -exec xattr -d "$attr" {} \; 2>/dev/null
done
```

These improvements would enhance AppleCider's safety, functionality, and user experience while maintaining its core forensic cleanup capabilities.

### 🖥️ User Interface & Usability
• **GUI Version**: Native macOS app with SwiftUI interface for non-technical users
• **Interactive Terminal UI**: ncurses-based menu system with arrow key navigation
• **Undo Capability**: Create restore points before cleanup operations
• **Scheduling Support**: Built-in cron/launchd integration for automatic periodic cleanup
• **Multi-User Support**: Option to clean specific user accounts or all users (with admin privileges)
• **Quick Actions**: Predefined profiles like "Quick Clean", "Deep Clean", "Privacy Focus"

### 🔐 Security & Privacy Enhancements
• **Secure Deletion**: Integration with native macOS secure erase APIs
• **Memory Forensics**: Clear hibernation files, swap, and virtual memory artifacts:
  ```bash
  sudo rm -f /var/vm/swapfile*
  sudo rm -f /private/var/vm/sleepimage
  sudo nvram -d boot-args  # Clear verbose boot arguments
  ```
• **Touch ID/Face ID Integration**: Authenticate cleanup operations biometrically
• **Encrypted Reports**: Generate AES-256 encrypted cleanup logs
• **Privacy Mode**: Disable all logging during script execution
• **Stealth Mode**: Run without terminal output or system notifications

### ⚡ Performance Optimizations
• **Parallel Processing**: Use GNU parallel or xargs for concurrent file operations
• **Smart Caching**: Skip already-cleaned directories based on timestamps
• **Incremental Mode**: Clean only files modified since last run
• **Resource Limits**: CPU and I/O throttling to prevent system slowdown
• **Batch Operations**: Group similar cleanups to reduce filesystem overhead

### 🔗 Integration & Compatibility
• **Homebrew Formula**: Easy installation via `brew install applecider`
• **Docker Container**: Isolated execution environment for testing
• **CI/CD Integration**: GitHub Actions workflow for automated testing
• **API Mode**: RESTful interface for integration with other tools
• **Plugin System**: Extensible architecture for custom cleanup modules
• **Cloud Sync Awareness**: Detect and handle iCloud, Dropbox, OneDrive files

### 📊 Analytics & Monitoring
• **Disk Space Recovery**: Real-time tracking of freed space
• **Operation Metrics**: Time taken, files processed, errors encountered
• **Before/After Snapshots**: Visual comparison of system state
• **Health Checks**: Verify system integrity post-cleanup
• **Audit Trail**: Cryptographically signed logs for compliance

### 🛠️ Advanced Implementation Examples:

#### GUI Quick Action Implementation:
```bash
# Create quick action profiles
create_profile() {
    case "$1" in
        "quick")
            OPERATIONS=("browser_history" "recent_files" "trash")
            ;;
        "deep")
            OPERATIONS=("all")
            ;;
        "privacy")
            OPERATIONS=("browser_*" "logs" "metadata" "clipboard")
            ;;
    esac
}

# Interactive menu with dialog
show_menu() {
    CHOICE=$(dialog --menu "AppleCider v1.1" 15 50 5 \
        1 "Quick Clean (5 min)" \
        2 "Deep Clean (15 min)" \
        3 "Privacy Focus" \
        4 "Custom Selection" \
        5 "Exit" 2>&1 >/dev/tty)
}
```

#### Parallel Processing Example:
```bash
# Use GNU parallel for concurrent operations
export -f clean_extended_attrs
find ~/Downloads ~/Desktop ~/Documents -type f -print0 | \
    parallel -0 -j4 clean_extended_attrs {}

# Batch remove with xargs
find ~/Library/Caches -name "*.cache" -print0 | \
    xargs -0 -P 8 -n 100 rm -f
```

#### Memory Forensics Enhancement:
```bash
# Comprehensive memory cleanup
clean_memory_artifacts() {
    # Force memory purge
    sudo purge
    
    # Clear swap files
    sudo rm -f /private/var/vm/swapfile*
    
    # Reset virtual memory statistics
    sudo rm -f /var/db/vm-swap/*
    
    # Clear diagnostic reports
    sudo rm -rf /Library/Logs/DiagnosticReports/*
    sudo rm -rf ~/Library/Logs/DiagnosticReports/*
    
    # Clear crash reporter
    sudo rm -rf /Library/Logs/CrashReporter/*
    sudo rm -rf ~/Library/Logs/CrashReporter/*
}
```

#### Smart Caching System:
```bash
# Track cleanup state
CACHE_FILE="$HOME/.applecider_cache"

update_cache() {
    echo "$(date +%s):$1:cleaned" >> "$CACHE_FILE"
}

should_clean() {
    local path="$1"
    local last_clean=$(grep "$path" "$CACHE_FILE" | tail -1 | cut -d: -f1)
    local last_modified=$(stat -f %m "$path" 2>/dev/null || echo 0)
    
    [[ -z "$last_clean" || "$last_modified" -gt "$last_clean" ]]
}
```

#### Plugin System Architecture:
```bash
# Plugin directory structure
PLUGIN_DIR="$HOME/.applecider/plugins"

# Load plugins dynamically
load_plugins() {
    for plugin in "$PLUGIN_DIR"/*.plugin; do
        [[ -f "$plugin" ]] && source "$plugin"
    done
}

# Example plugin: slack_cleanup.plugin
plugin_info() {
    echo "name: Slack Cleanup"
    echo "version: 1.0"
    echo "description: Removes Slack cache and logs"
}

plugin_execute() {
    rm -rf ~/Library/Application\ Support/Slack/Cache/*
    rm -rf ~/Library/Application\ Support/Slack/logs/*
    rm -rf ~/Library/Caches/com.tinyspeck.slackmacgap/*
}
```

#### Automated Testing Framework:
```bash
# Unit test for cleanup functions
test_browser_cleanup() {
    # Create test artifacts
    mkdir -p /tmp/test_safari
    touch /tmp/test_safari/History.db
    
    # Run cleanup
    SAFARI_PATH="/tmp/test_safari" clean_safari
    
    # Verify cleanup
    [[ ! -f /tmp/test_safari/History.db ]] || return 1
    echo "✅ Safari cleanup test passed"
}

# Integration test suite
run_tests() {
    local tests=(
        "test_browser_cleanup"
        "test_log_cleanup"
        "test_metadata_removal"
    )
    
    for test in "${tests[@]}"; do
        $test || echo "❌ $test failed"
    done
}
```

#### Cloud Sync Detection:
```bash
# Detect cloud storage providers
detect_cloud_storage() {
    local providers=()
    
    # iCloud
    [[ -d ~/Library/Mobile\ Documents ]] && providers+=("iCloud")
    
    # Dropbox
    [[ -d ~/Dropbox ]] && providers+=("Dropbox")
    
    # OneDrive
    [[ -d ~/OneDrive ]] && providers+=("OneDrive")
    
    # Google Drive
    [[ -d ~/Google\ Drive ]] && providers+=("Google Drive")
    
    echo "Detected cloud providers: ${providers[*]}"
}

# Handle cloud-synced files carefully
clean_with_cloud_awareness() {
    local file="$1"
    
    # Check if file is in cloud storage
    if [[ "$file" =~ (Dropbox|iCloud|OneDrive|Google) ]]; then
        echo "⚠️  Skipping cloud-synced file: $file"
        return
    fi
    
    # Proceed with normal cleanup
    rm -f "$file"
}
```

#### Homebrew Formula Template:
```ruby
class Applecider < Formula
  desc "macOS forensic hygiene and UI trace removal script"
  homepage "https://github.com/yourusername/applecider"
  url "https://github.com/yourusername/applecider/archive/v1.1.tar.gz"
  sha256 "YOUR_SHA256_HERE"
  license "MIT"

  def install
    bin.install "AppleCider_v1.1.command" => "applecider"
    
    # Install man page
    man1.install "applecider.1"
    
    # Install completion scripts
    bash_completion.install "completions/applecider.bash"
    zsh_completion.install "completions/_applecider"
  end

  def caveats
    <<~EOS
      AppleCider requires Full Disk Access for Terminal.
      Grant access in System Settings > Privacy & Security > Full Disk Access
    EOS
  end

  test do
    assert_match "AppleCider v1.1", shell_output("#{bin}/applecider --version")
  end
end
```

#### API Mode Implementation:
```bash
# Start API server (requires socat)
start_api_server() {
    local port="${1:-8080}"
    
    while true; do
        echo "AppleCider API listening on port $port"
        
        # Handle HTTP requests
        socat TCP-LISTEN:$port,fork EXEC:"./applecider_api_handler.sh"
    done
}

# API handler script
handle_api_request() {
    read -r method path version
    
    case "$path" in
        "/api/clean/quick")
            run_quick_clean
            echo "HTTP/1.1 200 OK"
            echo "Content-Type: application/json"
            echo ""
            echo '{"status": "completed", "freed_space": "1.2GB"}'
            ;;
        "/api/status")
            echo "HTTP/1.1 200 OK"
            echo "Content-Type: application/json"
            echo ""
            echo '{"version": "1.1", "ready": true}'
            ;;
        *)
            echo "HTTP/1.1 404 Not Found"
            ;;
    esac
}
```

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
