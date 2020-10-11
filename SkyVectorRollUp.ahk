; Window Shading (roll up a window to its title bar) -- by Rajat
; Animation hacks -- by Watcher
; http://www.autohotkey.com
; This script reduces a window to its title bar and then back to its
; original size by pressing a single hotkey.  Any number of windows
; can be reduced in this fashion (the script remembers each).  If the
; script exits for any reason, all "rolled up" windows will be
; automatically restored to their original heights.

; Set the height of a rolled up window here.  The operating system
; probably won't allow the title bar to be hidden regardless of
; how low this number is:
ws_MinHeight = 25
; Should we Animate 1 is yes, 0 is no, animated is slower
ws_Animate = 1
; By What increment (in pixels) does the window roll up, 
; the lower the number the smoother but slower:
ws_RollUpSmoothness = 30
; no sleeping between window operations
SetWinDelay 0
SetTitleMatchMode, 2

; This line will unroll any rolled up windows if the script exits
; for any reason:
; No animation occurs on exit
OnExit, ExitSub
return  ; End of auto-execute section



#z:: ; Change this line to pick a different hotkey.


if WinExist("SkyVector"){
    WinActivate ; use the window found above
	Winset, Alwaysontop, On, A
	}
else
    return
#IfWinActive SkyVector: Flight Planning / Aeronautical Charts

; Below this point, no changes should be made unless you want to
; alter the script's basic functionality.
; Uncomment this next line if this subroutine is to be converted
; into a custom menu item rather than a hotkey.  The delay allows
; the active window that was deactivated by the displayed menu to
; become active again:
;Sleep, 200

WinGet, ws_ID, ID, A
Loop, Parse, ws_IDList, |
{
	IfEqual, A_LoopField, %ws_ID%
	{
		; Match found, so this window should be restored (unrolled):
		StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
        if ws_Animate = 1
        {
            ws_RollHeight = %ws_MinHeight%
            Loop
            {
                If ws_RollHeight >= %ws_Height%
                    Break
                ws_RollHeight += %ws_RollUpSmoothness%
                WinMove, ahk_id %ws_ID%,,,,, %ws_RollHeight%
            }
        }
    	WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
		StringReplace, ws_IDList, ws_IDList, |%ws_ID%
		return
	}
}
WinGetPos,,,, ws_Height, A
ws_Window%ws_ID% = %ws_Height%
ws_IDList = %ws_IDList%|%ws_ID%
ws_RollHeight = %ws_Height%
if ws_Animate = 1
{
    Loop
    {
        If ws_RollHeight <= %ws_MinHeight%
            Break
        ws_RollHeight -= %ws_RollUpSmoothness%
        WinMove, ahk_id %ws_ID%,,,,, %ws_RollHeight%
    }
}
WinMove, ahk_id %ws_ID%,,,,, %ws_MinHeight%
return

ExitSub:
Loop, Parse, ws_IDList, |
{
	if A_LoopField =  ; First field in list is normally blank.
		continue      ; So skip it.
	StringTrimRight, ws_Height, ws_Window%A_LoopField%, 0
	WinMove, ahk_id %A_LoopField%,,,,, %ws_Height%
}
ExitApp  ; Must do this for the OnExit subroutine to actually Exit the script.
