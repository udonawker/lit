; hook
;#InstallKeybdHook

; Remap

#z::!F4                 ; Win+z �� Alt+F4
;^!z::^F4               ; Win+x �� Ctrl+F4
sc029::BS               ; ���p�^�S�p �� BS
sc07B::sc029            ; ���ϊ� �� ���p�^�S�p
;sc079::Esc             ; �ϊ� �� Esc
sc079::^F4              ; �ϊ� �� Ctrl+F4
sc03a::Enter            ; Capslock �� Enter
sc070::Del              ; �J�^�J�i�Ђ炪�� �� Delete

#v::End                 ; Win+v �� End

;vk1Csc079::enter       ; �ϊ� -> Enter
;vkF2sc070::vkF3sc029   ; �J�^�J�i�Ђ炪�� -> ���p/�S�p
;vk1Dsc07B::Esc         ; ���ϊ� -> Esc

^!x::WinMinimize, A     ; Ctrl+Alt+x �� �A�N�e�B�u�ȃE�B���h�E���ŏ���
;^+e::LButton           ; Ctrl+Shift+e �� ���N���b�N
;^+Space::LButton       ; Ctrl+Shift+Space �� ���N���b�N
vkF2sc070::LButton      ; Shift+Space �� ���N���b�N

;cursor keys
;CapsLock + wasd
;CapsLock & w::send {Up}
;CapsLock & a::send {Left}
;CapsLock & s::send {Down}
;CapsLock & d::send {Right}
;return
