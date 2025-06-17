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

log("Script started. Waiting for " gameExe "...") ; Log script startup and waiting status

Loop {
    if ProcessExist(gameExe) {
        log("Detected Cyberpunk 2077 running. Enabling key remapping.") ; Log when the game is detected and remapping is enabled
        Hotkey("*" keyVK, SendEnglishQuestion, "On")
        ; Wait while the game is running
        while ProcessExist(gameExe)
            Sleep 200
        log("Cyberpunk 2077 closed. Shutting down script.") ; Log when the game closes and script is about to exit
        ExitApp
    }
    Sleep 2000
}

SendEnglishQuestion(*) {
    if GetKeyState("Shift") {
        origClip := ClipboardAll() ; Save original clipboard
        A_Clipboard := "?"
        Sleep 30 ; Wait for clipboard to update
        Send "^v" ; Paste
        Sleep 30
        A_Clipboard := origClip ; Restore original clipboard
        log("Character '?' was sent via clipboard paste")
    } else {
        origClip := ClipboardAll() ; Save original clipboard
        A_Clipboard := "/"
        Sleep 30 ; Wait for clipboard to update
        Send "^v" ; Paste
        Sleep 30
        A_Clipboard := origClip ; Restore original clipboard
        log("Character '/' was sent via clipboard paste")
    }
}

; Accent key handlers
*´::HandleAccent("´")
*~::HandleAccent("~")
*^::HandleAccent("^")

; Vowel key handlers (lower only, * covers both cases, but we check Shift state)
*a::{
    HandleVowel(GetKeyState("Shift") ? "A" : "a")
}
*e::{
    HandleVowel(GetKeyState("Shift") ? "E" : "e")
}
*i::{
    HandleVowel(GetKeyState("Shift") ? "I" : "i")
}
*o::{
    HandleVowel(GetKeyState("Shift") ? "O" : "o")
}
*u::{
    HandleVowel(GetKeyState("Shift") ? "U" : "u")
}

HandleAccent(accent) {
    global waitingForAccent, accentMap
    waitingForAccent := accent
    SetTimer(ClearAccent, -1000) ; reset in 1s
}

HandleVowel(vowel) {
    global waitingForAccent, accentMap
    if waitingForAccent {
        combo := waitingForAccent . vowel
        if accentMap.Has(combo) {
            char := accentMap[combo]
            origClip := ClipboardAll()
            A_Clipboard := char
            Sleep 30
            Send "^v"
            Sleep 30
            A_Clipboard := origClip
            log("Character " char " was sent via clipboard paste")
        } else {
            Send(vowel)
        }
        waitingForAccent := ""
    } else {
        Send(vowel)
    }
}

ClearAccent() {
    global waitingForAccent
    waitingForAccent := ""
}
