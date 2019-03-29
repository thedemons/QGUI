#include-once
#include "_header.au3"

; Available functions ===============================================
;
;
;
; QGUICreate($title = "", $width = 800, $height = 600, $left = -1, $top = -1)
;
; QGUISetState($SW = @SW_SHOW, $QGUI = $__LastQGUI)
;
; QGUIGetMsg($QGUI = $__LastQGUI)
;
; QGUIDraw($QGUI = $__LastQGUI)
;
; QGUIGetHandle($QGUI = $__LastQGUI) ; return gui handle
;
; QGUISetTheme($self, $theme = "dark") ; $them = "dark", "light"
;
;
;
; ## control ##
;
;	QGUICtrlCreateLabel($text, $x, $y, $w = 0, $h = 0, $parent = $__LastQGUI)
;
;	QGUICtrlCreateRect($x, $y, $w, $h, $parent = $__LastQGUI)
;
;	QGUICtrlCreateInput($text, $x, $y, $w, $h, $parent = $__LastQGUI)
;
;	QGUICtrlCreateButton($text, $x, $y, $w, $h, $parent = $__LastQGUI)
;
;
;
; 	QGUICtrlSetData($ctrl, $data) ; ==> set control data
;
; 	QGUICtrlRead($ctrl)			; ==> read control data
;
; 	QGUICtrlSetState($ctrl, $state = @SW_SHOW)
;
; 	QGUICtrlSetPos($self, $x = -1, $y = -1, $w = -1, $h = -1)
;
; 	QGUICtrlSetFont($ctrl, $fontSize = 13, $fontName = "Segoe UI", $fontStyle = 0) ; $fontStyle: 0 = normal, 1 = bold, 2 = italic, 4 = underline, 5 = strike
;
; 	QGUICtrlSetAllign($ctrl, $allign) ; ==> set control allign
; 							   $allign = $AL_LEFT, $AL_TOP, $AL_CENTER
;
;
;
; ## colors ##
;
; 	QGUICtrlSetColor($ctrl, $color, $isAutoHover = True) ; set control color
;									$isAutoHover = True mean auto create hover color
;
; 	QGUICtrlSetBkColor($ctrl, $color, $isAutoHover = True) ; set bk color, same as above
;
; 	QGUICtrlSetOutlineColor($ctrl, $color, $isAutoHover = True) ; set outline color
;
; 	QGUICtrlSetHoverColor($self, $color)
;
; 	QGUICtrlSetHoverBkColor($self, $color)
;
; 	QGUICtrlSetHoverOutlineColor($self, $color)
;
; 	QGUICtrlSetOutlineWidth($self, $width = 1) ; set outline width
;
;
; ==========================================================================


Func QGUICreate($title = "", $w = 800, $h = 600, $l = -1, $t = -1)

	Local $self = IDispatch(), $GUI, $SubGUI
	Local $hHBitmap, $DC_obj

	; gui
	$self.__add("w", $w)
	$self.__add("h", $h)
	$self.__add("cursor")
	$self.__add("indexGUI")
	$self.__add("indexSubGUI")
	$self.__add("font")
	$self.__add("focus")
	$self.__add("msg", -1)
	$self.__method("gui", "_QGUI_GUI")

	$GUI = GUICreate("", $w, $h, $l, $t, $WS_POPUP)
	$self.indexGUI = _ArrayAppend($__AllGUI, $GUI)

	; sub gui, for input and editbox
	$self.__method("subgui", "_QGUI_SubGUI")

	$SubGUI = GUICreate("", $w, $h, 0, 0, $WS_POPUP, $WS_EX_MDICHILD + $WS_EX_LAYERED, $GUI)

	$self.indexSubGUI = _ArrayAppend($__AllSubGUI, $SubGUI)

	; colors
	$self.__add("color", IDispatch())
	$self.color.__add("parent", $self)
	$self.color.__add("bk")
	$self.color.__method("text", "_QGUI_Color_text")
	$self.color.__method("fore", "_QGUI_Color_fore")
	$self.color.__method("title", "_QGUI_Color_title")
	$self.color.__method("btn", "_QGUI_Color_btn")
	; colors
	$self.__add("color", IDispatch())
	$self.color.__add("parent", $self)
	$self.color.__add("bk")
	$self.color.__method("text", "_QGUI_Color_text")
	$self.color.__method("fore", "_QGUI_Color_fore")
	$self.color.__method("title", "_QGUI_Color_title")
	$self.color.__method("btn", "_QGUI_Color_btn")

	; hover color
	$self.__add("hover", IDispatch())
	$self.hover.__add("parent", $self)
	$self.hover.__method("text", "_QGUI_Hover_text")

	; brush
	$self.__add("brush", IDispatch())
	$self.brush.__add("parent", $self)
	$self.brush.__add("text")
	$self.brush.__add("title")
	$self.brush.__add("btn")

	; brush hover
	$self.brush.__add("hover", IDispatch())
	$self.brush.hover.__add("text")

	; pen
	$self.__add("pen", IDispatch())
	$self.pen.__add("parent", $self)
	$self.pen.__add("fore")

	; pen
	$self.__add("c", IDispatch())
	$self.c.__add("parent", $self)
	$self.c.__add("inputbk")
	$self.c.__add("text")
	$self.c.__add("bk")
	$self.c.__add("transparent")

	$self.c.__add("hover", IDispatch())
	$self.c.hover.__add("inputbk")

	; graphics
	$self.__add("strFormat", _GDIPlus_StringFormatCreate())

    $self.__add("hDC", _WinAPI_GetDC($GUI))
    $hHBitmap = _WinAPI_CreateCompatibleBitmap($self.hDC, $self.w, $self.h)

    $self.__add("buffer", _WinAPI_CreateCompatibleDC($self.hDC))
    _WinAPI_SelectObject($self.buffer, $hHBitmap)

    $self.__add("context", _GDIPlus_GraphicsCreateFromHDC($self.buffer))
    _GDIPlus_GraphicsSetSmoothingMode($self.context, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
    _GDIPlus_GraphicsSetPixelOffsetMode($self.context, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)

	; ==

	$self.__add("ctrls", IDispatch())
	$self.__method("theme", "QGUISetTheme")
	$self.theme = $_THEME_DARK

	; gui title
	$self.__add("title", _QGUI_Title($self))
	$self.title.text = $title

	; debug
	$self.__add("debug", IDispatch())
	$self.debug.__add("fps", QGUICtrlCreateLabel("", 5, $self.title.h + 5, 0, 0, $self))
	$self.debug.__add("ctrls", QGUICtrlCreateLabel("", 5, $self.title.h + 25, 0, 0, $self))
	$self.debug.__add("time", TimerInit())
	$self.debug.__add("fpstime", TimerInit())

	$self.debug.fps.state = @SW_HIDE
	$self.debug.ctrls.state = @SW_HIDE

	QGUICtrlSetFont($self.debug.fps, 11)
	QGUICtrlSetFont($self.debug.ctrls, 11)

	$__LastQGUI = $self

	Return $self

EndFunc


Func QGUIGetMsg($self = $__LastQGUI)

	If _QGUI_Check($self) = False Then Return False

	Local $msg = $self.msg
	$self.msg = -1

	Return $msg
EndFunc

Func QGUISetState($SW = @SW_SHOW, $QGUI = $__LastQGUI)

	If _QGUI_Check($QGUI) = False Then Return False

	GUISetState($SW, QGUIGetHandle($QGUI))
	GUISetState($SW, QGUIGetSubHandle($QGUI))
EndFunc

Func QGUIDraw($self = $__LastQGUI)

	If _QGUI_Check($self) = False Then Return print("QGUIDraw() called with wrong parameter", 1)

	Local $GUI = QGUIGetHandle($self)
	Local $SubGUI = QGUIGetSubHandle($self)
	Local $cursor = GUIGetCursorInfo($GUI)

	If IsArray($cursor) Then $self.cursor = $cursor

	$self.focus = ControlGetFocus($SubGUI)
	$self.focus = ControlGetHandle($SubGUI, "", $self.focus)

	$self.debug.time = TimerInit()

	; clear
;~ 	_WinAPI_BitBlt($self.buffer, 0, 0, $self.w, $self.h, $self.buffer, 0, 0, 0)

	_GDIPlus_GraphicsClear($self.context, $self.color.bk)

;~ 	$lb.draw
	$self.debug.fps.draw
	$self.title.draw

	For $ctrl In $self.ctrls.__keys

		Execute("$ctrl.draw")
	Next

;~ 	If $self.title.isDrag And $self.msg = $self.title.btnMin Or $self.msg = $self.title.btnClose Then $self.msg = -1
	Switch $self.msg

		Case $self.title.btnClose
			$self.msg = -3

		Case $self.title.btnMin
			GUISetState(@SW_MINIMIZE, $GUI)
			$self.msg = -1
	EndSwitch

	If $self.msg = -1 Then

;~ 		$msg = GUIGetMsg(1)
;~ 		If UBound($msg) >= 2 And $msg[1] = $GUI Then $self.msg = $msg[0]
	EndIf

	; draw
	_WinAPI_BitBlt($self.hDC, 0, 0, $self.w, $self.h, $self.buffer, 0, 0, $SRCCOPY)

	If $self.debug.fps.state = @SW_SHOW And TimerDiff($self.debug.fpstime) > 100 Then
		$self.debug.fps.text = "FPS     " & Round(1000 / TimerDiff($self.debug.time))
		$self.debug.fpstime = TimerInit()

	ElseIf $self.debug.ctrls.state = @SW_SHOW Then
		$self.debug.ctrls.text = "Ctrls   " & UBound($self.ctrls.__keys)

	EndIf
EndFunc

Func _QGUI_Title($parent)

	Local $self = IDispatch()

	$self.__add("parent", $parent)
	$self.__add("text")
	$self.__add("h", 30)
	$self.__add("dragX")
	$self.__add("dragY")
	$self.__add("isDrag", False)
	$self.__method("draw", "_QGUI_Title_Draw")
	$self.__method("text", "_QGUI_Title_SetData")
	$self.__method("allign", "_QGUI_Title_Allign")

	$self.__add("label", QGUICtrlCreateLabel("Test title", 5, 0, $parent.w, $self.h, $parent))
	$self.__add("btnMin", QGUICtrlCreateButton("–", $parent.w - $self.h * 2 - 1, 1, $self.h, $self.h-2, $parent))
	$self.__add("btnClose", QGUICtrlCreateButton("⬤", $parent.w - $self.h - 1, 1, $self.h, $self.h-2, $parent))

	$self.btnMin.color.bk = _GDIPlus_BrushGetSolidColor($parent.brush.title)
	$self.btnMin.hover.bk = _GDIPlus_BrushGetSolidColor($parent.brush.btn)
	$self.btnMin.hover.outline = 0

	$self.btnClose.color.fore = 0xBBD50844
	$self.btnClose.hover.fore = 0xFFD50844
	$self.btnClose.hover.outline = 0
	$self.btnClose.color.bk = _GDIPlus_BrushGetSolidColor($parent.brush.title)
	$self.btnClose.hover.bk = _GDIPlus_BrushGetSolidColor($parent.brush.btn)


	$self.allign = $AL_CENTER

	Return $self
EndFunc

Func _QGUI_Title_SetData($self, $text)

	$self.label.text = $text
EndFunc

Func _QGUI_Title_Allign($self, $Allign)

	$self.label.allign = $Allign
EndFunc

Func _QGUI_Title_Draw($self)

	Local $parent = $self.parent


	; drag gui
	If $self.isDrag = False And _MouseHover($parent.cursor, 0, 0, $parent.w, $self.h) And $parent.cursor[2] = 1 Then

		$self.dragX = $parent.cursor[0]
		$self.dragY = $parent.cursor[1]
		$self.isDrag = True
	EndIf

	If $self.isDrag Then
		$pMouse = MouseGetPos()

		If IsArray($pMouse) Then

			; move window
			WinMove(QGUIGetHandle($parent), "", $pMouse[0] - $self.dragX, $pMouse[1] - $self.dragY)

			If $parent.cursor[2] = 0 Then $self.isDrag = False
		EndIf

	EndIf

	_GDIPlus_GraphicsFillRect($parent.context, 0, 0, $parent.w, $self.h, $parent.brush.title) ; title bk
	_GDIPlus_GraphicsDrawRect($parent.context, 0, 0, $parent.w, $parent.h, $parent.pen.fore) ; outline

EndFunc

; color ==========================================================
Func _QGUI_Color_btn($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.btn)
	$self.parent.brush.btn = _GDIPlus_BrushCreateSolid($color)
EndFunc

Func _QGUI_Color_text($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.text)
	$self.parent.brush.text = _GDIPlus_BrushCreateSolid($color)
EndFunc

Func _QGUI_Color_fore($self, $color)

	_GDIPlus_PenDispose($self.parent.pen.fore)
	$self.parent.pen.fore = _GDIPlus_PenCreate($color)
EndFunc

Func _QGUI_Color_title($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.title)
	$self.parent.brush.title = _GDIPlus_BrushCreateSolid($color)
EndFunc


; hover ===========================================================

Func _QGUI_Hover_text($self, $color)

	_GDIPlus_BrushDispose($self.parent.brush.hover.text)
	$self.parent.brush.hover.text = _GDIPlus_BrushCreateSolid($color)
EndFunc


; handle and gui ====================================================================
Func QGUIGetHandle($self = $__LastQGUI)

	If _QGUI_Check($self) = False Then Return print("QGUIGetHandle() called with wrong parameter", 1)

	If $self.indexGUI < UBound($__AllGUI) Then Return $__AllGUI[$self.indexGUI]

	Return False
EndFunc

Func QGUIGetSubHandle($self, $gui = False)

	If _QGUI_Check($self) = False Then Return print("QGUIGetSubHandle() called with wrong parameter", 1)

	If $self.indexSubGUI < UBound($__AllSubGUI) Then Return $__AllSubGUI[$self.indexSubGUI]

	Return False
EndFunc

Func QGUISetTheme($self, $theme = $_THEME_DARK)

	Local $hFamily
	Switch $theme

		Case $_THEME_DARK

			$self.color.bk = 0xFF252526
			$self.color.fore = 0xFF666666
			$self.color.title = 0xFF2d2d30
			$self.color.btn = 0xFF3f3f41

			$self.color.text = 0x99FFFFFF
			$self.hover.text = 0xFFFFFFFF

			$self.c.bk = 0xFF252526
			$self.c.text = 0xFFBBBBBB
			$self.c.inputbk = 0xFF2d2d30
			$self.c.hover.inputbk = 0xFF404040
			$self.c.transparent = 0

			$hFamily = _GDIPlus_FontFamilyCreate("Segoe UI")
			$self.font = _GDIPlus_FontCreate($hFamily, 13)
;~ 			$self.hover.title = 0xFF25252

		Case $_THEME_LIGHT

			$self.color.bk = 0xFFFFFFFF
			$self.color.fore = 0xFF252525
			$self.color.title = 0xFFd6dbe9
			$self.color.btn = 0xFFa6abb9

			$self.color.text = 0xCC000000
			$self.hover.text = 0xFFFFFFFF;0xFF000000

			$self.c.bk = 0xFFFFFFFF
			$self.c.text = 0xFF252525
			$self.c.inputbk = 0xFFEAEAEA
			$self.c.hover.inputbk = 0xFFBBBBBB
			$self.c.transparent = 0xFFFFFF

			$hFamily = _GDIPlus_FontFamilyCreate("Segoe UI")
			$self.font = _GDIPlus_FontCreate($hFamily, 13)

;~ 			$self.hover.title = 0xFF2d2d30
	EndSwitch

	$self.title.btnMin.color.fore = $self.c.text
	$self.title.btnMin.hover.fore = $self.c.text
	$self.title.btnMin.color.bk = _GDIPlus_BrushGetSolidColor($self.brush.title)
	$self.title.btnMin.hover.bk = _GDIPlus_BrushGetSolidColor($self.brush.btn)

	$self.title.btnClose.color.fore = 0xCCD50844
	$self.title.btnClose.hover.fore = 0xFFD50844
	$self.title.btnClose.color.bk = _GDIPlus_BrushGetSolidColor($self.brush.title)
	$self.title.btnClose.hover.bk = _GDIPlus_BrushGetSolidColor($self.brush.btn)

	Local $SubGUI = QGUIGetSubHandle($self)
	GUISetBkColor($self.c.transparent, $SubGUI)
	_WinAPI_SetLayeredWindowAttributes($SubGUI, $self.c.transparent, 255)


EndFunc

Func _QGUI_Check($self)

	If IsObj($self) = False Then Return False

	Local $Properties[0]

	_ArrayAppend($Properties, "w")
	_ArrayAppend($Properties, "h")
	_ArrayAppend($Properties, "context")

	Return $self.__check($Properties)

EndFunc