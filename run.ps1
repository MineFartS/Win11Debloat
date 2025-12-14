
Clear-Host
Write-Host "-------------------------------------------------------------------------------------------"
Write-Host " Minefarts / Win11Debloat"
Write-Host "-------------------------------------------------------------------------------------------"

Write-Output "> Downloading Win11Debloat..."

# Download latest version of Win11Debloat from GitHub as zip archive
Invoke-RestMethod `
    -Uri 'https://github.com/MineFartS/Win11Debloat/archive/refs/heads/master.zip' `
    -OutFile "$env:TEMP/win11debloat.zip"

# Remove old script folder if it exists
if (Test-Path "$env:TEMP/Win11Debloat") {
    Write-Output ""
    Write-Output "> Cleaning up old Win11Debloat folder..."
    Remove-Item "$env:TEMP/Win11Debloat" -Recurse -Force
}

Write-Output "> Unpacking..."

# Unzip archive to Win11Debloat folder
Expand-Archive "$env:TEMP/win11debloat.zip" "$env:TEMP/Win11Debloat"

# Remove archive
Remove-Item "$env:TEMP/win11debloat.zip"

Write-Output "> Running Win11Debloat..."
 
# Run main.ps1 with elevated privileges
Start-Process `
    -FilePath "powershell" `
    -Verb RunAs `
    -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", "$env:TEMP\Win11Debloat\Win11Debloat-master\main.ps1"
    )
    

# Remove all remaining script files, except for CustomAppsList and SavedSettings files
if (Test-Path "$env:TEMP/Win11Debloat") {
    Write-Output "> Cleaning up..."
    Remove-Item "$env:TEMP/Win11Debloat" -Recurse -Force
}