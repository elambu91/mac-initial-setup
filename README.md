# Elam's macOS Initial Setup Script

An automated script to configure a new macOS system with MY favorite defaults and install commonly used development tools.

## What it does

This script automates the initial setup of a new MacBook by configuring system settings and optionally installing development tools. Here's what it configures:

### 🎯 System Configuration (Automatic)

1. **Keyboard Shortcuts**
   - Sets language toggle to `CMD+Space`
   - Sets Spotlight search to `CTRL+Space`
   - Adds `CMD+L` shortcut for Lock Screen

2. **Dock Settings**
   - Enables auto-hide
   - Removes auto-hide delay
   - Sets animation time to 0.4 seconds
   - Uses scale effect for minimizing (instead of genie)
   - Hides recent apps
   - Sets dock size to 25% with 75% magnification

3. **Trackpad Settings**
   - Enables tap to click

4. **Homebrew Installation**
   - Installs Homebrew package manager
   - Configures PATH for both Intel and Apple Silicon Macs

### 📦 Optional Software Installation (Interactive)

The script will prompt you to install each of these tools (default is Yes, just press Enter):

- **Xcode Command Line Tools** - Essential development tools
- **iTerm2** - Enhanced terminal application
- **AWS CLI, SAML2AWS, and wget** - AWS development tools
- **Visual Studio Code** - Popular code editor
- **Git** - Version control system
- **Google Chrome** - Web browser
- **Notion** - Note-taking and productivity app
- **NVM (Node Version Manager)** - Node.js version management
- **Python Essentials** (pyenv, pipx, poetry) - Python development tools
- **Git Configuration** - Sets up your global Git settings with useful aliases

### ⚙️ Git Configuration (Interactive)

The script can automatically set up your global Git configuration with useful aliases and settings:

- **Source Options**:
  - **Default**: Uses the `.gitconfig` from this repository (includes many helpful aliases)
  - **Local**: If you place a `.gitconfig` file in the same folder as the script, it will use that instead
  - **Custom URL**: You can provide any URL to a `.gitconfig` file

- **Personalization**: The script will prompt for:
  - **Name** (default: "Elam Buteil")
  - **Email** (required, no default)
  - **Default branch** (default: "main")

- **Included Aliases** (from the default configuration):
  - `git a` → `git add`
  - `git co` → `git checkout`
  - `git cm` → `git commit -m`
  - `git st` → `git status`
  - `git br` → `git branch`
  - `git lazy "message"` → `git add -A && git commit -m "message"`
  - `git shist n` → Pretty formatted git log with graph (n is an integer of commits you want to see)
  - `git cfix/cfeat "message"` → like git lazy but formats the commit message like this:  `fix(branch-name): message` (or feat for feature)
  - `git cb` → checkout to a new branch based on whats in your clipboard (for instance if you copied branch name from linear/jira)
  - `git cbfix/cbfeat` → combines git cb with cfeat, creates a branch from your clipboard and then styles it differently for the description
  - `git pushu` → push new branch that is currently checked out, instead of using git push -u origin branch-name, no need to specify branch name
  - `git purge` → deletes ALL local branches except main! use with caution!!!!
  - And many more productivity aliases!

### 🖼️ Additional Features (Interactive)

- **Video Background Image** - Downloads a default background image for video calls
- **Chrome DevTools Configuration** - Adds custom device presets for responsive design testing

## How to run

### Option 1: Download and run directly

```bash
# Download the script
curl -O https://raw.githubusercontent.com/[your-repo]/mac-initial-setup/main/mac-initial-setup.sh

# Make it executable
chmod +x mac-initial-setup.sh

# Run the script
./mac-initial-setup.sh
```

### Option 2: Clone the repository

```bash
# Clone the repository
git clone https://github.com/[your-repo]/mac-initial-setup.git

# Navigate to the directory
cd mac-initial-setup

# Make the script executable
chmod +x mac-initial-setup.sh

# Run the script
./mac-initial-setup.sh
```

## Important Notes

- **USE AT YOUR OWN RISK**: While the script is designed to be safe, and you can see what is going to run in the script, use at your own risk. I am not responsible for where you run this.
- **Sudo access**: Some operations may require administrator privileges
- **Internet connection**: Required for downloading Homebrew and optional software
- **Time required**: 10-30 minutes depending on selected software
- **Restart recommended**: Some keyboard shortcuts may require logging out and back in to take effect

## What happens during installation

1. The script will show progress for each step
2. For optional software, you'll be prompted with `[Y/n]` - just press Enter for Yes, or 'n' for No
3. Some installations may show their own prompts (like Xcode Command Line Tools)
4. Chrome will be quit automatically if DevTools configuration is selected

## Post-installation

After the script completes:

1. **Keyboard shortcuts**: May require logout/login to take effect, or run `sudo killall cfprefsd`
2. **Dock changes**: Take effect immediately
3. **Chrome settings**: Take effect next time Chrome starts
4. **Python/Node environments**: May need terminal restart to use new PATH

## Troubleshooting

- **Permission errors**: Make sure the script is executable with `chmod +x mac-initial-setup.sh`
- **Network issues**: Ensure stable internet connection for downloads
- **Homebrew issues**: The script handles both Intel and Apple Silicon Macs automatically
- **Chrome preferences**: Chrome must be installed and run at least once before DevTools configuration

## Customization

The script is designed to be easily readable and modifiable. You can:
- Comment out sections you don't want
- Modify default settings by changing the `defaults write` commands
- Add additional software to the installation prompts
- **Custom Git Configuration**: 
  - Place your own `.gitconfig` file in the same folder as the script to use it automatically
  - Or provide a URL to any `.gitconfig` file when prompted during installation

## License

This script is provided as-is for personal use. Feel free to modify and distribute.
