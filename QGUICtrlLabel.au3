#include-once
#include "_header.au3"

Func QGUICtrlCreateLabel($text, $x, $y, $w = 0, $h = 0, $parent = $__LastQGUI)

	If _QGUI_Check($parent) = False Then Return False

	Local $self = IDispatch(), $tLayout

	$self.__add("data")
	$self.__add("sub")
	$self.__add("state", @SW_SHOW)
	$self.__add("parent", $parent)
	$self.__add("x", $x)
	$self.__add("y", $y)
	$self.__add("w", $w)
	$self.__add("h", $h)
	$self.__add("isRect", False)
	$self.__add("isBkTransparent", True)
	$self.__add("font", $parent.font)
	$self.__add("isonhover", -1)
	$self.__add("ishovered", False)
	$self.__add("onhover", False)
	$self.__method("outlineW", "_QGUI_Label_Outline_Width")
	$self.__method("ishover", "_QGUI_Label_Hover")
	$self.__method("setpos", "_QGUI_Label_SetPos")
	$self.__method("allign", "_QGUI_Label_SetAllign")
	$self.__method("setfont", "_QGUI_Label_SetFont")
	$self.__method("text", "_QGUI_Label_SetData")
	$self.__method("draw", "_QGUI_Label_Draw")

	$self.__add("rect")

	$self.__add("mode", $AL_LEFT)
	$self.__add("layout", _GDIPlus_RectFCreate($x, $y, 0, 0))


	$self.__add("color", IDispatch())
	$self.color.__add("parent", $self)
	$self.color.__method("fore", "_QGUI_Label_Color_fore")
	$self.color.__method("bk", "_QGUI_Label_Color_bk")
	$self.color.__method("outline", "_QGUI_Label_Color_outline")

	$self.__add("hover", IDispatch())
	$self.hover.__add("parent", $self)
	$self.hover.__method("fore", "_QGUI_Label_Hover_fore")
	$self.hover.__method("bk", "_QGUI_Label_Hover_bk")
	$self.hover.__method("outline", "_QGUI_Label_Hover_outline")

	$self.__add("brush", IDispatch())
	$self.brush.__add("parent", $self)
	$self.brush.__add("fore")
	$self.brush.__add("bk")

	$self.brush.__add("hover", IDispatch())
	$self.brush.hover.__add("parent", $self)
	$self.brush.hover.__add("fore")
	$self.brush.hover.__add("bk")

	$self.__add("pen", IDispatch())
	$self.pen.__add("parent", $self)
	$self.pen.__add("outline")

	$self.pen.__add("hover", IDispatch())
	$self.pen.hover.__add("parent", $self)
	$self.pen.hover.__add("outline")

	$self.text = $text

	If $self.w = 0 Or $self.h = 0 Then

		$self.rect = QGUICtrlCreateRect($self.layout.X, $self.layout.Y, $self.layout.Width, $self.layout.Height, $parent)
	Else

		$self.rect = QGUICtrlCreateRect($self.x, $self.y, $self.w, $self.h, $parent)
	EndIf

	$self.color.outline = 0
	$self.hover.outline = 0
	$self.color.bk = 0
	$self.hover.bk = 0


	$parent.ctrls.__add("ctrl", $self)

	$__LastCtrl = $self

	Return $self
EndFunc

Func _QGUI_Label_SetData($self, $text = $self.data)

	If $text = $self.data Then Return $self.data

	$self.data = $text
	$self.allign
EndFunc


Func _QGUI_Label_SetFont($self, $fontSize = 13, $fontName = "Segoe UI", $fontStyle = 0)

	Local $hFamily = _GDIPlus_FontFamilyCreate($fontName)

	$self.font = _GDIPlus_FontCreate($hFamily, $fontSize, $fontStyle)
	$self.allign
EndFunc

Func _QGUI_Label_Hover($self, $isHover = Null)

	If $isHover = Null Then Return $self.ishovered

	$self.isonhover = $isHover
EndFunc

Func _QGUI_Label_SetPos($self, $x = -1, $y = -1, $w = -1, $h = -1)

	If $x >= 0 Then $self.x = $x
	If $y >= 0 Then $self.y = $y
	If $w >= 0 Then $self.w = $w
	If $h >= 0 Then $self.h = $h

	$self.allign
EndFunc

Func _QGUI_Label_SetAllign($self, $Allign = -1)

	If $Allign = -1 Then $Allign = $self.mode

	$self.mode = $Allign
	$self.layout.X = $self.x
	$self.layout.Y = $self.y
	$self.layout.Width = 0
	$self.layout.Height = 0

	Local $tLayout = _GDIPlus_GraphicsMeasureString($self.parent.context, $self.data, $self.font, $self.layout, $self.parent.strFormat)

	If IsArray($tLayout) = False Then Return False

	$self.layout = $tLayout[0]

	If $self.w = 0 Or $self.h = 0 Then Return False

	Switch $Allign

		Case $AL_CENTER

			$self.layout.X = $self.x + ($self.w / 2 - $self.layout.Width / 2)

		Case $AL_RIGHT

			$self.layout.X = $self.w - $self.layout.Width

		Case $AL_LEFT

			$self.layout.X = $self.x

	EndSwitch

	$self.layout.Y = $self.y + ($self.h / 2 - $self.layout.Height / 2)

	If $self.layout.X + $self.layout.Width > $self.x + $self.w Then

		$self.layout.X = $self.x
		$self.layout.Width = $self.w
	EndIf

	If $self.layout.Y + $self.layout.Height > $self.y + $self.h Then

		$self.layout.Y = $self.y
		$self.layout.Height = $self.h
	EndIf

EndFunc

Func _QGUI_Label_Draw($self)

	If $self.state = @SW_HIDE Then Return

	Local $color, $colorbk, $outline, $w, $h
	Local $isHover, $parent = $self.parent

	If $self.isonhover == -1 Then

		If $self.state = @SW_DISABLE Then

			$isHover = False
		Else
			If $self.isRect Then

				$isHover = _MouseHover($parent.cursor, $self.x, $self.y, $self.w, $self.h)
			Else
				$isHover = _MouseHover($parent.cursor, $self.layout.X, $self.layout.Y, $self.layout.Width, $self.layout.Height)
			EndIf
		EndIf
	Else
		$isHover = $self.isonhover
	EndIf

	If $isHover Then

		$color = $self.brush.hover.fore = 0 ? $parent.brush.hover.text : $self.brush.hover.fore
		$colorbk = $self.brush.hover.bk
		$outline = $self.pen.hover.outline

	Else

		$color = $self.brush.fore = 0 ? $parent.brush.text : $self.brush.fore
		$colorbk = $self.brush.bk
		$outline = $self.pen.outline
	EndIf


	If $self.isonhover == -1 And $isHover = True Then

		If $parent.cursor[2] = 1 Then $parent.msg = $self

	ElseIf $self.isonhover <> - 1 Then

		If $self.state = @SW_DISABLE Then

			$isHover = False
		Else
			If $self.isRect Then

				$isHover = _MouseHover($parent.cursor, $self.x, $self.y, $self.w, $self.h)
			Else
				$isHover = _MouseHover($parent.cursor, $self.layout.X, $self.layout.Y, $self.layout.Width, $self.layout.Height)
			EndIf
		EndIf

		If $isHover And $parent.cursor[2] = 1 Then $parent.msg = $self
	EndIf

	; call hover function
	If $self.ishovered <> $isHover Then

		$self.ishovered = $isHover
		If $self.onhover <> False Then Call($self.onhover, $self, $isHover)
	EndIf

	If $self.w <= 0 Or $self.h <= 0 Then

		$x = $self.layout.X
		$y = $self.layout.Y
		$w = $self.layout.Width
		$h = $self.layout.Height
	Else
		$x = $self.x
		$y = $self.y
		$w = $self.w
		$h = $self.h
	EndIf


	_GDIPlus_GraphicsDrawStringEx($parent.context, $self.data, $self.font, $self.layout, $parent.strFormat, $color)


EndFunc

Func _QGUI_Label_Color_fore($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.fore)
	$self.parent.brush.fore = _GDIPlus_BrushCreateSolid($color)
EndFunc

Func _QGUI_Label_Color_bk($self, $color)

	$self.parent.rect.color.bk = $color
EndFunc

Func _QGUI_Label_Color_outline($self, $color)

	$self.parent.rect.color.outline = $color
EndFunc

Func _QGUI_Label_Hover_fore($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.hover.fore)
	$self.parent.brush.hover.fore = _GDIPlus_BrushCreateSolid($color)
EndFunc

Func _QGUI_Label_Hover_bk($self, $color)

	$self.parent.rect.hover.bk = $color
EndFunc

Func _QGUI_Label_Hover_outline($self, $color)

	$self.parent.rect.hover.outline = $color
EndFunc


Func _QGUI_Label_Outline_Width($self, $width = 1)
	$self.rect.outlineW = $width
EndFunc

