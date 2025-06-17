#!/usr/bin/env pwsh
# Build script for Cyberpunk 2077 ABNT2 Fix
# This script compiles both the DLL and AutoHotkey executable

param(
    [Parameter()]
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",
    
    [Parameter()]
    [switch]$Clean,
    
    [Parameter()]
    [switch]$Package,
    
    [Parameter()]
    [switch]$Help
)

function Show-Help {
    Write-Host @"
Cyberpunk 2077 ABNT2 Fix Build Script

Usage: ./build.ps1 [OPTIONS]

OPTIONS:
    -Configuration <Debug|Release>  Build configuration (default: Release)
    -Clean                          Clean build directories before building
    -Package                        Create a release package after building
    -Help                          Show this help message

Examples:
    ./build.ps1                     # Build Release configuration
    ./build.ps1 -Configuration Debug -Clean  # Clean and build Debug
    ./build.ps1 -Package           # Build and create package

Requirements:
    - Visual Studio 2019/2022 or Build Tools
    - CMake 3.15+
    - AutoHotkey v2.0 (for compilation)
    - RED4ext.SDK in source/dll/external/

"@
}

function Test-Prerequisites {
    Write-Host "🔍 Checking prerequisites..." -ForegroundColor Cyan
    
    # Check CMake
    try {
        $cmakeVersion = cmake --version | Select-Object -First 1
        Write-Host "✅ CMake found: $cmakeVersion" -ForegroundColor Green
    }
    catch {
        Write-Error "❌ CMake not found. Please install CMake 3.15+ and add it to PATH."
        exit 1
    }
    
    # Check Visual Studio Build Tools
    try {
        $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
        if (Test-Path $vswhere) {
            $vsInfo = & $vswhere -latest -property displayName
            Write-Host "✅ Visual Studio found: $vsInfo" -ForegroundColor Green
        }
        else {
            Write-Warning "⚠️ Visual Studio not detected via vswhere. Make sure build tools are available."
        }
    }
    catch {
        Write-Warning "⚠️ Could not detect Visual Studio. Build may fail."
    }
      # Check RED4ext SDK
    $sdkPath = "source/dll/external/RED4ext.SDK/include"
    if (Test-Path $sdkPath) {
        Write-Host "✅ RED4ext.SDK found" -ForegroundColor Green
    }
    else {
        Write-Host "" 
        Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Red
        Write-Host "⚠️  RED4ext.SDK NOT FOUND" -ForegroundColor Red
        Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Red
        Write-Host ""
        Write-Host "The RED4ext.SDK is required but not found at:" -ForegroundColor Yellow
        Write-Host "  $sdkPath" -ForegroundColor Gray
        Write-Host ""
        Write-Host "📥 DOWNLOAD OPTIONS:" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Option 1 - Git Submodule (Recommended):" -ForegroundColor White
        Write-Host "  git submodule add https://github.com/WopsS/RED4ext.SDK.git source/dll/external/RED4ext.SDK" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Option 2 - Manual Download:" -ForegroundColor White
        Write-Host "  1. Visit: https://github.com/WopsS/RED4ext.SDK" -ForegroundColor Gray
        Write-Host "  2. Download/clone the repository" -ForegroundColor Gray
        Write-Host "  3. Extract to: source/dll/external/RED4ext.SDK/" -ForegroundColor Gray
        Write-Host ""
        Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Red
        Write-Error "❌ Cannot build DLL without RED4ext.SDK"
        exit 1
    }
    
    # Check AutoHotkey source
    if (Test-Path "source/ahk/cyberpunk2077_abnt2_fix.ahk") {
        Write-Host "✅ AutoHotkey source found" -ForegroundColor Green
    }
    else {
        Write-Error "❌ AutoHotkey source not found at source/ahk/cyberpunk2077_abnt2_fix.ahk"
        exit 1
    }
}

function Build-DLL {
    param([string]$Config)
    
    Write-Host "🔨 Building DLL ($Config)..." -ForegroundColor Cyan
    
    $buildDir = "source/dll/build"
    
    if ($Clean -and (Test-Path $buildDir)) {
        Write-Host "🧹 Cleaning build directory..." -ForegroundColor Yellow
        Remove-Item $buildDir -Recurse -Force
    }
    
    if (!(Test-Path $buildDir)) {
        New-Item -ItemType Directory -Path $buildDir | Out-Null
    }
    
    Push-Location $buildDir
    
    try {
        # Configure
        Write-Host "⚙️ Configuring CMake..." -ForegroundColor Blue
        cmake .. -DCMAKE_BUILD_TYPE=$Config
        if ($LASTEXITCODE -ne 0) {
            throw "CMake configuration failed"
        }
        
        # Build
        Write-Host "🔨 Compiling..." -ForegroundColor Blue
        cmake --build . --config $Config
        if ($LASTEXITCODE -ne 0) {
            throw "Compilation failed"
        }
        
        $dllPath = "bin/$Config/ABNT2_Fix.dll"
        if (Test-Path $dllPath) {
            Write-Host "✅ DLL built successfully: $dllPath" -ForegroundColor Green
            return Resolve-Path $dllPath
        }
        else {
            throw "DLL not found after build"
        }
    }
    finally {
        Pop-Location
    }
}

function Build-AutoHotkey {
    Write-Host "🔨 Building AutoHotkey executable..." -ForegroundColor Cyan
    
    # Check for AutoHotkey installation
    $ahkPaths = @(
        "${env:ProgramFiles}\AutoHotkey\v2\AutoHotkey.exe",
        "${env:ProgramFiles(x86)}\AutoHotkey\v2\AutoHotkey.exe",
        "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"
    )
    
    $ahkExe = $null
    foreach ($path in $ahkPaths) {
        if (Test-Path $path) {
            $ahkExe = $path
            break
        }
    }
    
    if (!$ahkExe) {
        Write-Warning "⚠️ AutoHotkey v2.0 not found. Skipping executable compilation."
        Write-Host "   Download from: https://www.autohotkey.com/download/" -ForegroundColor Yellow
        Write-Host "   Or compile manually using the AutoHotkey compiler." -ForegroundColor Yellow
        return $null
    }
    
    $sourceScript = "source/ahk/cyberpunk2077_abnt2_fix.ahk"
    $outputExe = "cyberpunk2077_abnt2_fix.exe"
    
    # For now, just copy the source (user will need to compile manually with Ahk2Exe)
    Write-Host "📋 AutoHotkey source ready for compilation" -ForegroundColor Green
    Write-Host "   Source: $sourceScript" -ForegroundColor Yellow
    Write-Host "   Use Ahk2Exe.exe to compile to: $outputExe" -ForegroundColor Yellow
    
    return $sourceScript
}

function Create-Package {
    param([string]$DllPath, [string]$AhkSource)
    
    Write-Host "📦 Creating release package..." -ForegroundColor Cyan
    
    $packageDir = "release/ABNT2_Fix"
    
    if (Test-Path "release") {
        Remove-Item "release" -Recurse -Force
    }
    
    New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
    
    # Copy DLL
    if ($DllPath -and (Test-Path $DllPath)) {
        Copy-Item $DllPath $packageDir
        Write-Host "✅ Copied DLL to package" -ForegroundColor Green
    }
    
    # Copy documentation
    $docs = @("README.md", "LICENSE", "CHANGELOG.md", "SECURITY_TRANSPARENCY.md")
    foreach ($doc in $docs) {
        if (Test-Path $doc) {
            Copy-Item $doc "release/"
        }
    }
    
    # Create installation guide
    $installGuide = @"
# Installation Guide

## Quick Install
1. Copy the 'ABNT2_Fix' folder to: Cyberpunk 2077\red4ext\plugins\
2. Make sure you have both files:
   - ABNT2_Fix.dll
   - cyberpunk2077_abnt2_fix.exe (compile from source/ahk/)
3. Launch Cyberpunk 2077

## Manual Compilation
If cyberpunk2077_abnt2_fix.exe is missing:
1. Install AutoHotkey v2.0
2. Use Ahk2Exe.exe to compile source/ahk/cyberpunk2077_abnt2_fix.ahk
3. Place the resulting .exe in the ABNT2_Fix folder

For more details, see README.md
"@
    
    $installGuide | Out-File -FilePath "release/INSTALLATION.txt" -Encoding utf8
    
    # Calculate checksums
    if ($DllPath -and (Test-Path $DllPath)) {
        $dllHash = Get-FileHash $DllPath -Algorithm SHA256
        $checksums = "ABNT2_Fix.dll: $($dllHash.Hash)"
        $checksums | Out-File -FilePath "release/CHECKSUMS.txt" -Encoding utf8
    }
    
    Write-Host "✅ Package created in 'release/' directory" -ForegroundColor Green
    Write-Host "📁 Contents:" -ForegroundColor Yellow
    Get-ChildItem "release" -Recurse | ForEach-Object {
        Write-Host "   $($_.FullName.Replace((Get-Location).Path + '\release\', ''))" -ForegroundColor Gray
    }
}

function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Write-Host "🎮 Cyberpunk 2077 ABNT2 Fix Build Script" -ForegroundColor Magenta
    Write-Host "================================================" -ForegroundColor Magenta
    
    Test-Prerequisites
    
    $dllPath = Build-DLL -Config $Configuration
    $ahkSource = Build-AutoHotkey
    
    if ($Package) {
        Create-Package -DllPath $dllPath -AhkSource $ahkSource
    }
    
    Write-Host ""
    Write-Host "🎉 Build completed successfully!" -ForegroundColor Green
    Write-Host "DLL: $dllPath" -ForegroundColor Yellow
    if ($ahkSource) {
        Write-Host "AHK: $ahkSource (ready for compilation)" -ForegroundColor Yellow
    }
    
    if ($Package) {
        Write-Host "Package: release/" -ForegroundColor Yellow
    }
}

# Run main function
Main
