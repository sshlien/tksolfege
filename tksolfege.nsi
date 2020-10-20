; tksolfege.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects,

;--------------------------------

; The name of the installer
Name "tksolfege installer"

; The file to write
OutFile "tksolfege_setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\tksolfege

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\tksolfege" "Install_Dir"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "tksolfege (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "tksolfege_win32.exe"

  # drumseq is now included in exe file
  #SetOutPath "$INSTDIR\drumseq"
  #File /nonfatal /a /r "drumseq\"
  #SetOutPath $INSTDIR

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_Example2 "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\tksolfege" "DisplayName" "tksolfege"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\tksolfege" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\tksolfege" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\tksolfege"
  CreateShortCut "$SMPROGRAMS\tksolfege\tksolfege.lnk" "$INSTDIR\tksolfege_win32.exe" "" "$INSTDIR\tksolfege_win32.exe" 0
  CreateShortCut "$SMPROGRAMS\tksolfege\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\tksolfege"
  DeleteRegKey HKLM SOFTWARE\tksolfege

  ; Remove files and uninstaller
  Delete $INSTDIR\tksolfege.exe
  RMDIR /r $INSTDIR\..\tksolfege
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\tksolfege\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\tksolfege"
  RMDir "$INSTDIR"

SectionEnd
