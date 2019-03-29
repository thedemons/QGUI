#include-once
#include "_header.au3"

Func QGUICtrlCreateRect($x, $y, $w, $h, $parent = $__LastQGUI)

	If _QGUI_Check($parent) = False Then Return False

	Local $self = IDispatch(), $tLayout

	$self.__add("sub")
	$self.__add("state", @SW_SHOW)
	$self.__add("parent", $parent)
	$self.__add("x", $x)
	$self.__add("y", $y)
	$self.__add("w", $w)
	$self.__add("h", $h)
	$self.__add("onhover")
	$self.__add("bound", ($w + $h) / 10)
	$self.__add("points")
	$self.__add("isonhover", -1)
	$self.__add("ishovered", False)
	$self.__add("isBkTransparent", False)

	$self.__method("setbound", "_QGUI_Rect_SetBound")
	$self.__method("outlineW", "_QGUI_Rect_Outline_Width")
	$self.__method("setpos", "_QGUI_Rect_SetPos")
	$self.__method("ishover", "_QGUI_Rect_Hover")
	$self.__method("draw", "_QGUI_Rect_Draw")

	$self.__add("color", IDispatch())
	$self.color.__add("parent", $self)
	$self.color.__method("bk", "_QGUI_Rect_Color_bk")
	$self.color.__method("outline", "_QGUI_Rect_Color_outline")

	$self.__add("hover", IDispatch())
	$self.hover.__add("parent", $self)
	$self.hover.__method("bk", "_QGUI_Rect_Hover_bk")
	$self.hover.__method("outline", "_QGUI_Rect_Hover_outline")

	$self.__add("brush", IDispatch())
	$self.brush.__add("parent", $self)
	$self.brush.__add("bk")

	$self.brush.__add("hover", IDispatch())
	$self.brush.hover.__add("parent", $self)
	$self.brush.hover.__add("bk")

	$self.__add("pen", IDispatch())
	$self.pen.__add("parent", $self)
	$self.pen.__add("outline")

	$self.pen.__add("hover", IDispatch())
	$self.pen.hover.__add("parent", $self)
	$self.pen.hover.__add("outline")

	$self.color.bk = 0xDD2D98B4
	$self.hover.bk = 0xFF2DB8D4
	$self.color.outline = 0
	$self.hover.outline = 0

	$self.setbound

	$parent.ctrls.__add("ctrl", $self)

	$__LastCtrl = $self

	Return $self
EndFunc

Func _QGUI_Rect_Draw($self)

	If $self.state = @SW_HIDE Then Return

	Local $colorbk, $outline
	Local $isHover, $parent = $self.parent

;~ 	If $self.isBkTransparent = True Then Return
	If $self.isonhover == -1 Then

		If $self.state = @SW_DISABLE Then

			$isHover = False
		Else
			$isHover = _MouseHover($parent.cursor, $self.x, $self.y, $self.w, $self.h)
		EndIf
	Else
		$isHover = $self.isonhover
	EndIf


	If $isHover Then

		$colorbk = $self.brush.hover.bk
		$outline = $self.pen.hover.outline

		; is click
		If $parent.cursor[2] = 1 Then $parent.msg = $self
	Else

		$colorbk = $self.brush.bk
		$outline = $self.pen.outline
	EndIf

	; call hover function
	If $self.ishovered <> $isHover Then

		$self.ishovered = $isHover
		If $self.onhover <> False Then Call($self.onhover, $self, $isHover)
	EndIf

	_GDIPlus_GraphicsDrawPath($parent.context, $self.points, $outline)
	_GDIPlus_GraphicsFillPath($parent.context, $self.points, $colorbk)
EndFunc

Func _QGUI_Rect_SetBound($self, $bound = -1, $topLeft = True, $topRight = True, $bottomLeft = True, $bottomRight = True)

	If $bound = -1 Then $bound = $self.bound

	If $bound > $self.w / 2 Then $bound = $self.w / 2
	If $bound > $self.h / 2 Then $bound = $self.h / 2

	$self.bound = $bound

	$self.points = __CurveRect($self.x, $self.y, $self.w, $self.h, $bound, $topLeft, $topRight, $bottomLeft, $bottomRight)

EndFunc

Func _QGUI_Rect_SetPos($self, $x = -1, $y = -1, $w = -1, $h = -1)

	If $x >= 0 Then $self.x = $x
	If $y >= 0 Then $self.y = $y
	If $w >= 0 Then $self.w = $w
	If $h >= 0 Then $self.h = $h

	$self.setbound
EndFunc

Func _QGUI_Rect_Hover($self, $isHover = Null)

	If $isHover = Null Then Return $self.ishovered

	$self.isonhover = $isHover
EndFunc

Func _QGUI_Rect_Color_bk($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.bk)
	$self.parent.brush.bk = _GDIPlus_BrushCreateSolid($color)

	$self.parent.isBkTransparent = $color = 0 And _GDIPlus_BrushGetSolidColor($self.parent.brush.hover.bk) = 0
EndFunc

Func _QGUI_Rect_Color_outline($self, $color)

	_GDIPlus_PenDispose($self.parent.pen.outline)
	$self.parent.pen.outline = _GDIPlus_PenCreate($color)
EndFunc

Func _QGUI_Rect_Hover_bk($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.hover.bk)
	$self.parent.brush.hover.bk = _GDIPlus_BrushCreateSolid($color)
	$self.parent.isBkTransparent = $color = 0 And _GDIPlus_BrushGetSolidColor($self.parent.brush.bk) = 0
EndFunc

Func _QGUI_Rect_Hover_outline($self, $color)

	_GDIPlus_PenDispose($self.parent.pen.hover.outline)
	$self.parent.pen.hover.outline = _GDIPlus_PenCreate($color)
EndFunc

Func _QGUI_Rect_Outline_Width($self, $width)

	_GDIPlus_PenSetWidth($self.pen.outline, $width)
	_GDIPlus_PenSetWidth($self.pen.hover.outline, $width)

EndFunc