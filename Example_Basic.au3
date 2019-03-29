
#include "QGUI.au3"

Local $GuiW = 500
Local $GuiH = 300

$QGUI = QGUICreate("QGUI design", $GuiW, $GuiH)

$lbInfo = QGUICtrlCreateLabel("QGUI design example", 0, 40, $GuiW, 50)

QGUICtrlSetColor(-1, 0xFF7BC412)	; color is ARGB
QGUICtrlSetFont(-1, 20) 			; QGUICtrlSetFont($ctrl, $fontSize, $fontName, $fontStyle)
QGUICtrlSetAllign(-1, $AL_CENTER)	; label allign: $AL_CENTER, $AL_LEFT, $AL_RIGHT

$lbUser = QGUICtrlCreateLabel("Username", 50,  120)
$lbPass = QGUICtrlCreateLabel("Password", 50,  155)

$inputUser = QGUICtrlCreateInput("", 150, 120 , 170, 25)
$inputPass = QGUICtrlCreateInput("", 150, 155, 170, 25)
	QGUICtrlSetOutlineWidth(-1, 5)

$btnLogin = QGUICtrlCreateButton("LOGIN", 350, 115, 100, 70)
	QGUICtrlSetOutlineWidth(-1, 3)
	QGUICtrlSetFont(-1, 15)

$Logo = QGUICtrlCreateLabel("QGUI", $GuiW - 55, $GuiH - 35)
	QGUICtrlSetFont(-1, 12, -1, 1)
	QGUICtrlSetHoverColor(-1, 0xFF000000)
	QGUICtrlSetHoverBkColor(-1, 0xFF7BC412)
	QGUICtrlSetOutlineColor(-1, 0xFF7BC412)

QGUISetState()

; *NOTE: QGUICtrlSetColor($ctrl, $color, $isAutoHover = True)
;		$isAutoHover = True mean it's auto pick the hover color
;			same for QGUICtrlSetBkColor() and QGUICtrlSetOutlineColor()



; this will show fps (for testing)
$QGUI.debug.fps.state = @SW_SHOW

While 1

	QGUIDraw()

	Switch QGUIGetMsg()

		Case -3
			Exit

		Case $Logo
			ShellExecute("https://www.facebook.com/spam.work.thedemons")

		Case $btnLogin
			MsgBox(0,"", QGUICtrlRead($inputUser) & @CRLF & QGUICtrlRead($inputPass))

	EndSwitch

WEnd
