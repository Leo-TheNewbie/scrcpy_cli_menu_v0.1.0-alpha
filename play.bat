@echo off
setlocal enabledelayedexpansion
title Universal Mobile Gaming Dashboard Engine

:: ===================================================
:: DEFAULT CONFIGURATION FACTORY RESET STATES
:: ===================================================
set "WIDTH=1920"
set "HEIGHT=1080"
set "REFRESH=140"
set "DPI_VAL=480"
set "DPI_LABEL=Medium (Default)"
set "LAUNCH_APP=com.freestylelibre.app.it"
set "CONFIG_PARAMS=--keyboard=uhid --gamepad=uhid"

:MAIN_MENU
cls
echo =====================================================================
echo                     UNIVERSAL MOBILE DASHBOARD ENGINE                 
echo =====================================================================
echo  [1] LAUNCH SESSION NOW (Current Config: %WIDTH%x%HEIGHT%@%REFRESH%Hz)
echo  [2] CONFIGURE ENVIRONMENT SETTINGS
echo  [3] SAFE EXIT / HARDWARE RESET
echo =====================================================================
echo.
choice /c 123 /n /m "Select an option [1-3]: "
if errorlevel 3 goto FULL_CLEANUP_EXIT
if errorlevel 2 goto SETTINGS_MENU
if errorlevel 1 goto DEPLOY_HARDWARE_RAILS

:: ===================================================
:: SETTINGS CONFIGURATION SUB-MENU
:: ===================================================
:SETTINGS_MENU
cls
echo =====================================================================
echo                     ENVIRONMENT PROFILE CONFIGURATION                 
echo =====================================================================
echo  [R] Target Resolution : %WIDTH%x%HEIGHT%
echo  [D] Interface Scale/DPI: %DPI_LABEL%
echo  [A] Active Startup App: %LAUNCH_APP%
echo  [B] Back to Main Menu
echo =====================================================================
echo.
choice /c RDAB /n /m "Select a setting to modify [R, D, A, B]: "
if errorlevel 4 goto MAIN_MENU
if errorlevel 3 goto SET_APP_TARGET
if errorlevel 2 goto SET_DPI_SCALE
if errorlevel 1 goto SET_RESOLUTION

:SET_RESOLUTION
cls
echo === CHOOSE TARGET DISPLAY DOCK RESOLUTION ===
echo  [1] 1080p Standard (1920x1080)
echo  [2] 2K Ultrawide (2560x1080)
echo  [3] Custom Definition Entry
echo.
choice /c 123 /n /m "Select profile [1-3]: "
if errorlevel 3 (
    set /p "WIDTH=Enter Target Width (e.g. 1920): "
    set /p "HEIGHT=Enter Target Height (e.g. 1080): "
    goto SETTINGS_MENU
)
if errorlevel 2 ( set "WIDTH=2560" & set "HEIGHT=1080" & goto SETTINGS_MENU )
if errorlevel 1 ( set "WIDTH=1920" & set "HEIGHT=1080" & goto SETTINGS_MENU )

:SET_DPI_SCALE
cls
echo === CHOOSE DISPLAY PANEL UI DENSITY (DPI) ===
echo  [1] Medium / Standard Density (480 DPI)
echo  [2] Large / High Scaled Density (540 DPI)
echo  [3] Very Large / Maximum Accessibility Density (640 DPI)
echo.
choice /c 123 /n /m "Select density profile [1-3]: "
if errorlevel 3 ( set "DPI_VAL=640" & set "DPI_LABEL=Very Large" & goto SETTINGS_MENU )
if errorlevel 2 ( set "DPI_VAL=540" & set "DPI_LABEL=Large" & goto SETTINGS_MENU )
if errorlevel 1 ( set "DPI_VAL=480" & set "DPI_LABEL=Medium (Default)" & goto SETTINGS_MENU )

:SET_APP_TARGET
cls
echo === ENTER TARGET ANDROID PACKAGE NAME ===
echo Common Examples:
echo  - com.freestylelibre.app.it (LibreLink IT)
echo  - com.whatsapp (WhatsApp Messenger)
echo  - com.instagram.android (Instagram)
echo  - spotify.com/0 (Spotify Music Engine)
echo.
set /p "LAUNCH_APP=Type or paste exact app package ID: "
goto SETTINGS_MENU

:: ===================================================
:: CORE EXECUTION ENGINE
:: ===================================================
:DEPLOY_HARDWARE_RAILS
cls
echo [+] Pinging target device over USB link...
.\adb shell "echo 1" >nul 2>&1
if errorlevel 1 (
    echo [X] ERROR: Device not found! Secure connection cable and check ADB pairing.
    pause
    goto MAIN_MENU
)

echo [+] Initializing custom performance rails...
.\adb shell settings put system screen_off_timeout 1800000 >nul 2>&1
.\adb shell svc power stayon usb >nul 2>&1

:: Engage active physical hardware fan cooling matrix
.\adb shell "echo 1 > /sys/kernel/fan/fan_mode" >nul 2>&1
.\adb shell "echo 5 > /sys/kernel/fan/fan_speed" >nul 2>&1

:: Dim physical device panel to dark ambient baseline
.\adb shell settings put system screen_brightness 1 >nul 2>&1

:: Push custom virtual display properties to the device configuration register
echo [+] Calibrating virtual display architecture density to %DPI_VAL% DPI...
.\adb shell wm density %DPI_VAL% >nul 2>&1

:: Force target app initialization
echo [+] Launching localized startup target: %LAUNCH_APP%
.\adb shell monkey -p %LAUNCH_APP% -c android.intent.category.LAUNCHER 1 >nul 2>&1

:: Build persistent low-level tracking daemon to capture unintended drops
.\adb shell "echo '#!/system/bin/sh' > /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'logcat -b kernel -m 1 -e \"USB disconnect\"' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'echo 0 > /sys/kernel/fan/fan_mode' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'svc power stayon false' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'settings put system screen_brightness 100' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'settings put system screen_off_timeout 30000' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'pkill -f scrcpy' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'wm set-displays-user-disabled 1' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'wm size reset' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'wm density reset' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "echo 'exit 0' >> /data/local/tmp/usb_monitor.sh"
.\adb shell "chmod +x /data/local/tmp/usb_monitor.sh"
.\adb shell "nohup /data/local/tmp/usb_monitor.sh >/dev/null 2>&1 &"

:CONTROL_PROFILE_CHOICE
cls
echo =====================================================================
echo                     SELECT HID CONTROL ENGINE MODE                    
echo =====================================================================
echo  [1] Controller Mode (FPS / Native Pass-through Peripheral)
echo  [2] Mouse Mode (Strategy Games / Raw UHID Touch Mapping)
echo =====================================================================
echo.
choice /c 123 /n /m "Select engine mode [1-2]: "
if errorlevel 2 (set "CONFIG_PARAMS=--keyboard=uhid --gamepad=uhid --mouse=uhid")
if errorlevel 1 (set "CONFIG_PARAMS=--keyboard=uhid --gamepad=uhid")

:RUN_STREAM
cls
echo [+] Running 140Hz display engine session...
echo [!] Target Node: %WIDTH%x%HEIGHT% @ %REFRESH%Hz
echo [!] Close display terminal frame to return to host operations stack.
echo.

scrcpy --new-display=%WIDTH%x%HEIGHT%/%REFRESH% %CONFIG_PARAMS% --max-fps=244

:: Check if the phone was physically unplugged while running (Arcane Connection Dropped)
.\adb shell "echo 1" >nul 2>&1
if errorlevel 1 (
    goto ARCANE_DISCONNECT_RECOVERY
)

:: ===================================================
:: SESSION TEARDOWN OR REBOOT MANAGER
:: ===================================================
:SESSION_CLOSE_OPTIONS
cls
echo =====================================================================
echo                     SESSION INTERRUPTED / DISPLAY CLOSED              
echo =====================================================================
echo  [1] Hot Restart: Relaunch session immediately with current settings
echo  [2] Retrack State: Return to Configuration Menu to adjust settings/apps
echo  [3] Hard Tear-Down: Close everything, flush registers, and exit safe
echo =====================================================================
echo.
choice /c 123 /n /m "Choose next state operation [1-3]: "
if errorlevel 3 goto FULL_CLEANUP_EXIT
if errorlevel 2 goto MAIN_MENU
if errorlevel 1 goto RUN_STREAM

:: ===================================================
:: EXCEPTION HANDLING AND GARBAGE COLLECTION
:: ===================================================
:ARCANE_DISCONNECT_RECOVERY
cls
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo [WARNING] ARCANE DISCONNECT DETECTED: Physical link severed unexpectedly!
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
echo [+] Local tracking daemon handling hardware safety resets on device array...
echo [+] Cleaning host terminal environment variables...
timeout /t 4 >nul
goto MAIN_MENU

:FULL_CLEANUP_EXIT
cls
echo [!] Initiating full hardware teardown. Restoring phone register factory matrix...
.\adb shell "echo 0 > /sys/kernel/fan/fan_mode" >nul 2>&1
.\adb shell settings put system screen_brightness 100 >nul 2>&1
.\adb shell svc power stayon false >nul 2>&1
.\adb shell settings put system screen_off_timeout 30000 >nul 2>&1
.\adb shell wm set-displays-user-disabled 1 >nul 2>&1
.\adb shell wm size reset >nul 2>&1
.\adb shell wm density reset >nul 2>&1
.\adb shell pkill -f scrcpy >nul 2>&1

echo [✓] System registers back to normal. Workspace safe. Pull the plug!
timeout /t 3
exit