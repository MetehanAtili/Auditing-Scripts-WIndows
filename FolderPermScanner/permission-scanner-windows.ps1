# Define the output file path
$curDir = Split-Path (Get-Location) -Leaf
$date = Get-Date -Format "dd-MM-yyyy"
$outputCsv = "DirectoryPermissions$($curDir)_$($date).csv"

$confirmation = Read-Host "Directory $($curDir) zal gescanned worden, dit kan lang duren als er veel folders/users/groups zijn (y/n)?"
if ($confirmation -eq "y") {
    Write-Host "Scanning van folder en permissies begint nu!"
}
else {
    Write-Host "Script werd onderbroken!"
    break
}

# Check if the output CSV file already exists; if so, delete it to start fresh
if (Test-Path $outputCsv) {
    Remove-Item $outputCsv
}

# Get all subdirectories of the current directory
$subDirectories = Get-ChildItem -Directory -Recurse

# Initialize progress bar variables
$dirCount = $subDirectories.Count
$dirProcessed = 0

foreach ($dir in $subDirectories) {
    # Update progress bar
    $progress = ($dirProcessed / $dirCount) * 100
    Write-Progress -Activity "Scanning directories and exporting permissions..." -Status "$dirProcessed of $dirCount processed" -PercentComplete $progress
    
    # Get the ACL for the directory
    $acl = Get-Acl $dir.FullName
    Write-Host $dir.FullName

    foreach ($access in $acl.Access) {
        # Create a custom object with the details
        $obj = [PSCustomObject]@{
            "DirectoryPath" = $dir.FullName
            "IdentityReference" = $access.IdentityReference
            "AccessControlType" = $access.AccessControlType
            "FileSystemRights" = $access.FileSystemRights
            "IsInherited" = $access.IsInherited
        }

        # Append the object to the CSV file
        $obj | Export-Csv -Path $outputCsv -NoTypeInformation -Append
    }

    # Update processed directory count
    $dirProcessed++
}

Write-Progress -Activity "Scanning directories and exporting permissions..." -Completed
Write-Host "Permissions exported to $outputCsv"
