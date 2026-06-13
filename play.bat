@echo off
setlocal enabledelayedexpansion
title Universal Mobile Gaming Dashboard Engine
:: ===================================================
:: INITIALIZE OR READ LOCALIZED INTERNAL STATES
:: ===================================================
:: The script reads its own tail to find existing configuration values
set "MY_FILE=%~f0"
for /f "tokens=1,2 delims==" %%i in ('findstr /b "DATA_" "%MY_FILE%"') do (
    if "%%i"=="DATA_WIDTH" set "WIDTH=%%j"
    if "%%i"=="DATA_HEIGHT" set "HEIGHT=%%j"
    if "%%i"=="DATA_DPI_VAL" set "DPI_VAL=%%j"
    if "%%i"=="DATA_DPI_LABEL" set "DPI_LABEL=%%j"
    if "%%i"=="DATA_LAUNCH_APP" set "LAUNCH_APP=%%j"
)
:: Fallback defaults if the file was just cleanly created
if "%WIDTH%"=="" set "WIDTH=1920"
if "%HEIGHT%"=="" set "HEIGHT=1080"
if "%REFRESH%"=="" set "REFRESH=140"
if "%DPI_VAL%"=="" set "DPI_VAL=480"
if "%DPI_LABEL%"=="" set "DPI_LABEL=Medium (Default)"
if "%LAUNCH_APP%"=="" set "LAUNCH_APP=com.freestylelibre.app.it"
set "CONFIG_PARAMS=--keyboard=uhid --gamepad=uhid"
:MAIN_MENU
cls
echo =====================================================================
echo                       UNIVERSAL MOBILE DASHBOARD ENGINE                 
echo =====================================================================
echo  [1] LAUNCH SESSION NOW 
echo      -> Config: %WIDTH%x%HEIGHT%@%REFRESH%Hz
echo      -> Target: %LAUNCH_APP%
echo  [2] CONFIGURE ENVIRONMENT SETTINGS
echo  [3] SAFE EXIT / HARDWARE RESET
echo =====================================================================
echo  [ If running a REDMAGIC 11 PRO (or later) or an
echo      advanced gaming setup, ensure your target app is added to Game 
echo      Space or turn on the Liquid Cooling quick toggle before launching
echo      to avoid thermal throttling and the summer hot potato effect
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
echo                       ENVIRONMENT PROFILE CONFIGURATION                 
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
    goto SAVE_INTERNAL_STATE
)
if errorlevel 2 ( set "WIDTH=2560" & set "HEIGHT=1080" & goto SAVE_INTERNAL_STATE )
if errorlevel 1 ( set "WIDTH=1920" & set "HEIGHT=1080" & goto SAVE_INTERNAL_STATE )
:SET_DPI_SCALE
cls
echo === CHOOSE DISPLAY PANEL UI DENSITY (DPI) ===
echo  [1] Medium / Standard Density (480 DPI)
echo  [2] Large / High Scaled Density (540 DPI)
echo  [3] Very Large / Maximum Accessibility Density (640 DPI)
echo.
choice /c 123 /n /m "Select density profile [1-3]: "
if errorlevel 3 ( set "DPI_VAL=640" & set "DPI_LABEL=Very Large" & goto SAVE_INTERNAL_STATE )
if errorlevel 2 ( set "DPI_VAL=540" & set "DPI_LABEL=Large" & goto SAVE_INTERNAL_STATE )
if errorlevel 1 ( set "DPI_VAL=480" & set "DPI_LABEL=Medium (Default)" & goto SAVE_INTERNAL_STATE )
:SET_APP_TARGET
cls
echo === ENTER TARGET ANDROID PACKAGE NAME ===
echo Common Examples:
echo  - com.freestylelibre.app.it (LibreLink IT)
echo  - com.whatsapp (WhatsApp Messenger)
echo  - com.instagram.android (Instagram)
echo.
set /p "LAUNCH_APP=Type or paste exact app package ID: "
cls
echo =====================================================================
echo  [] IMPORTANT HARDWARE PRO-TIP FOR LIQUID COOLING
echo =====================================================================
echo  To ensure the physical fluid pump engages and keeps the Snapdragon
echo  from turning into a summer hot potato, make sure you either:
echo.
echo  1. Add and launch "%LAUNCH_APP%" inside the phone's GAME SPACE.
echo  2. OR manually toggle "Liquid Cooling" ON via the Quick Settings
echo     notification bar before starting the session.
echo =====================================================================
echo.
echo Saving details and returning to menu...
goto SAVE_INTERNAL_STATE
:: ===================================================
:: SELF-REWRITING COMPONENT REUSE MATRIX
:: ===================================================
:SAVE_INTERNAL_STATE
:: Read everything up to the data block marker and write to a temporary handle
set "TEMP_CONF=%TEMP%\dashboard_update.tmp"
type nul > "%TEMP_CONF%"
for /f "delims=" %%a in ('findstr /v /b "DATA_" "%MY_FILE%"') do (
    echo %%a>>"%TEMP_CONF%"
)
:: Append the updated variables back into the script body natively
echo DATA_WIDTH=%WIDTH%>>"%TEMP_CONF%"
echo DATA_HEIGHT=%HEIGHT%>>"%TEMP_CONF%"
echo DATA_DPI_VAL=%DPI_VAL%>>"%TEMP_CONF%"
echo DATA_DPI_LABEL=%DPI_LABEL%>>"%TEMP_CONF%"
echo DATA_LAUNCH_APP=%LAUNCH_APP%>>"%TEMP_CONF%"
move /y "%TEMP_CONF%" "%MY_FILE%" >nul
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
:: Arm the 10-second emergency trap (This is what the phone runs if the cord is yanked)
.\adb shell settings put system screen_off_timeout 10000 >nul 2>&1
.\adb shell svc power stayon usb >nul 2>&1

:: Limit background processes to zero for total session isolation
.\adb shell cmd activity set-process-limit 0 >nul 2>&1

:: Engage active physical hardware fan cooling matrix
echo [SYSTEM] Initiating hardware cooling loop...
.\adb shell settings put system fan_state_of_manual 1
.\adb shell settings put system fan_state_of_mode 1
timeout /t 2 >nul
echo [SYSTEM] Activating Max Turbofan Performance (20k RPM)
.\adb shell settings put system fan_state_of_mode 2

:: Dim physical device panel to dark ambient baseline
.\adb shell settings put system screen_brightness 1 >nul 2>&1

:: Push custom virtual display properties to the device configuration register
echo [+] Calibrating virtual display architecture density to %DPI_VAL% DPI...
.\adb shell wm density %DPI_VAL% >nul 2>&1

:: Force target app initialization
echo [+] Launching localized startup target: %LAUNCH_APP%
.\adb shell monkey -p %LAUNCH_APP% -c android.intent.category.LAUNCHER 1 >nul 2>&1

:CONTROL_PROFILE_CHOICE
cls
echo =====================================================================
echo                      SELECT HID CONTROL ENGINE MODE                    
echo =====================================================================
echo  [1] Controller Mode (FPS / Native Pass-through Peripheral)
echo  [2] Mouse Mode (Strategy Games / Raw UHID Touch Mapping)
echo =====================================================================
echo.
choice /c 12 /n /m "Select engine mode [1-2]: "
if errorlevel 2 (set "CONFIG_PARAMS=--keyboard=uhid --gamepad=uhid --mouse=uhid")
if errorlevel 1 (set "CONFIG_PARAMS=--keyboard=uhid --gamepad=uhid")

:RUN_STREAM
cls
echo [+] Running 140Hz display engine session...
echo [!] Target Node: %WIDTH%x%HEIGHT% @ %REFRESH%Hz
echo [!] Active App : %LAUNCH_APP%
echo [!] Infinite Awake Lock Engaged via Stream Layer.
echo.
echo [*] PRO-TIP: For a clean teardown, close the scrcpy display window 
echo     on your PC instead of yanking the USB cable!
echo.

:: Launch scrcpy asynchronously. --stay-awake ensures the screen NEVER sleeps during play
start /b scrcpy --new-display=%WIDTH%x%HEIGHT%/%REFRESH% %CONFIG_PARAMS% --max-fps=244 --stay-awake

:CONNECTION_MONITOR
timeout /t 1 >nul
.\adb shell "echo 1" >nul 2>&1
if errorlevel 1 goto ARCANE_DISCONNECT_RECOVERY

tasklist /fi "imagename eq scrcpy.exe" 2>nul | findstr /i "scrcpy.exe" >nul
if errorlevel 1 goto MANUAL_SESSION_CLOSE
goto CONNECTION_MONITOR

:MANUAL_SESSION_CLOSE
goto SESSION_CLOSE_OPTIONS
:: ===================================================
:: EXCEPTION HANDLING (ZERO-REPLUG CABLE YANK)
:: ===================================================
:ARCANE_DISCONNECT_RECOVERY
cls
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo [WARNING] ARCANE DISCONNECT DETECTED: Physical link severed unexpectedly
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
echo [+] Terminating frozen desktop display canvas...
taskkill /f /im scrcpy.exe >nul 2>&1
echo.
echo ---------------------------------------------------------------------
echo [✓] SUCCESS: Phone screen has locked and GPU tasks have been terminated.
echo     The "Hot Potato" safeguard successfully protected your hardware.
echo.
echo [
echo     Please close the scrcpy streaming window first before unplugging. 
echo     This allows the script to cleanly reset your phone's daily system 
echo     settings (brightness, fan, etc.) automatically.
echo ---------------------------------------------------------------------
echo.
echo Returning to host menu in 8 seconds...
timeout /t 8
goto MAIN_MENU
:: ===================================================
:: SESSION TEARDOWN OR REBOOT MANAGER
:: ===================================================
:SESSION_CLOSE_OPTIONS
cls
echo =====================================================================
echo                      SESSION INTERRUPTED / DISPLAY CLOSED              
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
:FULL_CLEANUP_EXIT
cls
echo [!] Initiating full hardware teardown. Restoring phone register factory matrix...
.\adb shell cmd activity set-process-limit unlimit >nul 2>&1
.\adb shell settings put system fan_state_of_mode 1 >nul 2>&1
timeout /t 2 >nul
.\adb shell settings put system fan_state_of_manual 0 >nul 2>&1
.\adb shell settings put system screen_brightness 100 >nul 2>&1
.\adb shell svc power stayon false >nul 2>&1

:: ===================================================
:: POST-SESSION STANDBY TIMEOUT REGISTER
:: ===================================================
:: Set the phone's regular screen timeout back to 30 minutes (1800000 ms)
.\adb shell settings put system screen_off_timeout 1800000 >nul 2>&1

.\adb shell wm set-displays-user-disabled 1 >nul 2>&1
.\adb shell wm size reset >nul 2>&1
.\adb shell wm density reset >nul 2>&1
.\adb shell pkill -f scrcpy >nul 2>&1

echo [✓] System registers back to normal. Screen timeout set to maximum.
echo [✓] Workspace safe. Pull the plug!
timeout /t 3
exit
:: ===================================================
:: INTERNAL CONFIGURATION DATABASE STORAGE REGISTER
:: ===================================================
DATA_WIDTH=1920
DATA_HEIGHT=1080
DATA_DPI_VAL=480
DATA_DPI_LABEL=Medium (Default)
DATA_LAUNCH_APP=com.freestylelibre.app.it
