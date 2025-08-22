# Kindle Special Offer Remover
## Overview

**Kindle Special Offer Remover** *Kindle AD Remover* is a tool for jailbroken Kindle devices that helps you remove Amazon's special offers (ads) easily and safely.  
Supports both manual removal and a convenient KUAL extension.
Tool is mostly based on [BinarySpawn blog](https://www.binaryspawn.com/4/) about removing special offers on Kindle PW2. Use it if official way failed you.

## Disclaimer
This tool is for research purposes only. Use this tool at your own risk.

## Compatibility
| Device Model | Compatibility  |
|--------------|----------------|
| Kindle PW3   | 🟩 Works       |
| Kindle PW2   | 🟨 Should Work |
| Other        | 🟧 Unknown     |

*You can report compatibility of other devices in the issues*
## Requirements
- Jailbroken Kindle device
- Terminal emulator (KTerm or KoReader) **or** KUAL installed

## Usage
### 1. KUAL Extension (Coming Soon™)
1. [Download the KUAL extension](https://github.com/username/repo/releases)
2. Copy the extension directory to your Kindle's `extensions` folder.
3. Launch the KUAL extension from your Kindle's home screen.
4. Use desired removal options.

### 2. Manual Removal via Terminal (Online)
1. Open [KTerm](https://github.com/bfabiszewski/kterm/releases/) from KUAL *[KoReader doesn't work for some reason]*
2. Run Removal Command *links are planned to be shortend*
- **Backup & Remove Special Offers:** (Recommended)
  ```sh
  curl https://raw.githubusercontent.com/raharu-dev/Kindle-SORemover/main/backup-n-remove.sh | sh
  ```
- **Backup Special Offers Only:**
  ```sh
  curl https://raw.githubusercontent.com/raharu-dev/Kindle-SORemover/main/backup.sh | sh
  ```
- **Remove Special Offers Only:**
  ```sh
  curl https://raw.githubusercontent.com/raharu-dev/Kindle-SORemover/main/remove.sh | sh
  ```
- **Restore Backup:**
  ```sh
  curl https://raw.githubusercontent.com/raharu-dev/Kindle-SORemover/main/restore.sh | sh
  ```
3. Reboot the device you can use command
    ```sh
    reboot
    ```

### 3. Manual Removal via Terminal (Offline)
1. [Download](https://github.com/raharu-dev/Kindle-SORemover/archive/refs/heads/main.zip) the repository as ZIP
2. Plug your device to the USB
3. Extract the .sh files to some directory on your device e.g. `/soremover/`
4. Unplug your device
5. Open Terminal Emulator:
    - For KTerm just open it from KUAL ([KTerm](https://github.com/bfabiszewski/kterm/releases/))
    - For KoReader Tap the Tools icon on top → More Tools → Terminal Emulator → Open terminal session
6. Navigate to the extracted folder if you used the example path then: 
    ```sh
    cd /mnt/us/soremover/
    ```
7. Run the desired removal script
- **Backup & Remove Special Offers:** (Recommended)
    ```sh
    ./backup-n-remove.sh
    ```
- **Backup Special Offers Only:**
    ```sh
    ./backup.sh
    ```
- **Remove Special Offers Only:**
    ```sh
    ./remove.sh
    ```
- **Restore Backup:**
    ```sh
    ./restore.sh
    ```
8. Reboot the device you can use command
    ```sh
    reboot
    ```
