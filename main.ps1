#Requires -RunAsAdministrator

# ==============================================================================================================================
# Remove Apps

# Raw list of apps
$rApps = (Get-Content -Path "$PSScriptRoot/Appslist.txt")

# Get list of apps from file at the path provided, and remove them one by one
Foreach ($line in $rApps.Split('\n')) { 
    
    $app = ($line.Split('#')[0].Trim())

    Write-Output "Attempting to remove $app..."

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
    
    #
    reg import $_.FullName

}

# ==============================================================================================================================

#
Pause.exe