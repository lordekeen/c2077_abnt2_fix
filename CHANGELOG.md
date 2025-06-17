# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release preparation
- GitHub repository setup

## [1.0.0] - 2025-06-16

### Added
- ABNT2 keyboard layout support for Cyberpunk 2077
- Automatic game detection and activation
- Key remapping for `?/` key (vkC1)
- Portuguese accent support (á, é, í, ó, ú, ã, õ, â, ê, ô)
- AutoHotkey v2.0 script implementation
- RED4ext DLL for automatic launcher
- Comprehensive logging system
- Clipboard-based character insertion for game compatibility

### Features
- **Automatic Activation**: Mod activates only when Cyberpunk 2077 is running
- **Transparent Operation**: Works silently in background
- **Full Accent Support**: All Portuguese diacritical marks supported
- **Key Combinations**: Proper handling of Shift+key combinations
- **Timeout System**: Accent combinations reset after 1 second
- **Error Handling**: Robust error handling and logging

### Technical Details
- Built with AutoHotkey v2.0
- Uses RED4ext framework for DLL injection
- CMake build system for DLL compilation
- UTF-8 logging support
- Process monitoring for game detection

### Compatibility
- Windows 10/11
- Cyberpunk 2077 (all versions with REDmod support)
- ABNT2 keyboard layout
- Portuguese language typing

---

## Release Notes Template

### [Version] - YYYY-MM-DD

#### Added
- New features added in this release

#### Changed
- Changes in existing functionality

#### Deprecated
- Soon-to-be removed features

#### Removed
- Features removed in this release

#### Fixed
- Bug fixes

#### Security
- Security improvements
