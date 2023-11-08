/*
Script:    DeviceIDPnP.ahk
Author:    XMCQCX
Date:      2023-03-01
Version:   2.0.0
Github:    https://github.com/XMCQCX/DeviceIDPnP
AHK forum: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=114610
*/

#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
CoordMode "ToolTip", "Screen"
dell := 0

MyDevices := MyDevicesAdd()
sleep 5000
;=============================================================================================

; MyDevices.Add({DeviceName:"OMOTON Keyboard", DeviceID:"HID\{00001124-0000-1000-8000-00805F9B34FB}_VID&000205AC_PID&022C&COL01\8&25652F0&0&0000"})
MyDevices.Add({DeviceName:"Nuphy Air75v2 Keyboard", DeviceID:"HID\{00001812-0000-1000-8000-00805F9B34FB}_E773EFD7B0D2&COL01\9&2027B943&0&0000"})

;=============================================================================================


#HotIf dell = 1 ; All hotkeys below this line will only work if dell is TRUE
  F11::Home
  F12::End
  Home::F11
  End::F12
#HotIf

DevicesActions(thisDeviceStatus) {

    global

    ; if thisDeviceStatus = "OMOTON Keyboard Connected" {
    ;     Run "C:\Users\dumans\Downloads\Portable\AHK\device-specific\omoton keyboard.ahk"
    ; }
    ; if thisDeviceStatus = "OMOTON Keyboard Disconnected" {
    ;     ; fullScriptPath := "C:\Users\dumans\Downloads\Portable\AHK\device-specific\omoton keyboard.ahk ahk_class AutoHotkey"  ; edit with your full script path
    ;     DetectHiddenWindows(true)
    ;     if WinExist("C:\Users\dumans\Downloads\Portable\AHK\device-specific\omoton keyboard.ahk ahk_class AutoHotkey")
    ;         WinClose("C:\Users\dumans\Downloads\Portable\AHK\device-specific\omoton keyboard.ahk ahk_class AutoHotkey")
    ;     DetectHiddenWindows(false)
    ; }

    if thisDeviceStatus = "Nuphy Air75v2 Keyboard Connected" {
        Run "C:\Users\dumans\Downloads\Portable\AHK\device-specific\Lyt_en_us.ahk"
        dell := 0
    }
        
    if thisDeviceStatus = "Nuphy Air75v2 Keyboard Disconnected" {
        Run "C:\Users\dumans\Downloads\Portable\AHK\device-specific\Lyt_en_uk.ahk"
        dell := 1
    }
}
;=============================================================================================



;=============================================================================================
Class MyDevicesAdd {
    
    aMyDevices := []

	Add(oItem)
	{
        aDevIDs := [], devCount := 0

        if InStr(oItem.DeviceID, "|&|") {
            for _, devID in StrSplit(oItem.DeviceID, "|&|") {
                aDevIDs.push(devID := Trim(devID))
                oItem.DeviceCount := ++devCount
            }
            if !oItem.HasOwnProp("DevicesMatchMode")
                oItem.DevicesMatchMode := 1
        }
        else {
            aDevIDs.push(oItem.DeviceID := Trim(oItem.DeviceID))
            oItem.DeviceCount := 1
            oItem.DevicesMatchMode := 1
        }   
        
        if !oItem.HasOwnProp("ActionAtStartup")
            oItem.ActionAtStartup := "true"
        
        if !oItem.HasOwnProp("Tooltip")
            oItem.Tooltip := "true"

        oItem.DeviceID := aDevIDs
        this.aMyDevices.push(oItem)
        
        devExist := DevicesExistCheck(aDevIDs, oItem.DeviceCount, oItem.DevicesMatchMode)

        if devExist
            this.aMyDevices[this.aMyDevices.Length].DeviceStatus := "Connected"
        else
            this.aMyDevices[this.aMyDevices.Length].DeviceStatus := "Disconnected"
	}
}

;=============================================================================================

TooltipDevicesActions(Mydevices.aMyDevices)

TooltipDevicesActions(Array) {

    strTooltip := ""

    for _, item in Array
    {
        if item.Tooltip = "true"
            strTooltip .= item.DeviceName A_Space item.DeviceStatus "`n"
        
        if item.ActionAtStartup = "true"
            DevicesActions(item.DeviceName A_Space item.DeviceStatus)
    }

    If strTooltip {
        strTooltip := RTrim(strTooltip, "`n")
        Tooltip strTooltip, 0, 0
        SetTimer () => ToolTip(), -6000
    }
}

;=============================================================================================

DevicesExistCheck(aDevIDs, DeviceCount, DevicesMatchMode) {

    aDevList :=  [], devExistCount := 0
    
    for dev in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_PnPEntity")
        aDevList.Push({DeviceID: dev.DeviceID, DeviceStatus :dev.Status})

    for _, mydevID in aDevIDs
        for _, dev in aDevList
            if mydevID = dev.DeviceID
                if dev.DeviceStatus = "OK"
                    devExistCount++
    
    if DevicesMatchMode = 1
        if DeviceCount = devExistCount
            Return true
    
    if DevicesMatchMode = 2
        if devExistCount
            Return true
}

;=============================================================================================

OnMessage(0x219, WM_DEVICECHANGE)
WM_DEVICECHANGE(wParam, lParam, msg, hwnd) {
    SetTimer DevicesStatusCheck, -1250
}

DevicesStatusCheck() {

    aNewDevStatus := []
    for _, dev in MyDevices.aMyDevices
    {
        devExist := DevicesExistCheck(dev.DeviceID, dev.DeviceCount, dev.DevicesMatchMode)

        if (devExist && dev.DeviceStatus = "Disconnected") {
            dev.DeviceStatus := "Connected"
            aNewDevStatus.Push({DeviceName:dev.DeviceName, DeviceStatus:dev.DeviceStatus, Tooltip:dev.Tooltip, ActionAtStartup:"true"})
        }

        if (!devExist && dev.DeviceStatus = "Connected") {
            dev.DeviceStatus := "Disconnected"
            aNewDevStatus.Push({DeviceName:dev.DeviceName, DeviceStatus:dev.DeviceStatus, Tooltip:dev.Tooltip, ActionAtStartup:"true"})
        }
    }

    If aNewDevStatus.Length >= 1
        TooltipDevicesActions(aNewDevStatus)
}
