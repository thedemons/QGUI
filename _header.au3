#include-once
#include <Array.au3>
#include <WinAPI.au3>
#include <WinAPIGdi.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <AutoItObject.au3>
#include <Misc.au3>

_AutoItObject_Startup()
_GDIPlus_Startup()

Global Const $_THEME_DARK = "dark"
Global Const $_THEME_LIGHT = "light"

Global Const $__C_TRANSPERCY = 0x77AAAAAA

Global Const $AL_CENTER = 0
Global Const $AL_LEFT = 1
Global Const $AL_RIGHT = 2


Global $__LastQGUI, $__LastCtrl
Global $__AllGUI[0], $__AllSubGUI[0]


#include "QGUICtrl.au3"
#include "QGUICtrlRect.au3"
#include "QGUICtrlLabel.au3"
#include "QGUICtrlButton.au3"
#include "QGUICtrlInput.au3"
#include "QGUI.au3"


Func print($str, $errCode = 0, $return = False)

	Local $prefix

	Switch $errCode
		Case 0
			$prefix = ">"
		Case 1
			$prefix = "+>"
		Case 2
			$prefix = "!"
	EndSwitch

	ConsoleWrite($prefix & " " & $str & @CRLF)

	Return $return
EndFunc

Func _MouseHover($cursor, $x, $y, $w, $h)

	If IsArray($cursor) = False Then Return False

	If $cursor[0] >= $x And $cursor[0] <= $x + $w And $cursor[1] >= $y And $cursor[1] <= $y + $h Then Return True

	Return False

EndFunc

Func _ArrayAppend(ByRef $Array, $Value)

	If IsArray($Array) = False Then Return False

	Local $index = UBound($Array)

	ReDim $Array[$index + 1]

	$Array[$index] = $Value

	Return $index
EndFunc

Func __ARGB2RGB($ARGB)

	Local $RGB = StringMid(Hex($ARGB, 8), 3, 6)

	If StringLen($RGB) < 6 Then Return False

	Return Number("0x" & $RGB)

EndFunc

Func __ARGB2A($ARGB)

	Local $A = StringMid(Hex($ARGB, 8), 1, 2)

	If StringLen($A) < 2 Then Return False

	Return Number("0x" & $A )

EndFunc

Func __CurveRect($x = 0, $y = 0, $w = 0, $h = 0, $bound = 3, $lt = True, $rt = True, $lb = True, $rb = True)

	Local $hPath = _GDIPlus_PathCreate()
	Local $ly1 = $y + $bound
	Local $ly2 = $y + $h - $bound
	Local $tx1 = $x + $bound
	Local $tx2 = $x + $w - $bound
	Local $ry1 = $y + $bound
	Local $ry2 = $y + $h - $bound
	Local $bx1 = $x + $bound
	Local $bx2 = $x + $w - $bound

	If Not $lt Then
		$ly1 = $y
		$tx1 = $x
	EndIf
	If Not $rt Then
		$ry1 = $y
		$tx2 = $x + $w
	EndIf
	If Not $lb Then
		$bx1 = $x
		$ly2 = $y + $h
	EndIf
	If Not $rb Then
		$bx2 = $x + $w
		$ry2 = $y + $h
	EndIf

	If $lt Then _GDIPlus_PathAddArc($hPath, $x, $y , $bound, $bound, 180, 90)
	_GDIPlus_PathAddLine($hPath, $tx1, $y, $tx2, $y)

	If $rt Then _GDIPlus_PathAddArc($hPath, $x + $w - $bound, $y, $bound, $bound, -90, 90)
	_GDIPlus_PathAddLine($hPath, $x + $w, $ry1, $x + $w, $ry2)

	If $rb Then _GDIPlus_PathAddArc($hPath, $x + $w - $bound, $y + $h - $bound, $bound, $bound, 0, 90)
	_GDIPlus_PathAddLine($hPath, $bx1, $y + $h, $bx2, $y + $h)

	If $lb Then _GDIPlus_PathAddArc($hPath, $x, $y + $h - $bound, $bound, $bound, 90, 90)
	_GDIPlus_PathAddLine($hPath, $x, $ly2, $x, $ly1)
    _GDIPlus_PathCloseFigure($hPath)

	Return $hPath
EndFunc

Func _GuiCtrlMakeTrans($iCtrlID,$iTrans=255)

    Local $pHwnd, $nHwnd, $aPos, $a

    $hWnd = GUICtrlGetHandle($iCtrlID);Get the control handle
    If $hWnd = 0 then Return SetError(1,1,0)
    $pHwnd = DllCall("User32.dll", "hwnd", "GetParent", "hwnd", $hWnd);Get the parent Gui Handle
    If $pHwnd[0] = 0 then Return SetError(1,2,0)
    $aPos = ControlGetPos($pHwnd[0],"",$hWnd);Get the current pos of the control
    If @error then Return SetError(1,3,0)
    $nHwnd = GUICreate("", $aPos[2], $aPos[3], $aPos[0], $aPos[1], 0x80000000, 0x00080000 + 0x00000040, $pHwnd[0]);greate a gui in the position of the control
    If $nHwnd = 0 then Return SetError(1,4,0)
    $a = DllCall("User32.dll", "hwnd", "SetParent", "hwnd", $hWnd, "hwnd", $nHwnd);change the parent of the control to the new gui
    If $a[0] = 0 then Return SetError(1,5,0)
    If NOT ControlMove($nHwnd,'',$hWnd,0,0) then Return SetError(1,6,-1);Move the control to 0,0 of the newly created child gui
    GUISetState(@SW_Show,$nHwnd);show the new child gui
    WinSetTrans($nHwnd,"",$iTrans);set the transparency
    If @error then Return SetError(1,7,0)
    GUISwitch($pHwnd[0]);switch back to the parent Gui

    Return $nHwnd;Return the handle for the new Child gui

EndFunc