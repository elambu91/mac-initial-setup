#!/bin/bash

# macOS Initial Setup Script
# This script configures various macOS settings for a new MacBook

set -e  # Exit on any error

echo "🚀 Starting macOS Initial Setup..."
echo "=================================="

# Step 1: Switch language toggle and spotlight search keyboard shortcuts
echo "📱 Step 1: Configuring keyboard shortcuts..."
echo "   - Setting language toggle to CMD+Space"
echo "   - Setting spotlight search to CTRL+Space"

# Disable the default spotlight shortcut (CMD+Space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'

# Set spotlight to CTRL+Space (keycode 49 with control modifier 262144)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'

# Set input source switching to CMD+Space (keycode 49 with command modifier 1048576)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'

echo "   ✅ Keyboard shortcuts configured"

# Step 2: Add CMD+L keyboard shortcut for Lock Screen
echo "🔒 Step 2: Adding CMD+L shortcut for Lock Screen..."

# Create the lock screen shortcut (CMD+L)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 10 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>108</integer><integer>37</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'

echo "   ✅ CMD+L lock screen shortcut added"

# Step 3: Configure Dock settings
echo "🏠 Step 3: Configuring Dock settings..."
echo "   - Enabling dock autohide"
echo "   - Setting dock autohide delay to 0"
echo "   - Setting dock autohide animation time to 0.4 seconds"
echo "   - Disabling genie minimize animation (using scale effect)"
echo "   - Hiding recent apps in dock"
echo "   - Setting dock size to 25%"
echo "   - Setting dock magnification to 75%"
echo "   - Restarting Dock"

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -float 45
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -float 100
killall Dock

echo "   ✅ Dock settings configured and restarted"

# Step 4: Configure trackpad settings
echo "🖱️  Step 4: Configuring trackpad settings..."
echo "   - Enabling tap to click"

# Enable tap to click for the current user
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "   ✅ Trackpad tap to click enabled"

# Step 5: Configure Finder settings
echo "📁 Step 5: Configuring Finder settings..."
echo "   - Enabling file extensions in Finder"
echo "   - Creating ~/projects folder if it doesn't exist"

# Show file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Create projects folder if it doesn't exist
PROJECTS_DIR="$HOME/projects"
if [ ! -d "$PROJECTS_DIR" ]; then
    mkdir -p "$PROJECTS_DIR"
    echo "   - Created ~/projects folder"
else
    echo "   - ~/projects folder already exists"
fi

# Restart Finder to apply file extension changes
killall Finder

echo "   ✅ Finder settings configured and restarted"

# Step 6: Install Homebrew and optional software
echo "🍺 Step 6: Installing Homebrew and optional software..."

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    echo "   - Homebrew is already installed"
else
    echo "   - Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo "   - Adding Homebrew to PATH for Apple Silicon Mac..."
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "   - Adding Homebrew to PATH for Intel Mac..."
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

echo "   ✅ Homebrew installation complete"

# Function to prompt user with default yes - single keystroke
prompt_install() {
    local package_name="$1"
    local install_command="$2"
    
    echo -n "   Install $package_name? [Y/n]: "
    
    # Read single character without pressing enter
    read -n 1 -r response
    echo  # Move to next line after keystroke
    
    # Default to yes if empty response (just enter) or if 'y' or 'Y' pressed
    if [[ -z "$response" || "$response" =~ ^[Yy]$ ]]; then
        echo "   - Installing $package_name..."
        eval "$install_command"
        echo "   ✅ $package_name installed"
    else
        echo "   ⏭️  Skipping $package_name"
    fi
}

echo ""
echo "📦 Optional Software Installation:"
echo "   (Press Enter for default [Y]es, or press 'n' for no)"

# Xcode Command Line Tools
prompt_install "Xcode Command Line Tools" "xcode-select --install"

# iTerm2
prompt_install "iTerm2" "brew install --cask iterm2"

# AWS CLI and related tools
prompt_install "AWS CLI, SAML2AWS, and wget" "brew install awscli saml2aws wget"

# Visual Studio Code
prompt_install "Visual Studio Code" "brew install --cask visual-studio-code"

# Git
prompt_install "Git" "brew install git"

# Google Chrome
prompt_install "Google Chrome" "brew install --cask google-chrome"

# Notion
prompt_install "Notion" "brew install --cask notion"

# NVM (Node Version Manager)
prompt_install "NVM (Node Version Manager)" "brew install nvm"

# Python essentials (pyenv, pipx, poetry)
echo -n "   Install Python essentials (pyenv, pipx, poetry)? [Y/n]: "
read -n 1 -r python_response
echo  # Move to next line after keystroke

# Default to yes if empty response
if [[ -z "$python_response" || "$python_response" =~ ^[Yy]$ ]]; then
    echo "   - Installing pyenv..."
    brew install pyenv
    echo "   - Installing pipx..."
    brew install pipx
    echo "   - Installing poetry via pipx..."
    pipx install poetry
    echo "   ✅ Python essentials installed"
else
    echo "   ⏭️  Skipping Python essentials"
fi

echo ""
echo "   ✅ Optional software installation complete"

# Step 7: Configure Git settings
echo ""
echo "⚙️  Step 7: Configuring Git settings..."
echo -n "   Configure Git settings (.gitconfig)? [Y/n]: "
read -n 1 -r git_response
echo  # Move to next line after keystroke

# Default to yes if empty response
if [[ -z "$git_response" || "$git_response" =~ ^[Yy]$ ]]; then
    # Check for local .gitconfig first, then fallback to GitHub repo
    LOCAL_GITCONFIG="$(dirname "$0")/.gitconfig"
    GITHUB_GITCONFIG_URL="https://raw.githubusercontent.com/elambu91/mac-initial-setup/main/.gitconfig"
    TEMP_GITCONFIG="/tmp/.gitconfig_temp"
    
    echo ""
    echo "   Choose .gitconfig source:"
    echo "   [1] Use default .gitconfig (recommended)"
    echo "   [2] Provide custom .gitconfig URL"
    echo -n "   Choice [1]: "
    read -r config_choice
    
    # Default to choice 1 if empty
    if [[ -z "$config_choice" ]]; then
        config_choice="1"
    fi
    
    if [[ "$config_choice" == "2" ]]; then
        echo -n "   Enter .gitconfig URL: "
        read -r custom_url
        if [[ -n "$custom_url" ]]; then
            GITCONFIG_SOURCE="$custom_url"
            echo "   - Using custom .gitconfig from: $custom_url"
        else
            echo "   - No URL provided, using default"
            GITCONFIG_SOURCE="default"
        fi
    else
        GITCONFIG_SOURCE="default"
    fi
    
    # Download or copy the gitconfig
    if [[ "$GITCONFIG_SOURCE" == "default" ]]; then
        if [[ -f "$LOCAL_GITCONFIG" ]]; then
            echo "   - Found local .gitconfig, using it"
            cp "$LOCAL_GITCONFIG" "$TEMP_GITCONFIG"
        else
            echo "   - Downloading default .gitconfig from GitHub..."
            if curl -L "$GITHUB_GITCONFIG_URL" -o "$TEMP_GITCONFIG"; then
                echo "   - Downloaded successfully"
            else
                echo "   ⚠️  Failed to download .gitconfig from GitHub"
                echo "   ⏭️  Skipping Git configuration"
                TEMP_GITCONFIG=""
            fi
        fi
    else
        echo "   - Downloading .gitconfig from custom URL..."
        if curl -L "$GITCONFIG_SOURCE" -o "$TEMP_GITCONFIG"; then
            echo "   - Downloaded successfully"
        else
            echo "   ⚠️  Failed to download .gitconfig from custom URL"
            echo "   ⏭️  Skipping Git configuration"
            TEMP_GITCONFIG=""
        fi
    fi
    
    # Configure git settings if we have a valid gitconfig
    if [[ -n "$TEMP_GITCONFIG" && -f "$TEMP_GITCONFIG" ]]; then
        echo ""
        echo "   Enter your Git configuration details:"
        
        # Get user name (default: Elam Buteil)
        echo -n "   Your name [Elam Buteil]: "
        read -r git_name
        if [[ -z "$git_name" ]]; then
            git_name="Elam Buteil"
        fi
        
        # Get user email (no default)
        echo -n "   Your email: "
        read -r git_email
        while [[ -z "$git_email" ]]; do
            echo -n "   Email is required. Your email: "
            read -r git_email
        done
        
        # Get default branch (default: main)
        echo -n "   Default branch [main]: "
        read -r git_branch
        if [[ -z "$git_branch" ]]; then
            git_branch="main"
        fi
        
        echo "   - Configuring Git settings..."
        
        # Update the gitconfig with user's details
        sed -i.bak "s/name = .*/name = $git_name/" "$TEMP_GITCONFIG"
        sed -i.bak "s/email = .*/email = $git_email/" "$TEMP_GITCONFIG"
        sed -i.bak "s/defaultBranch = .*/defaultBranch = $git_branch/" "$TEMP_GITCONFIG"
        
        # Copy to home directory
        cp "$TEMP_GITCONFIG" "$HOME/.gitconfig"
        
        # Clean up
        rm -f "$TEMP_GITCONFIG" "$TEMP_GITCONFIG.bak"
        
        echo "   ✅ Git configuration complete"
        echo "      - Name: $git_name"
        echo "      - Email: $git_email"
        echo "      - Default branch: $git_branch"
        echo "      - Custom aliases and settings applied"
    fi
else
    echo "   ⏭️  Skipping Git configuration"
fi

# Download video background image
echo ""
echo "🖼️  Step 8: Downloading video background image..."
echo -n "   Download video background image? [Y/n]: "
read -n 1 -r download_response
echo  # Move to next line after keystroke

# Default to yes if empty response
if [[ -z "$download_response" || "$download_response" =~ ^[Yy]$ ]]; then
    echo "   Enter image URL (press Enter for default):"
    echo -n "   URL [https://pbs.twimg.com/media/EYHI9t8XYAAZjjQ.jpg]: "
    read -r image_url

    # Use default URL if empty response
    if [[ -z "$image_url" ]]; then
        image_url="https://pbs.twimg.com/media/EYHI9t8XYAAZjjQ.jpg"
    fi

    echo "   - Downloading image from: $image_url"
    echo "   - Saving to Documents folder..."

    # Create Documents directory if it doesn't exist
    mkdir -p "$HOME/Documents"

    # Download the image using curl
    if curl -L "$image_url" -o "$HOME/Documents/video_background.jpg"; then
        echo "   ✅ Video background image downloaded to ~/Documents/video_background.jpg"
    else
        echo "   ⚠️  Failed to download video background image"
    fi
else
    echo "   ⏭️  Skipping video background image download"
fi

# Step 9: Configure Chrome DevTools preferences
echo "🌐 Step 9: Configuring Chrome DevTools preferences..."

# Ask user if they want to configure Chrome DevTools
echo ""
echo -n "   Configure Chrome DevTools custom devices? (This will quit all Chrome instances) [Y/n]: "
read -n 1 -r chrome_response
echo  # Move to next line after keystroke

# Default to yes if empty response
if [[ -z "$chrome_response" || "$chrome_response" =~ ^[Yy]$ ]]; then
    # Chrome preferences file path
    CHROME_PREFS_PATH="$HOME/Library/Application Support/Google/Chrome/Default/Preferences"

    if [ -f "$CHROME_PREFS_PATH" ]; then
        echo "   - Found Chrome preferences file"
        echo "   - Backing up existing preferences..."
        
        # Create backup
        cp "$CHROME_PREFS_PATH" "$CHROME_PREFS_PATH.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Quit Chrome if it's running
        if pgrep -x "Google Chrome" > /dev/null; then
            echo "   - Quitting Chrome instances..."
            pkill -f "Google Chrome"
            sleep 2  # Wait for Chrome to fully quit
        fi
        
        echo "   - Updating DevTools custom emulated device list..."
        
        # Use Python to safely update the JSON preferences
        python3 -c "
import json
import sys

prefs_path = '$CHROME_PREFS_PATH'
custom_devices = '[{\"title\":\"XL Desktop\",\"type\":\"unknown\",\"user-agent\":\"\",\"capabilities\":[],\"screen\":{\"device-pixel-ratio\":0,\"vertical\":{\"width\":1920,\"height\":1080},\"horizontal\":{\"width\":1080,\"height\":1920}},\"modes\":[{\"title\":\"\",\"orientation\":\"vertical\",\"insets\":{\"left\":0,\"top\":0,\"right\":0,\"bottom\":0}},{\"title\":\"\",\"orientation\":\"horizontal\",\"insets\":{\"left\":0,\"top\":0,\"right\":0,\"bottom\":0}}],\"show-by-default\":true,\"dual-screen\":false,\"foldable-screen\":false,\"show\":\"Always\",\"user-agent-metadata\":{\"brands\":[{\"brand\":\"\",\"version\":\"\"}],\"fullVersionList\":[{\"brand\":\"\",\"version\":\"\"}],\"fullVersion\":\"\",\"platform\":\"\",\"platformVersion\":\"\",\"architecture\":\"\",\"model\":\"\",\"mobile\":false}},{\"title\":\"L Desktop\",\"type\":\"unknown\",\"user-agent\":\"\",\"capabilities\":[],\"screen\":{\"device-pixel-ratio\":0,\"vertical\":{\"width\":1366,\"height\":768},\"horizontal\":{\"width\":768,\"height\":1366}},\"modes\":[{\"title\":\"\",\"orientation\":\"vertical\",\"insets\":{\"left\":0,\"top\":0,\"right\":0,\"bottom\":0}},{\"title\":\"\",\"orientation\":\"horizontal\",\"insets\":{\"left\":0,\"top\":0,\"right\":0,\"bottom\":0}}],\"show-by-default\":true,\"dual-screen\":false,\"foldable-screen\":false,\"show\":\"Default\",\"user-agent-metadata\":{\"brands\":[{\"brand\":\"\",\"version\":\"\"}],\"fullVersionList\":[{\"brand\":\"\",\"version\":\"\"}],\"fullVersion\":\"\",\"platform\":\"\",\"platformVersion\":\"\",\"architecture\":\"\",\"model\":\"\",\"mobile\":false}},{\"title\":\"M Desktop\",\"type\":\"unknown\",\"user-agent\":\"\",\"capabilities\":[],\"screen\":{\"device-pixel-ratio\":0,\"vertical\":{\"width\":1280,\"height\":1024},\"horizontal\":{\"width\":1024,\"height\":1280}},\"modes\":[{\"title\":\"\",\"orientation\":\"vertical\",\"insets\":{\"left\":0,\"top\":0,\"right\":0,\"bottom\":0}},{\"title\":\"\",\"orientation\":\"horizontal\",\"insets\":{\"left\":0,\"top\":0,\"right\":0,\"bottom\":0}}],\"show-by-default\":true,\"dual-screen\":false,\"foldable-screen\":false,\"show\":\"Default\",\"user-agent-metadata\":{\"brands\":[{\"brand\":\"\",\"version\":\"\"}],\"fullVersionList\":[{\"brand\":\"\",\"version\":\"\"}],\"fullVersion\":\"\",\"platform\":\"\",\"platformVersion\":\"\",\"architecture\":\"\",\"model\":\"\",\"mobile\":false}}]'

try:
    with open(prefs_path, 'r') as f:
        prefs = json.load(f)
    
    # Ensure the devtools structure exists
    if 'devtools' not in prefs:
        prefs['devtools'] = {}
    if 'preferences' not in prefs['devtools']:
        prefs['devtools']['preferences'] = {}
    
    # Set the custom emulated device list
    prefs['devtools']['preferences']['custom-emulated-device-list'] = custom_devices
    
    with open(prefs_path, 'w') as f:
        json.dump(prefs, f, indent=2)
    
    print('Chrome preferences updated successfully')
except Exception as e:
    print(f'Error updating Chrome preferences: {e}')
    sys.exit(1)
"
        
        echo "   ✅ Chrome DevTools preferences updated"
    else
        echo "   ⚠️  Chrome preferences file not found. Chrome may not be installed or hasn't been run yet."
        echo "   This step will be skipped. Run this script again after setting up Chrome."
    fi
else
    echo "   ⏭️  Skipping Chrome DevTools configuration"
fi

echo ""
echo "🎉 macOS Initial Setup Complete!"
echo "================================="
echo ""
echo "📋 Summary of changes:"
echo "  ✅ Language toggle: CMD+Space"
echo "  ✅ Spotlight search: CTRL+Space"
echo "  ✅ Lock screen: CMD+L"
echo "  ✅ Dock settings configured (autohide, size, magnification, no recent apps)"
echo "  ✅ Trackpad tap to click enabled"
echo "  ✅ Finder configured (extensions shown, ~/projects folder created)"
echo "  ✅ Homebrew installed and configured"
echo "  ✅ Optional software installed (as selected)"
echo "  ✅ Python essentials installed (as selected)"
echo "  ✅ Git configuration applied (as selected)"
echo "  ✅ Video background image downloaded (as selected)"
echo "  ✅ Chrome DevTools custom devices added (as selected)"
echo ""
echo "📝 Notes:"
echo "  - You may need to log out and back in for keyboard shortcuts to take effect"
echo "  - Dock changes are already active"
echo "  - Chrome settings will take effect the next time you start Chrome"
echo ""
echo "🔄 Apply keyboard shortcut changes immediately:"
echo ""
echo -n "   Run 'sudo killall cfprefsd' to apply keyboard shortcuts now? [Y/n]: "
read -n 1 -r sudo_response
echo  # Move to next line after keystroke

# Default to yes if empty response
if [[ -z "$sudo_response" || "$sudo_response" =~ ^[Yy]$ ]]; then
    echo ""
    echo "   ⚠️  This command requires administrator privileges"
    echo "   📝 What it does: Forces macOS to reload system preferences"
    echo "   🔑 You will be prompted for your password"
    echo ""
    echo "   - Running: sudo killall cfprefsd"
    
    if sudo killall cfprefsd; then
        echo "   ✅ Keyboard shortcuts applied immediately"
        echo "   📱 Your new shortcuts are now active!"
    else
        echo "   ⚠️  Failed to apply shortcuts immediately"
        echo "   💡 You can run 'sudo killall cfprefsd' manually later"
        echo "   🔄 Or log out and back in to apply the changes"
    fi
else
    echo "   ⏭️  Skipping immediate keyboard shortcut application"
    echo "   💡 Keyboard shortcuts will take effect after logout/login"
fi

echo ""
