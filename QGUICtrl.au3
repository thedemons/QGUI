#include-once
#include "_header.au3"

Func QGUICtrlSetData($self, $text)

	If $self = -1 Then $self = $__LastCtrl
	Return Execute("$self.text($text)")

EndFunc

Func QGUICtrlRead($self)

	If $self = -1 Then $self = $__LastCtrl
	$read = Execute("$self.text")

	If @error Then Return False

	Return $read
EndFunc

Func QGUICtrlSetState($self, $state = @SW_SHOW)

	If $self = -1 Then $self = $__LastCtrl
	If $state <> @SW_SHOW And $state <> @SW_HIDE And $state <> @SW_DISABLE Then Return False

	$self.state = $state

EndFunc


Func QGUICtrlSetFont($self, $fontSize = 13, $fontName = -1, $fontStyle = -1)

	If $self = -1 Then $self = $__LastCtrl

	If $fontSize = -1 Then $fontSize = 13
	If $fontName = -1 Then $fontName = "Segoe UI"
	If $fontStyle = -1 Then $fontStyle = 0

	Return Execute("$self.setfont($fontSize, $fontName, $fontStyle)")

EndFunc

Func QGUICtrlSetAllign($self, $allign)

	If $self = -1 Then $self = $__LastCtrl

	Return Execute("$self.allign($allign)")

EndFunc

Func QGUICtrlSetColor($self, $color, $isAutoHover = True)

	If $self = -1 Then $self = $__LastCtrl

	Local $dimColor

	If $isAutoHover Then

		$dimColor = __GetDimColor($color)

		Execute("$self.color.fore($dimColor)")
		QGUICtrlSetHoverColor($self, $color)
	Else
		Execute("$self.color.fore($color)")
	EndIf


EndFunc

Func QGUICtrlSetBkColor($self, $color, $isAutoHover = True)

	If $self = -1 Then $self = $__LastCtrl

	Local $dimColor

	If $isAutoHover Then

		$dimColor = __GetDimColor($color)
		Execute("$self.color.bk($dimColor)")
		QGUICtrlSetHoverBkColor($self, $color)
	Else
		Execute("$self.color.bk($color)")
	EndIf

EndFunc

Func QGUICtrlSetOutlineColor($self, $color, $isAutoHover = True)

	If $self = -1 Then $self = $__LastCtrl

	Local $dimColor

	If $isAutoHover Then

		$dimColor = __GetDimColor($color)
		Execute("$self.color.outline($dimColor)")
		QGUICtrlSetHoverOutlineColor($self, $color)
	Else
		Execute("$self.color.outline($color)")
	EndIf

EndFunc

Func QGUICtrlSetHoverColor($self, $color)

	If $self = -1 Then $self = $__LastCtrl
	Execute("$self.hover.fore($color)")

EndFunc

Func QGUICtrlSetHoverBkColor($self, $color)

	If $self = -1 Then $self = $__LastCtrl
	Execute("$self.hover.bk($color)")

EndFunc

Func QGUICtrlSetHoverOutlineColor($self, $color)

	If $self = -1 Then $self = $__LastCtrl
	Execute("$self.hover.outline($color)")

EndFunc

Func QGUICtrlSetOutlineWidth($self, $width = 1)

	If $self = -1 Then $self = $__LastCtrl
	Execute("$self.outlineW($width)")

EndFunc

Func QGUICtrlSetPos($self, $x = -1, $y = -1, $w = -1, $h = -1)

	If $self = -1 Then $self = $__LastCtrl
	Execute("$self.setpos($x, $y, $w, $h)")

EndFunc

Func QGUICtrlSetBound($self, $x = -1, $y = -1, $w = -1, $h = -1)

	If $self = -1 Then $self = $__LastCtrl
	Execute("$self.setpos($x, $y, $w, $h)")

EndFunc

Func __GetDimColor($color)
	Local $RGB = __ARGB2RGB($color)
	Local $A = __ARGB2A($color) - 0x50

;~ 	If $A < 0x30 Then $a = 0x30

	$color = $A * 0x1000000 + $RGB
;~ 	MsgBox(0,__ARGB2RGB($color),Hex(0xFF000000 + __ARGB2RGB($color)) & @CRLF & Hex($color))

	Return $color
EndFunc