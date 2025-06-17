// ABNT2_Fix.cpp - Cyberpunk 2077 ABNT2 Keyboard Fix Plugin
// 
// This RED4ext plugin automatically launches the AutoHotkey script
// that provides ABNT2 keyboard layout support for Cyberpunk 2077.
// 
// The plugin has minimal functionality by design:
// - Only launches the companion AutoHotkey executable
// - No game memory manipulation
// - No network access
// - Transparent operation
//
// Repository: https://github.com/lordekeen/cyberpunk2077-abnt2-fix
// License: MIT

// Dependencies:
// RED4ext.SDK is required for compilation but not included in this repository
// Download from: https://github.com/WopsS/RED4ext.SDK
// Extract to: source/dll/external/RED4ext.SDK/ and uncomment the include below
//#include <RED4ext/RED4ext.hpp>
#include <Windows.h>
#include <filesystem>
#include <string>

// Uncomment the following line if you have RED4ext SDK available
//using namespace RED4ext;

// Plugin entry point - called when Cyberpunk 2077 loads the DLL
BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID)
{
    // Only act when the DLL is being loaded into the process
    if (ul_reason_for_call == DLL_PROCESS_ATTACH)
    {
        // Get the full path to this DLL file
        wchar_t dllPath[MAX_PATH];
        GetModuleFileNameW(hModule, dllPath, MAX_PATH);

        // Construct path to the AutoHotkey executable in the same directory
        // Expected structure: red4ext/plugins/ABNT2_Fix/ABNT2_Fix.dll
        //                                                  /cyberpunk2077_abnt2_fix.exe
        std::filesystem::path exePath = std::filesystem::path(dllPath).parent_path() / L"cyberpunk2077_abnt2_fix.exe";

        // Launch the AutoHotkey script executable
        STARTUPINFOW si = { sizeof(si) };
        PROCESS_INFORMATION pi;

        // Create the process with hidden window (background execution)
        if (CreateProcessW(
            exePath.c_str(),        // Path to executable
            NULL,                   // Command line (none needed)
            NULL,                   // Process security attributes
            NULL,                   // Thread security attributes
            FALSE,                  // Don't inherit handles
            CREATE_NO_WINDOW,       // Hide window - run silently
            NULL,                   // Environment variables (inherit)
            NULL,                   // Working directory (inherit)
            &si,                    // Startup info
            &pi))                   // Process information
        {
            // Clean up process handles (we don't need to track the process)
            CloseHandle(pi.hThread);
            CloseHandle(pi.hProcess);
            
            // Log success for debugging (visible in debug output)
            OutputDebugStringW(L"ABNT2_Fix: Successfully launched cyberpunk2077_abnt2_fix.exe");
        }
        else
        {
            // Log failure if the executable couldn't be started
            OutputDebugStringW(L"ABNT2_Fix: Failed to launch cyberpunk2077_abnt2_fix.exe");
            
            // Get error details for debugging
            DWORD error = GetLastError();
            wchar_t errorMsg[256];
            swprintf_s(errorMsg, L"ABNT2_Fix: CreateProcess failed with error code: %lu", error);
            OutputDebugStringW(errorMsg);
        }
    }

    // Return TRUE to indicate successful DLL initialization
    return TRUE;
}
