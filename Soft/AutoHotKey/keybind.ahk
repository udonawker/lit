; hook
;#InstallKeybdHook

; Remap

#z::!F4                 ; Win+z → Alt+F4
;^!z::^F4               ; Win+x → Ctrl+F4
sc029::BS               ; 半角／全角 → BS
sc07B::sc029            ; 無変換 → 半角／全角
;sc079::Esc             ; 変換 → Esc
sc079::^F4              ; 変換 → Ctrl+F4
sc03a::Enter            ; Capslock → Enter
sc070::Del              ; カタカナひらがな → Delete

#v::End                 ; Win+v → End

;vk1Csc079::enter       ; 変換 -> Enter
;vkF2sc070::vkF3sc029   ; カタカナひらがな -> 半角/全角
;vk1Dsc07B::Esc         ; 無変換 -> Esc

^!x::WinMinimize, A     ; Ctrl+Alt+x → アクティブなウィンドウを最小化
;^+e::LButton           ; Ctrl+Shift+e → 左クリック
;^+Space::LButton       ; Ctrl+Shift+Space → 左クリック
vkF2sc070::LButton      ; Shift+Space → 左クリック

;cursor keys
;CapsLock + wasd
;CapsLock & w::send {Up}
;CapsLock & a::send {Left}
;CapsLock & s::send {Down}
;CapsLock & d::send {Right}
;return
