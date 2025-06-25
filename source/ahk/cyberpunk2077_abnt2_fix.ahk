; cyberpunk2077_keyfix.ahk
; Remaps vkC1 to '?' only while Cyberpunk2077.exe is running
#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

logFile := A_ScriptDir "\cyberpunk2077_abnt2_fix.log"
gameExe := "Cyberpunk2077.exe"
keyVK := "vkC1"

global waitingForAccent := ""
global accentMap := Map(
    "´a", "á", "´e", "é", "´i", "í", "´o", "ó", "´u", "ú",
    "~a", "ã", "~o", "õ",
    "^a", "â", "^e", "ê", "^o", "ô",
    "´A", "Á", "´E", "É", "´I", "Í", "´O", "Ó", "´U", "Ú",
    "~A", "Ã", "~O", "Õ",
    "^A", "Â", "^E", "Ê", "^O", "Ô"
)

log(msg) {
    ; Append a timestamped message to the log file for debugging and tracking script activity
    FileAppend "[" A_Now "] " msg "`n", logFile, "UTF-8"
}

; Clear previous log and start fresh for this session (only if file exists)
if FileExist(logFile)
    FileDelete logFile
log("Script started. Waiting for " gameExe "...") ; Log script startup and waiting status

Loop {
    if ProcessExist(gameExe) {
        log("Detected Cyberpunk 2077 running. Enabling key remapping.") ; Log when the game is detected and remapping is enabled
        Hotkey("*" keyVK, SendEnglishQuestion, "On")
        
        ; Enable accent and vowel hotkeys only while game is running
        Hotkey("*´", HandleAccentAcute, "On")
        Hotkey("*~", HandleAccentTilde, "On") 
        Hotkey("*^", HandleAccentCircumflex, "On")
        Hotkey("~*a", HandleVowelA, "On")
        Hotkey("~*e", HandleVowelE, "On")
        Hotkey("~*i", HandleVowelI, "On")
        Hotkey("~*o", HandleVowelO, "On")
        Hotkey("~*u", HandleVowelU, "On")
        
        ; Wait while the game is running
        while ProcessExist(gameExe)
            Sleep 200
            
        ; Disable all hotkeys when game closes
        Hotkey("*" keyVK, "Off")
        Hotkey("*´", "Off")
        Hotkey("*~", "Off")
        Hotkey("*^", "Off")
        Hotkey("~*a", "Off")
        Hotkey("~*e", "Off")
        Hotkey("~*i", "Off")
        Hotkey("~*o", "Off")
        Hotkey("~*u", "Off")
        
        log("Cyberpunk 2077 closed. Shutting down script.") ; Log when the game closes and script is about to exit
        ExitApp
    }
    Sleep 2000
}

SendEnglishQuestion(*) {
    if GetKeyState("Shift") {
        A_Clipboard := "" ; clear clipboard before setting new value
        Sleep 10 ; short delay to ensure clipboard is clear
        A_Clipboard := "?"
        Sleep 30 ; longer wait for clipboard to update
        Send "^v" ; Paste
        Sleep 30 ; longer delay after paste
        log("Character '?' was sent via clipboard paste")
    } else {
        A_Clipboard := "" ; clear clipboard before setting new value
        Sleep 10 ; short delay to ensure clipboard is clear
        A_Clipboard := "/"
        Sleep 30 ; longer wait for clipboard to update
        Send "^v" ; Paste
        Sleep 30 ; longer delay after paste
        log("Character '/' was sent via clipboard paste")
    }
}

; Accent key handler functions
HandleAccentAcute(*) {
    HandleAccent("´")
}

HandleAccentTilde(*) {
    HandleAccent("~")
}

HandleAccentCircumflex(*) {
    HandleAccent("^")
}

; Vowel key handler functions
HandleVowelA(*) {
    HandleVowel(GetKeyState("Shift") ? "A" : "a")
}

HandleVowelE(*) {
    HandleVowel(GetKeyState("Shift") ? "E" : "e")
}

HandleVowelI(*) {
    HandleVowel(GetKeyState("Shift") ? "I" : "i")
}

HandleVowelO(*) {
    HandleVowel(GetKeyState("Shift") ? "O" : "o")
}

HandleVowelU(*) {
    HandleVowel(GetKeyState("Shift") ? "U" : "u")
}

HandleAccent(accent) {
    global waitingForAccent, accentMap
    waitingForAccent := accent
    SetTimer(ClearAccent, -1500) ; wait before clearing accent state
}

HandleVowel(vowel) {
    global waitingForAccent, accentMap
    if waitingForAccent {
        combo := waitingForAccent . vowel
        if accentMap.Has(combo) {
            waitingForAccent := "" ; clear accent state immediately
            Send "{Backspace}" ; suppress the original key press
            char := accentMap[combo]
            A_Clipboard := "" ; clear clipboard before setting new value
            Sleep 10 ; short delay to ensure clipboard is clear
            A_Clipboard := char
            Sleep 30 ; longer delay to ensure clipboard is fully updated
            Send "^v"
            Sleep 30 ; longer delay to ensure paste completes
            log("Character " char " was sent via clipboard paste")
        } else {
            waitingForAccent := ""
        }
    }
}

ClearAccent() {
    global waitingForAccent
    waitingForAccent := ""
}
