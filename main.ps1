
# ==============================================================================================================================
# Remove Apps

# 
Get-Content -Path "$PSScriptRoot/Appslist.txt" | ForEach-Object {
    
    #
    $app = ($_.Split('#')[0].Trim())

    Write-Host ""
    Write-Output "Removing app: '$app'"

    #
    if (($app -eq "Microsoft.OneDrive") -or ($app -eq "Microsoft.Edge")) {

        winget.exe `
            uninstall `
            --accept-source-agreements `
            --disable-interactivity `
            --id $app

    #
    } else {
            
        Get-AppxPackage `
            -Name "*$app*" `
            -AllUsers `
        | Remove-AppxPackage `
            -AllUsers `
            -ErrorAction Continue

    }

    # Remove provisioned app from OS image, so the app won't be installed for any new users
    Get-AppxProvisionedPackage -Online `
    | Where-Object PackageName -like $app `
    | ForEach-Object { 
        Remove-ProvisionedAppxPackage `
        -Online -AllUsers `
        -PackageName $_.PackageName 
    }

}

# ==============================================================================================================================
# Import Registry Keys

#
Get-ChildItem -Path "$PSScriptRoot\Regfiles\" | ForEach-Object {

    Write-Host ""
    Write-Host "Updating Registry: '$($_.Name)'"
    
    #
    reg import $_.FullName

}

# ==============================================================================================================================
# Restart Explorer

Write-Host ""
Write-Host "Restarting Explorer"

# Restart File Explorer
Stop-Process `
    -Name 'Explorer' `
    -Force

# ==============================================================================================================================

Write-Host ""

#
Pause