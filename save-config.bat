@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Dotfiles Configuration Saver (Windows)
echo ========================================
echo.

set "DOTFILES_DIR=%~dp0"
set "HOME_DIR=%USERPROFILE%"
set "EXCLUDE_FILE=%TEMP%\dotfiles_exclude.txt"

REM Create exclude file for xcopy
echo node_modules\ > "%EXCLUDE_FILE%"
echo .git\ >> "%EXCLUDE_FILE%"

echo This script will copy your current configuration files to the dotfiles directory.
echo Dotfiles directory: %DOTFILES_DIR%
echo.

choice /C YN /M "Do you want to continue"
if errorlevel 2 goto :end

echo.
echo Copying configuration files...
echo.

if exist "%HOME_DIR%\.bashrc" (
    copy /Y "%HOME_DIR%\.bashrc" "%DOTFILES_DIR%\.bashrc" >nul 2>&1
    echo [OK] Copied .bashrc
) else (
    echo [SKIP] .bashrc not found
)

if exist "%HOME_DIR%\.bash_profile" (
    copy /Y "%HOME_DIR%\.bash_profile" "%DOTFILES_DIR%\.bash_profile" >nul 2>&1
    echo [OK] Copied .bash_profile
) else (
    echo [SKIP] .bash_profile not found
)

if exist "%HOME_DIR%\.zshrc" (
    copy /Y "%HOME_DIR%\.zshrc" "%DOTFILES_DIR%\.zshrc" >nul 2>&1
    echo [OK] Copied .zshrc
) else (
    echo [SKIP] .zshrc not found
)

if exist "%HOME_DIR%\.gitconfig" (
    copy /Y "%HOME_DIR%\.gitconfig" "%DOTFILES_DIR%\.gitconfig" >nul 2>&1
    echo [OK] Copied .gitconfig
) else (
    echo [SKIP] .gitconfig not found
)

if exist "%HOME_DIR%\.gitignore" (
    copy /Y "%HOME_DIR%\.gitignore" "%DOTFILES_DIR%\.gitignore" >nul 2>&1
    echo [OK] Copied .gitignore
) else (
    echo [SKIP] .gitignore not found
)

if exist "%HOME_DIR%\.p10k.zsh" (
    copy /Y "%HOME_DIR%\.p10k.zsh" "%DOTFILES_DIR%\.p10k.zsh" >nul 2>&1
    echo [OK] Copied .p10k.zsh
) else (
    echo [SKIP] .p10k.zsh not found
)

if exist "%HOME_DIR%\.minttyrc" (
    copy /Y "%HOME_DIR%\.minttyrc" "%DOTFILES_DIR%\.minttyrc" >nul 2>&1
    echo [OK] Copied .minttyrc
) else (
    echo [SKIP] .minttyrc not found
)

if exist "%HOME_DIR%\.ssh\config" (
    if not exist "%DOTFILES_DIR%\.ssh" mkdir "%DOTFILES_DIR%\.ssh"
    copy /Y "%HOME_DIR%\.ssh\config" "%DOTFILES_DIR%\.ssh\config" >nul 2>&1
    echo [OK] Copied .ssh\config
) else (
    echo [SKIP] .ssh\config not found
)

if exist "%HOME_DIR%\.oh-my-zsh\custom" (
    if not exist "%DOTFILES_DIR%\.oh-my-zsh\custom" mkdir "%DOTFILES_DIR%\.oh-my-zsh\custom"
    for %%f in ("%HOME_DIR%\.oh-my-zsh\custom\*.zsh") do (
        copy /Y "%%f" "%DOTFILES_DIR%\.oh-my-zsh\custom\" >nul 2>&1
    )
    echo [OK] Copied .oh-my-zsh\custom\*.zsh files
) else (
    echo [SKIP] .oh-my-zsh\custom not found
)

if exist "%HOME_DIR%\.config\fastfetch\config.jsonc" (
    if not exist "%DOTFILES_DIR%\.config\fastfetch" mkdir "%DOTFILES_DIR%\.config\fastfetch"
    copy /Y "%HOME_DIR%\.config\fastfetch\config.jsonc" "%DOTFILES_DIR%\.config\fastfetch\config.jsonc" >nul 2>&1
    echo [OK] Copied .config\fastfetch\config.jsonc
) else (
    echo [SKIP] fastfetch config not found
)

if exist "%HOME_DIR%\.config\gh\config.yml" (
    if not exist "%DOTFILES_DIR%\.config\gh" mkdir "%DOTFILES_DIR%\.config\gh"
    copy /Y "%HOME_DIR%\.config\gh\config.yml" "%DOTFILES_DIR%\.config\gh\config.yml" >nul 2>&1
    echo [OK] Copied .config\gh\config.yml
) else (
    echo [SKIP] gh config not found
)

if exist "%HOME_DIR%\.config\gh\hosts.yml" (
    copy /Y "%HOME_DIR%\.config\gh\hosts.yml" "%DOTFILES_DIR%\.config\gh\hosts.yml" >nul 2>&1
    echo [OK] Copied .config\gh\hosts.yml
)

if exist "%HOME_DIR%\.config\lazygit\config.yml" (
    if not exist "%DOTFILES_DIR%\.config\lazygit" mkdir "%DOTFILES_DIR%\.config\lazygit"
    copy /Y "%HOME_DIR%\.config\lazygit\config.yml" "%DOTFILES_DIR%\.config\lazygit\config.yml" >nul 2>&1
    echo [OK] Copied .config\lazygit\config.yml
)

REM Skipping github-copilot - contains sensitive information
echo [SKIP] .config\github-copilot (contains sensitive information)

if exist "%HOME_DIR%\.config\nvim" (
    if not exist "%DOTFILES_DIR%\.config\nvim" mkdir "%DOTFILES_DIR%\.config\nvim"
    xcopy /E /Y /Q "%HOME_DIR%\.config\nvim" "%DOTFILES_DIR%\.config\nvim\" >nul 2>&1
    echo [OK] Copied .config\nvim
) else (
    echo [SKIP] nvim config not found
)

if exist "%HOME_DIR%\.config\opencode" (
    if not exist "%DOTFILES_DIR%\.config\opencode" mkdir "%DOTFILES_DIR%\.config\opencode"
    xcopy /E /Y /Q "%HOME_DIR%\.config\opencode" "%DOTFILES_DIR%\.config\opencode\" /EXCLUDE:%EXCLUDE_FILE% >nul 2>&1
    echo [OK] Copied .config\opencode
) else (
    echo [SKIP] opencode config not found
)

if exist "%HOME_DIR%\.config\scoop\config.json" (
    if not exist "%DOTFILES_DIR%\.config\scoop" mkdir "%DOTFILES_DIR%\.config\scoop"
    copy /Y "%HOME_DIR%\.config\scoop\config.json" "%DOTFILES_DIR%\.config\scoop\config.json" >nul 2>&1
    echo [OK] Copied .config\scoop\config.json
) else (
    echo [SKIP] scoop config not found
)

echo.
choice /C YN /M "Update scoop-packages.json with currently installed packages"
if not errorlevel 2 (
    where scoop >nul 2>&1
    if !errorlevel! equ 0 (
        scoop export > "%DOTFILES_DIR%\scoop-packages.json" 2>&1
        echo [OK] Updated scoop-packages.json
    ) else (
        echo [ERROR] Scoop not found
    )
)

echo.
echo ========================================
echo Configuration save complete!
echo ========================================

REM Clean up exclude file
if exist "%EXCLUDE_FILE%" del "%EXCLUDE_FILE%"

:end
endlocal
