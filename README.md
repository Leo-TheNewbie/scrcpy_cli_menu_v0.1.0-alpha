# scrcs_cli_menu_v0.1.0-alpha
Is a wrapper and cli for the scrcs, it allows for dps settings, CURRENTLY WINDOWS ONLY, ps is made by coffeine fueled spite
So basically i grew tired of redmagic studio with their installer not working so i spent a week thinking what can i do to replace it, and a few searches led me here, although i slammed my head in a few bumps. I managed to make a windows script, dedicated to any phones with active cooling fan that is integrated on hardware.
## 🛠️ PREREQUISITES

* The Latest **ADB** & **SCRCPY** binaries.
https://scrcpy.org/download/
* **Windows 11**

Settings:
  DEVELOPER OPTIONS:
    
    ADB Debugging:                                ON
    Allow ADB debugging when in charge only mode: ON
    Disable adb authorization timeout:            ON 
    (Prevents Android from automatically revoking your PC's security keys every 7 days, ensuring the script always launches instantly with zero phone interaction. 
    TO NOTE: IT CAN BE A SECURITY RISK; is NOT advised to keep it on if the default option is a laptop or mobile device)
    Disable default Framerate:                    ON
    Force activities  to be resizable:            ON
    Enable Freeform windows:                      ON
---
  HOW TO INSTALL:
1. Download `play.bat`.
2. Plop the `.bat` file directly into your core directory containing the `scrcpy` and `adb` binaries (otherwise Windows freaks out).
3. Run `play.bat` and enjoy a zero-overhead setup.
---

PROJECT STATUS & CONTRIBUTIONS

While this is an **Alpha release**, please note that I cannot physically provide constant, active updates. I am a university student, and this remains a pure fan/spite project designed to make the `scrcpy` pipeline more seamless and high-level for hardware enthusiasts.

Help, code optimization, and pull requests are very much appreciated!
  Help is very much appreciated
---

  THANKS:
  
  To rosalina menu creators for the idea for the cli style
  
  ZTE/NUBIA/REDMAGIC: for providing a broken installation to their redmagic studio
  
  **Romain Vimont (rom1v) & the Genymobile team:** For creating `scrcpy` and their amazing work to keep this mirroring working nicely
  
 ## 🎨 ALTERNATIVE INTERFACES

If you prefer a cute, full Graphical User Interface (GUI) over a lightweight, no-nonsense TUI cockpit, check out these community forks:

* **[QtScrcpy](https://github.com/barry-ran/QtScrcpy)** - A beautiful, feature-rich graphical branch with custom key-mappings.
* **[Guiscrcpy](https://github.com/srevinsaju/guiscrcpy)** - A sleek, desktop-integrated engine with full floating panels.

*Note: While those projects focus on visual aesthetics and mouse-driven menus, this orchestrator (`scrcpy-cli-menu`) is built purely for rapid, lightweight terminal control and direct active-cooling hardware execution.*
