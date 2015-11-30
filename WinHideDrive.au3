#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=WinHideDrive.ico ;Icon from http://typicons.com/
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Written 2015 by ArtificialDreamer
#AutoIt3Wrapper_Res_Description=Versteckt beliebige Laufwerke im Arbeitsplatz & Windows Explorer
#AutoIt3Wrapper_Res_Fileversion=0.7.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1031
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

	------------------

	AutoIt Version: 3.3.14.2
	Datum:         07.11.2015
	Funktionsbeschreibung:
	Versteckt Laufwerke im Arbeitsplatz & Windows Explorer via Registry-Schlüssel

	TODO: Userspezifisches Verstecken? (HKEY_CURRENT_USER)

#ce


#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListBox.au3>
#include <Array.au3>

Global Const $PROG_NAME = "WinHideDrive V 0.7"
; Registry Schlüssel zum setzen der Einstellungen für die zu versteckenden Laufwerke
Global Const $NODRIVES_DEST_SUBKEY = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"


; #FUNCTION# =======================
; Beschreibung:
;  Berechne Registry NoDrive-Kodierungswert des übergebenen Laufwerks.
;  userspezifischen für den Eintrag genutzt
; Params - $sDrive - Laufwerksbuchstabe der in NoDrive-Registry-Äquivalent konvertiert werden soll.
; Return - Laufwerks-Bit-Wert Bsp: A = 1, B = 2, C = 4, D = 8 ... Z = 33554432
; ==================================
Func _getDriveRegKeyValue($sDrive)
	$sDrives = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Return BitShift(1, -(StringInStr($sDrives, $sDrive) - 1))
EndFunc   ;==>_getDriveRegKeyValue

; #FUNCTION# =======================
; Beschreibung:
;  Wenn User für alle Nutzer ausgewählt hat, wird der gloale registry-Eintrag statt des
;  userspezifischen für den Eintrag genutzt
; Params -
; Return - Registry Hive für Admin oder Nutzereinstellungen
; ==================================
Func _getSelectedHive()
	If GUICtrlRead($hChxAllUser) == $GUI_CHECKED Then
		$sHive = "HKEY_LOCAL_MACHINE"
	Else
		$sHive = "HKEY_CURRENT_USER"
	EndIf
	Return $sHive
EndFunc   ;==>_getSelectedHive

; #FUNCTION# =======================
; Beschreibung:
;  Zum Anzeigen der gegenwärtigen NoDrive-Einstellung (User oder Admin)
; Params -
; Return - void
; ==================================
Func _refreshDriveListBox()
	_GUICtrlListBox_ResetContent($hListDrives)
	$sHive = _getSelectedHive()
	$sKey = $sHive & $NODRIVES_DEST_SUBKEY
	$sCurrentRegNoDriveVal = RegRead($sKey, "NoDrives") ;Bit codierter Wert welche Laufwerke im Moment als versteckt markiert sind
	$sDrives = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	For $i = 1 To 26 ;26 = StringLen("ABC...XYZ")
		$sDriveRoot = StringMid($sDrives, $i, 1) ;Ermittle Laufwerksbuchstabe (1=>A,2=>B...26=>Z)
		$iRegValCheckDrive = _getDriveRegKeyValue($sDriveRoot)
		If BitAND($iRegValCheckDrive, $sCurrentRegNoDriveVal) Then ;Wenn Bitcode in aus dem aus der Registry ausgelesenen
			GUICtrlSetData($hListDrives, $sDriveRoot) ;übereinstimmt, Laufwerksbuchstabe zur Listbox hinzufügen
		EndIf
	Next

EndFunc   ;==>_refreshDriveListBox

#Region ### START Koda GUI section ### Form=C:\WinHideDrive\hMainGui.kxf
$hMainGui = GUICreate($PROG_NAME, 293, 223, 499, 172, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE))

$hChxAllUser = GUICtrlCreateCheckbox("Einstellung für alle Nutzer übernehmen", 8, 8, 270, 17)
GUICtrlSetState(-1, BitXOR($GUI_DISABLE, $GUI_CHECKED))
GUICtrlSetTip(-1, "Wenn nicht aktiv, werden die Einstellungen nur auf den aktuellen Nutzer angewendet")
$hListDrives = GUICtrlCreateList("", 8, 60, 193, 71)
$hLabHideLabels = GUICtrlCreateLabel("Folgende Laufwerke verstecken:", 8, 40, 160, 17)

$hButDriveDel = GUICtrlCreateButton("Entfernen", 208, 75, 73, 20)
GUICtrlSetTip(-1, "Ausgewähltes Laufwerk von der Liste zu versteckender Laufwerke entfernen")

$hButDriveAdd = GUICtrlCreateButton("Hinzufügen", 72, 140, 89, 25)
GUICtrlSetTip(-1, "Ausgewähltes Laufwerk zur Liste zu versteckender Laufwerke hinzufügen")

$hComDrives = GUICtrlCreateCombo("A", 8, 140, 49, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z")

$hButSave = GUICtrlCreateButton("Übernehmen", 104, 190, 89, 25)
GUICtrlSetTip(-1, "Ausgewählte Laufwerke verstecken")

$hButInfo = GUICtrlCreateButton("Info", 245, 200, 41, 17)

_refreshDriveListBox()
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hButInfo
			MsgBox(0, $PROG_NAME, "Tool zum Verstecken von Laufwerken im Arbeitsplatz & Windows Explorer." & @CRLF & @CRLF _
					 & "Getestet mit: " & @CRLF _
					 & "- Microsoft Windows XP SP2 32Bit " & @CRLF _
					 & "- Microsoft Windows 7 64 Bit" & @CRLF & @CRLF _
					 & "Lizenz: Apache License 2.0" & @CRLF & @CRLF _
					 & "Microsoft und Windows sind eingetragene Warenzeichen" & @CRLF _
					 & "der Microsoft Corporation" & @CRLF & @CRLF _
					 & "Written 2015 by ArtificialDreamer" & @CRLF _
					 & "")
		Case $hButDriveAdd
			GUICtrlSetData($hListDrives, GUICtrlRead($hComDrives, 1))
		Case $hButDriveDel
			_GUICtrlListBox_DeleteString($hListDrives, _GUICtrlListBox_GetCurSel($hListDrives))
		Case $hButSave
			$iRegVal = 0 ;Registry DWORD
			For $i = 0 To _GUICtrlListBox_GetCount($hListDrives) - 1
				$iRegVal += _getDriveRegKeyValue(_GUICtrlListBox_GetText($hListDrives, $i))
			Next

			$sHive = _getSelectedHive()
			$sKey = $sHive & $NODRIVES_DEST_SUBKEY
			$success = RegWrite($sKey, "NoDrives", "REG_DWORD", $iRegVal)
			If $success Then
				$sSucessMsg = "Die ausgewählten Laufwerke wurden versteckt und sind nach einem Neustart dauerhaft ausgeblendet"
				MsgBox($MB_ICONINFORMATION, $PROG_NAME & " - Einstellung erfolgreich übernommen.", $sSucessMsg)
			Else
				MsgBox($MB_ICONERROR, $PROG_NAME & " - Fehler", "Fehler beim Schreiben der Werte in die Registry. Fehlende Berechtigungen?")
			EndIf
		Case $hChxAllUser
			_refreshDriveListBox()
	EndSwitch
WEnd
