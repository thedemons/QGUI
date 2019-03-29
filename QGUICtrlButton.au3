#include-once
#include "_header.au3"

Func QGUICtrlCreateButton($text, $x, $y, $w, $h, $parent = $__LastQGUI)

	If _QGUI_Check($parent) = False Then Return False

	If $w = 0 Or $h = 0 Then Return False

	Local $self = IDispatch()

	$self.__add("id")
	$self.__add("data", $text)
	$self.__add("oldstate", @SW_SHOW)
	$self.__add("state", @SW_SHOW)
	$self.__add("parent", $parent)
	$self.__add("sub")
	$self.__add("x", $x)
	$self.__add("y", $y)
	$self.__add("w", $w)
	$self.__add("h", $h)
	$self.__add("data", $text)
	$self.__method("outlineW", "_QGUI_Button_OutlineWidth")
	$self.__method("ishover", "_QGUI_Button_Hover")
	$self.__method("onhover", "_QGUI_Button_OnHover")
	$self.__method("setfont", "_QGUI_Button_SetFont")
	$self.__method("setpos", "_QGUI_Button_SetPos")
	$self.__method("text", "_QGUI_Button_SetData")
	$self.__method("draw", "_QGUI_Button_Draw")

	$self.__add("label", QGUICtrlCreateLabel($text, $x, $y, $w, $h, $parent))
	$self.label.allign = $AL_CENTER
	$self.label.isRect = True

	$self.__add("color", $self.label.color)
	$self.__add("hover", $self.label.hover)
	$self.__add("brush", $self.label.brush)
	$self.brush.__add("hover", $self.label.brush.hover)

	$self.color.fore = _GDIPlus_BrushGetSolidColor($parent.brush.hover.text)
	$self.hover.fore = _GDIPlus_BrushGetSolidColor($parent.brush.hover.text)
	$self.color.bk = 0xDD2D98B4
	$self.hover.bk = 0xFF2DB8D4

	$self.hover.outline = 0xFFFFFFFF

	$__LastCtrl = $self

	$parent.ctrls.__add("ctrl", $self)

	Return $self
EndFunc

Func _QGUI_Button_Draw($self)

	If $self.parent.msg = $self.label Then $self.parent.msg = $self

	If $self.state <> $self.oldstate Then
		$self.oldstate = $self.state
		$self.label.state = $self.state
	EndIf
EndFunc

Func _QGUI_Button_SetPos($self, $x = -1, $y = -1, $w = -1, $h = -1)

	$self.label.setpos($x, $y, $w, $h)
EndFunc

Func _QGUI_Button_Hover($self, $isHover = -100)
$self.label.ishover
	Return
EndFunc

Func _QGUI_Button_OnHover($self, $Func)

	$self.label.onhover = $Func
EndFunc

Func _QGUI_Button_SetFont($self, $fontSize = 13, $fontName = "Segoe UI", $fontStyle = 0)

	$self.label.setfont($fontSize, $fontName, $fontStyle)
EndFunc

Func _QGUI_Button_SetData($self, $text = $self.label.data)

	If $text = $self.label.data Then Return $text
	$self.label.text = $text
EndFunc

Func _QGUI_Button_OutlineWidth($self, $width = 1)

	$self.label.outlineW = $width

EndFunc