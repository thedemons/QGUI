#include-once
#include "_header.au3"

Func QGUICtrlCreateInput($text, $x, $y, $w, $h, $parent = $__LastQGUI)

	If _QGUI_Check($parent) = False Then Return False

	If $w = 0 Or $h = 0 Then Return False

	Local $self = IDispatch()

	$self.__add("data", $text)
	$self.__add("parent", $parent)
	$self.__add("sub")
	$self.__add("state", @SW_SHOW)
	$self.__add("oldstate", @SW_SHOW)
	$self.__add("isfocus", False)
	$self.__add("x", $x)
	$self.__add("y", $y)
	$self.__add("w", $w)
	$self.__add("h", $h)
	$self.__add("data", $text)
	$self.__method("outlineW", "_QGUI_Input_Outline_Width")
	$self.__method("text", "_QGUI_Input_SetData")
	$self.__method("draw", "_QGUI_Input_Draw")
	$self.__method("setfont", "_QGUI_Input_SetFont")
	$self.__method("setpos", "_QGUI_Input_SetPos")

	$self.__add("input")

	GUISwitch(QGUIGetSubHandle($parent))
	$self.__add("rect", QGUICtrlCreateRect($x, $y, $w, $h, $parent))
	$self.rect.sub = $self
	$self.rect.setbound(-1, True, True, False, False)
	$self.rect.onhover = _QGUI_Input_Onhover
	$self.rect.color.bk = $parent.c.bk
	$self.rect.hover.bk = $parent.c.inputbk

;~ 	$self.__add("line", QGUICtrlCreateLine($x, $y + $h - 2, $x + $w, $y + $h, 2))
	$self.__add("line", QGUICtrlCreateRect($x, $y + $h, $w, 1, $parent))

	$self.line.color.bk = 0x994D98B4
;~ 	$self.line.hover.bk = 0x994D98B4

	$self.__add("input", GUICtrlCreateInput($text, $x + 3, $y + 3, $w, $h, -1, $WS_EX_LAYERED))
	GUICtrlSetBkColor(-1, $parent.c.transparent)
	GUICtrlSetColor($self.input, __ARGB2RGB($parent.c.text))
	GUICtrlSetFont(-1, 13, Default, Default, "Segoe UI", $CLEARTYPE_QUALITY)

	$self.__add("handle", GUICtrlGetHandle($self.input))


	$self.__add("color", IDispatch())
	$self.color.__add("parent", $self)
	$self.color.__method("fore", "_QGUI_Input_Color_fore")
	$self.color.__method("bk", "_QGUI_Input_Color_bk")
	$self.color.__method("outline", "_QGUI_Input_Color_outline")

	$self.__add("hover", IDispatch())
	$self.hover.__add("parent", $self)
	$self.hover.__method("bk", "_QGUI_Input_Hover_bk")
	$self.hover.__method("outline", "_QGUI_Input_Hover_outline")


;~ 	$self.__add("hover", $self.label.hover)
;~ 	$self.__add("brush", $self.label.brush)
;~ 	$self.brush.__add("hover", $self.label.brush.hover)

;~ 	$self.brush.fore = $self.label.brush.hover.fore
;~ 	$self.color.bk = 0xFF2D98B4
;~ 	$self.hover.bk = 0xFF4DB8D4

;~ 	$self.hover.outline = 0xFFFFFFFF

	$__LastCtrl = $self

	$parent.ctrls.__add("ctrl", $self)

	Return $self
EndFunc

Func _QGUI_Input_Onhover($self, $isHover)

	If $self.sub.isfocus Then Return

	If $isHover = False Then

		$self.sub.line.ishover = False

	ElseIf $isHover = True Then

		$self.sub.line.ishover = True
	EndIf

EndFunc

Func _QGUI_Input_Draw($self)

	Local $Focus = ($self.parent.focus = $self.handle)

	If $self.parent.msg = $self.rect Or $self.parent.msg = $self.line Then $self.parent.msg = $self

	; click
	If ($Focus Or ($self.rect.ishover And $self.parent.cursor[2] = 1)) And $self.isfocus = False Then

		GUICtrlSetState($self.input, $GUI_FOCUS)
		$self.rect.ishover = True
		$self.line.ishover = True
		$self.parent.focus = $self.handle
		$self.isfocus = True

	ElseIf $self.isfocus And $Focus = False Then

		$self.rect.ishover = -1
		$self.line.ishover = -1
		$self.isfocus = False
	EndIf


	If $self.state <> $self.oldstate Then
		$self.oldstate = $self.state
		$self.rect.state = $self.state
		$self.line.state = $self.state

		GUICtrlSetState($self.input, $self.state = @SW_SHOW ? $GUI_SHOW : ($self.state = @SW_HIDE ? $GUI_HIDE : $GUI_DISABLE))
	EndIf

EndFunc

Func _QGUI_Input_SetFont($self, $fontSize = 13, $fontName = "Segoe UI", $fontStyle = 0)

	GUICtrlSetFont($self.input, $fontSize, Default, $fontStyle, $fontName, $CLEARTYPE_QUALITY)
EndFunc

Func _QGUI_Input_SetPos($self, $x = -1, $y = -1, $w = -1, $h = -1)

;~ 	GUICtrlSetPos($self.input, $x = $x = -1 ? Default : $x + 3, $y = $y = -1 ? Default : $y + 3, $w = $w = -1 ? Default : $w + 3, $h = $h = -1 ? Default : $h + 3)
	GUICtrlSetPos($self.input, $x = -1 ? Default : $x + 3, $y = -1 ? Default : $y + 3, $w = -1 ? Default : $w, $h = -1 ? Default : $h)
	If $x >= 0 Then
		$self.x = $x
		$self.rect.x = $x
		$self.line.x = $x
	EndIf
	If $w >= 0 Then
		$self.w = $w
		$self.rect.w = $w
		$self.line.w = $w
	EndIf
	If $h >= 0 Then
		$self.h = $h
		$self.rect.h = $h
		$self.line.h = $h
	EndIf
	If $y >= 0 Then
		$self.y = $y
		$self.rect.y = $y
		$self.line.y = $y + $self.h
	EndIf
EndFunc

Func _QGUI_Input_SetData($self, $text = GUICtrlRead($self.input))

	If $text = GUICtrlRead($self.input) Then Return $text

	GUICtrlSetData($self.input, $text)
	$self.data = $text

	Return True
EndFunc

Func _QGUI_Input_Color_bk($self, $color)

	$self.parent.rect.color.bk = $color
EndFunc

Func _QGUI_Input_Color_fore($self, $color)

	Local $RGB = __ARGB2RGB($color)

	GUICtrlSetColor($self.parent.input, $RGB)

EndFunc

Func _QGUI_Input_Color_outline($self, $color)

	$self.parent.line.color.bk = $color
EndFunc

Func _QGUI_Input_Hover_bk($self, $color)

	$self.parent.rect.hover.bk = $color
EndFunc

Func _QGUI_Input_Hover_outline($self, $color)

	$self.parent.line.hover.bk = $color
EndFunc

Func _QGUI_Input_Outline_Width($self, $width = 1)

	$self.line.h = $width
	$self.line.setbound
EndFunc
