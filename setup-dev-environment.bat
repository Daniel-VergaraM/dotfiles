@echo off
setlocal enabledelayedexpansion

echo ============================================
echo Development Environment Setup for Windows
echo ============================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script must be run as Administrator!
    echo Right-click the script and select "Run as administrator"
    pause
    exit /b 1
)

echo This script will help you set up your development environment.
echo You can choose which components to install.
echo.

set /p INSTALL_GIT="Install Git Bash? (Y/N): "
set /p INSTALL_SCOOP="Install Scoop package manager? (Y/N): "
set /p INSTALL_MINGW="Install MinGW C++ compiler? (Y/N): "
set /p INSTALL_ZSH="Install Zsh shell? (Y/N): "
set /p INSTALL_OHMYZSH="Install Oh-My-Zsh? (Y/N): "
set /p INSTALL_P10K="Install Powerlevel10k theme? (Y/N): "
set /p APPLY_DOTFILES="Apply dotfiles configuration? (Y/N): "
set /p INSTALL_PLUGINS="Install Oh-My-Zsh plugins? (Y/N): "
set /p IMPORT_SCOOP_PACKAGES="Import Scoop packages from dotfiles? (Y/N): "
set /p SETUP_SSH="Configure SSH? (Y/N): "
set /p INSTALL_WINTERMINAL="Install/Update Windows Terminal? (Y/N): "
set /p INSTALL_NERDFONT="Install 0xProto Nerd Font Mono? (Y/N): "
set /p INSTALL_ZENBROWSER="Install Zen Browser and set as default? (Y/N): "
set /p INSTALL_APPS="Install Discord, Steam, Epic Games, and PowerToys? (Y/N): "
set /p CREATE_SHORTCUTS="Create desktop shortcuts? (Y/N): "

echo.
echo ============================================
echo Starting installation...
echo ============================================
echo.

set INSTALL_DIR=C:\DevTools
set GIT_BASH_INSTALLER=%TEMP%\git-bash-installer.exe
set DOTFILES_DIR=%~dp0

if /i "%INSTALL_GIT%"=="Y" (
    echo.
    echo Step 1: Creating installation directory...
    if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

    echo.
    echo Step 2: Downloading latest Git Bash for Windows...
    echo Fetching latest release information...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest'; $asset = $release.assets | Where-Object {$_.name -like '*-64-bit.exe'} | Select-Object -First 1; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '%GIT_BASH_INSTALLER%'}"
    if %errorLevel% neq 0 (
        echo ERROR: Failed to download Git Bash
        pause
        exit /b 1
    )

    echo.
    echo Step 3: Installing Git Bash...
    echo This may take a few minutes...
    "%GIT_BASH_INSTALLER%" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"
    timeout /t 30 /nobreak >nul
    echo Git Bash installation initiated.

    set GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe
    echo Waiting for Git Bash installation to complete...
    :waitgit
    timeout /t 5 /nobreak >nul
    if not exist "%GIT_BASH_PATH%" goto waitgit
    echo Git Bash installed successfully!
) else (
    echo Skipping Git Bash installation...
    set GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe
)

set BASH_EXE=C:\Program Files\Git\bin\bash.exe

if /i "%INSTALL_SCOOP%"=="Y" (
    echo.
    echo Step 4: Installing Scoop package manager...
    powershell -Command "& {Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm get.scoop.sh | iex}"
    if %errorLevel% neq 0 (
        echo ERROR: Failed to install Scoop
        pause
        exit /b 1
    )
    
    set SCOOP_PATH=%USERPROFILE%\scoop\shims
    set PATH=%SCOOP_PATH%;%PATH%
) else (
    echo Skipping Scoop installation...
    set SCOOP_PATH=%USERPROFILE%\scoop\shims
    set PATH=%SCOOP_PATH%;%PATH%
)

if /i "%INSTALL_MINGW%"=="Y" (
    echo.
    echo Step 5: Installing C++ compiler via Scoop...
    call scoop install mingw
    if %errorLevel% neq 0 (
        echo WARNING: Failed to install MinGW via Scoop, trying alternative method...
        call scoop bucket add extras
        call scoop install mingw
    )
) else (
    echo Skipping MinGW installation...
)

if /i "%INSTALL_ZSH%"=="Y" (
    echo.
    echo Step 6: Installing Zsh in Git Bash environment...
    set GIT_DIR=C:\Program Files\Git

    echo Downloading and installing latest Zsh package...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $page = Invoke-WebRequest -Uri 'https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64'; $url = ($page.Links | Where-Object {$_.href -like '*.pkg.tar.zst'} | Select-Object -First 1).href; $fullUrl = 'https://mirror.msys2.org' + $url; Invoke-WebRequest -Uri $fullUrl -OutFile '%TEMP%\zsh.pkg.tar.zst'}"
    "%BASH_EXE%" -c "cd /tmp && tar -xf zsh.pkg.tar.zst -C / 2>/dev/null || echo 'Extracting zsh...'"
    echo Zsh installed successfully!
) else (
    echo Skipping Zsh installation...
)

if /i "%INSTALL_OHMYZSH%"=="Y" (
    echo.
    echo Step 7: Installing Oh-My-Zsh...
    "%BASH_EXE%" -c "export HOME=/c/Users/%USERNAME% && sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"
    echo Oh-My-Zsh installed successfully!
) else (
    echo Skipping Oh-My-Zsh installation...
)

if /i "%INSTALL_P10K%"=="Y" (
    echo.
    echo Step 8: Installing Powerlevel10k theme...
    "%BASH_EXE%" -c "export HOME=/c/Users/%USERNAME% && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
    
    echo.
    echo Step 9: Configuring Powerlevel10k theme...
    "%BASH_EXE%" -c "export HOME=/c/Users/%USERNAME% && sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ${HOME}/.zshrc"
    echo Powerlevel10k installed and configured!
    echo.
    echo NOTE: Powerlevel10k configuration wizard will run automatically on first Zsh launch.
    echo       The wizard will guide you through customizing your prompt appearance.
) else (
    echo Skipping Powerlevel10k installation...
)

if /i "%INSTALL_ZSH%"=="Y" (
    echo.
    echo Step 10: Setting Zsh as default shell in Git Bash...
    "%BASH_EXE%" -c "export HOME=/c/Users/%USERNAME% && echo 'if [ -t 1 ]; then' >> ${HOME}/.bashrc && echo '  exec zsh' >> ${HOME}/.bashrc && echo 'fi' >> ${HOME}/.bashrc"
    echo Zsh set as default shell!
)

if /i "%APPLY_DOTFILES%"=="Y" (
    echo.
    echo Step 11: Applying dotfiles configuration...
    
    set /p OVERRIDE_P10K="Do you want to override Powerlevel10k config with dotfiles .p10k.zsh? (Y/N): "
    
    if exist "%DOTFILES_DIR%.zshrc" (
        copy /Y "%DOTFILES_DIR%.zshrc" "%USERPROFILE%\.zshrc"
        echo .zshrc applied successfully!
    )
    
    if exist "%DOTFILES_DIR%.bashrc" (
        copy /Y "%DOTFILES_DIR%.bashrc" "%USERPROFILE%\.bashrc"
        echo .bashrc applied successfully!
    )
    
    if exist "%DOTFILES_DIR%.bash_profile" (
        copy /Y "%DOTFILES_DIR%.bash_profile" "%USERPROFILE%\.bash_profile"
        echo .bash_profile applied successfully!
    )
    
    if exist "%DOTFILES_DIR%.gitconfig" (
        copy /Y "%DOTFILES_DIR%.gitconfig" "%USERPROFILE%\.gitconfig"
        echo .gitconfig applied successfully!
    )
    
    if exist "%DOTFILES_DIR%.gitignore" (
        copy /Y "%DOTFILES_DIR%.gitignore" "%USERPROFILE%\.gitignore"
        echo .gitignore applied successfully!
    )
    
    if /i "!OVERRIDE_P10K!"=="Y" (
        if exist "%DOTFILES_DIR%.p10k.zsh" (
            copy /Y "%DOTFILES_DIR%.p10k.zsh" "%USERPROFILE%\.p10k.zsh"
            echo .p10k.zsh applied successfully!
            echo NOTE: This will skip the Powerlevel10k configuration wizard on first launch.
        )
    ) else (
        echo Skipping .p10k.zsh - Configuration wizard will run on first Zsh launch.
    )
    
    if exist "%DOTFILES_DIR%.config" (
        xcopy /E /I /Y "%DOTFILES_DIR%.config" "%USERPROFILE%\.config"
        echo .config directory applied successfully!
    )
    
    echo.
    echo Step 12: Copying aliases.zsh to Oh-My-Zsh custom folder...
    if exist "%DOTFILES_DIR%.oh-my-zsh\custom\aliases.zsh" (
        if not exist "%USERPROFILE%\.oh-my-zsh\custom" mkdir "%USERPROFILE%\.oh-my-zsh\custom"
        copy /Y "%DOTFILES_DIR%.oh-my-zsh\custom\aliases.zsh" "%USERPROFILE%\.oh-my-zsh\custom\aliases.zsh"
        echo aliases.zsh copied successfully!
    )
) else (
    echo Skipping dotfiles application...
)

if /i "%INSTALL_PLUGINS%"=="Y" (
    echo.
    echo Step 13: Installing Oh-My-Zsh custom plugins...
    if exist "%DOTFILES_DIR%oh-my-zsh-plugins.txt" (
        for /f "tokens=*" %%p in (%DOTFILES_DIR%oh-my-zsh-plugins.txt) do (
            echo Installing plugin: %%p
            "%BASH_EXE%" -c "export HOME=/c/Users/%USERNAME% && git clone https://github.com/zsh-users/%%p ${HOME}/.oh-my-zsh/custom/plugins/%%p"
        )
        echo Plugins installed successfully!
    ) else (
        echo WARNING: oh-my-zsh-plugins.txt not found, skipping...
    )
) else (
    echo Skipping Oh-My-Zsh plugins installation...
)

if /i "%IMPORT_SCOOP_PACKAGES%"=="Y" (
    echo.
    echo Step 14: Installing Scoop packages...
    if exist "%DOTFILES_DIR%scoop-packages.json" (
        call scoop import "%DOTFILES_DIR%scoop-packages.json"
        echo Scoop packages installed successfully!
    ) else (
        echo WARNING: scoop-packages.json not found, skipping...
    )
) else (
    echo Skipping Scoop packages import...
)

if /i "%SETUP_SSH%"=="Y" (
    echo.
    echo Step 15: SSH Key Configuration...
    set /p CREATE_SSH_KEY="Do you want to create an SSH RSA key? (Y/N): "
    if /i "!CREATE_SSH_KEY!"=="Y" (
        echo.
        echo Creating SSH RSA key...
        set /p SSH_EMAIL="Enter your email for SSH key: "
        if not exist "%USERPROFILE%\.ssh" mkdir "%USERPROFILE%\.ssh"
        "%BASH_EXE%" -c "export HOME=/c/Users/%USERNAME% && ssh-keygen -t rsa -b 4096 -C '!SSH_EMAIL!' -f ${HOME}/.ssh/id_rsa"
        echo SSH key created successfully!
        echo.
        echo Your public key:
        type "%USERPROFILE%\.ssh\id_rsa.pub"
        echo.
    ) else (
        echo Skipping SSH key creation...
    )
    
    echo.
    echo Copying SSH config from dotfiles...
    if exist "%DOTFILES_DIR%.ssh\config" (
        if not exist "%USERPROFILE%\.ssh" mkdir "%USERPROFILE%\.ssh"
        copy /Y "%DOTFILES_DIR%.ssh\config" "%USERPROFILE%\.ssh\config"
        echo SSH config copied successfully!
    ) else (
        echo WARNING: .ssh/config not found in dotfiles, skipping...
    )
) else (
    echo Skipping SSH configuration...
)

if /i "%INSTALL_WINTERMINAL%"=="Y" (
    echo.
    echo Step 16: Installing Windows Terminal (if not already installed)...
    powershell -Command "& {if (-not (Get-AppxPackage -Name Microsoft.WindowsTerminal)) {Write-Host 'Installing Windows Terminal...'; winget install --id=Microsoft.WindowsTerminal -e --silent} else {Write-Host 'Windows Terminal already installed, checking for updates...'; winget upgrade --id=Microsoft.WindowsTerminal -e --silent}}"
    
    echo.
    echo Step 17: Setting Git Bash as default shell for Windows Terminal...
    set WT_SETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    if exist "%WT_SETTINGS%" (
        echo Windows Terminal detected. Please manually set Git Bash as default in Windows Terminal settings.
        echo Path to use: %GIT_BASH_PATH%
    ) else (
        echo Windows Terminal not found. Skipping...
    )
) else (
    echo Skipping Windows Terminal installation...
)

if /i "%INSTALL_NERDFONT%"=="Y" (
    echo.
    echo Step 18: Installing 0xProto Nerd Font Mono...
    echo Fetching latest Nerd Fonts release...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest'; $asset = $release.assets | Where-Object {$_.name -eq '0xProto.zip'} | Select-Object -First 1; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '%TEMP%\0xProto.zip'}"
    
    echo Extracting font files...
    powershell -Command "Expand-Archive -Path '%TEMP%\0xProto.zip' -DestinationPath '%TEMP%\0xProto' -Force"
    
    echo Installing fonts...
    powershell -Command "& {$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14); Get-ChildItem '%TEMP%\0xProto\*.ttf' | ForEach-Object {$fonts.CopyHere($_.FullName, 0x10)}}"
    
    echo Cleaning up...
    del /Q "%TEMP%\0xProto.zip"
    rmdir /S /Q "%TEMP%\0xProto"
    
    echo.
    echo Configuring Git Bash to use 0xProto Nerd Font Mono...
    powershell -Command "& {$gitBashConfig = @'`n[window]`nFont=0xProtoNFM`n'@; Add-Content -Path '$env:USERPROFILE\.minttyrc' -Value $gitBashConfig}"
    
    echo 0xProto Nerd Font Mono installed and configured successfully!
) else (
    echo Skipping Nerd Font installation...
)

if /i "%INSTALL_ZENBROWSER%"=="Y" (
    echo.
    echo Step 19: Installing Zen Browser...
    echo Fetching latest Zen Browser release...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/zen-browser/desktop/releases/latest'; $asset = $release.assets | Where-Object {$_.name -like '*-specific.installer.exe'} | Select-Object -First 1; if ($asset) {Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '%TEMP%\zen-browser-installer.exe'; Start-Process -FilePath '%TEMP%\zen-browser-installer.exe' -ArgumentList '/S' -Wait} else {Write-Host 'Zen Browser installer not found, trying alternative method...'; winget install --id=Zen-Team.Zen-Browser -e --silent}}"
    
    echo.
    echo Setting Zen Browser as default browser...
    powershell -Command "& {Start-Process ms-settings:defaultapps}"
    echo.
    echo Please manually set Zen Browser as default in the Settings window that opened.
    pause
    
    echo Zen Browser installed successfully!
) else (
    echo Skipping Zen Browser installation...
)

if /i "%INSTALL_APPS%"=="Y" (
    echo.
    echo Step 20: Installing Discord, Steam, Epic Games, and PowerToys...
    
    echo.
    echo Installing Discord...
    winget install --id=Discord.Discord -e --silent
    
    echo.
    echo Installing Steam...
    winget install --id=Valve.Steam -e --silent
    
    echo.
    echo Installing Epic Games Launcher...
    winget install --id=EpicGames.EpicGamesLauncher -e --silent
    
    echo.
    echo Installing PowerToys...
    winget install --id=Microsoft.PowerToys -e --silent
    
    echo Applications installed successfully!
) else (
    echo Skipping applications installation...
)

echo.
echo Step 21: Adding Git Bash to system PATH...
setx PATH "%PATH%;C:\Program Files\Git\bin" /M

if /i "%CREATE_SHORTCUTS%"=="Y" (
    echo.
    echo Step 22: Creating desktop shortcuts...
    set DESKTOP=%USERPROFILE%\Desktop
    powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%DESKTOP%\Git Bash.lnk'); $SC.TargetPath = 'C:\Program Files\Git\git-bash.exe'; $SC.Save()"
    echo Shortcut created successfully!
) else (
    echo Skipping desktop shortcuts creation...
)

echo.
echo ============================================
echo Installation Complete!
echo ============================================
echo.
echo Installed components summary:
if /i "%INSTALL_GIT%"=="Y" echo - Git Bash: C:\Program Files\Git
if /i "%INSTALL_ZSH%"=="Y" echo - Zsh shell
if /i "%INSTALL_OHMYZSH%"=="Y" echo - Oh-My-Zsh
if /i "%INSTALL_P10K%"=="Y" echo - Powerlevel10k theme
if /i "%INSTALL_SCOOP%"=="Y" echo - Scoop package manager: %USERPROFILE%\scoop
if /i "%INSTALL_MINGW%"=="Y" echo - MinGW C++ compiler
if /i "%INSTALL_WINTERMINAL%"=="Y" echo - Windows Terminal
if /i "%INSTALL_NERDFONT%"=="Y" echo - 0xProto Nerd Font Mono
if /i "%INSTALL_ZENBROWSER%"=="Y" echo - Zen Browser
if /i "%INSTALL_APPS%"=="Y" (
    echo - Discord
    echo - Steam
    echo - Epic Games Launcher
    echo - PowerToys
)
echo.
echo IMPORTANT NEXT STEPS:
echo 1. Close this window and open Git Bash from your desktop
if /i "%INSTALL_P10K%"=="Y" (
    if /i "%OVERRIDE_P10K%"=="Y" (
        echo 2. Zsh will start automatically with your custom Powerlevel10k configuration
    ) else (
        echo 2. Zsh will start automatically and Powerlevel10k configuration wizard will run
        echo 3. Follow the Powerlevel10k setup wizard to customize your prompt
    )
)
echo.
echo 4. Install a Nerd Font for best Powerlevel10k experience:
if /i "%INSTALL_NERDFONT%"=="Y" (
    echo    0xProto Nerd Font Mono is already installed!
    echo    Restart Git Bash to see the font changes.
) else (
    echo    https://github.com/ryanoasis/nerd-fonts/releases
)
echo.
echo To verify installations:
echo - Git Bash: git --version
echo - Zsh: zsh --version
echo - Oh-My-Zsh: Check for .oh-my-zsh folder in home directory
echo - C++ compiler: g++ --version
echo - Scoop: scoop --version
echo.
echo ============================================
pause
