# Kindle Special Offer Remover
## Overview

**Kindle Special Offer Remover** is a tool for jailbroken Kindle devices that helps you remove Amazon's special offers (ads) easily.  
Supports both manual removal and a convenient KUAL extension.
Tool is mostly based on [BinarySpawn blog](https://www.binaryspawn.com/4/) about removing special offers on Kindle PW2. It works on PW3 didn't checked other devices since I don't have them 😊.

## Disclaimer
Use this tool at your own risk. Removing special offers may violate Amazon's terms of service.

---
## Requirements
- Jailbroken Kindle device
- Terminal emulator (KTerm or KoReader) **or** KUAL installed

## Usage
### 1. KUAL Extension (Coming Soon™)
1. [Download the KUAL extension](https://github.com/username/repo/releases)
2. Copy the extension file to your Kindle's `extensions` folder.
3. Launch the KUAL extension from your Kindle's home screen.
4. Tap to remove special offers.

### 2. Manual Removal
#### Step 1: Open Terminal Emulator
- **KTerm:** Just open the app.
- **KoReader:**  
  Tap the ![**Wrench icon**](https://koreader.rocks/user_guide/pictures/top_tools.svg) → `More Tools` → `Terminal Emulator` → `Open terminal session`.
#### Step 2: Run Removal Command
- **Backup & Remove Special Offers:** (Recommended)
  ```sh
  curl https://raw.githubusercontent.com/username/repo/branch/backup-n-remove.sh | sh
  ```
- **Backup Only:**
  ```sh
  curl https://raw.githubusercontent.com/username/repo/branch/backup.sh | sh
  ```
- **Remove Special Offers Only:**
  ```sh
  curl https://raw.githubusercontent.com/username/repo/branch/remove.sh | sh
  ```
- **Restore Backup:**
  ```sh
  curl https://raw.githubusercontent.com/username/repo/branch/restore.sh | sh
  ```
- You can also download the scripts edit them and run them from your device directly.
---