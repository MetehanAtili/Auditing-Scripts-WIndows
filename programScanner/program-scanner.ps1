# Create an empty array to hold the program details
$programs = @()

# Enumerate all the program paths
$UninstallPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

foreach ($UKey in $UninstallPaths) {
    # Get the item properties for each path and handle errors silently
    $Products = Get-ItemProperty $UKey -ErrorAction SilentlyContinue
    foreach ($Product in $Products) {
        # Filter out system components and ensure DisplayName is present
        if ($Product.DisplayName -and $Product.SystemComponent -ne 1) {
            # Check if InstallDate is present and convert it
            $formattedDate = if ($Product.InstallDate) {
                try {
                    # Attempt to parse the date string and format it
                    $date = [datetime]::ParseExact($Product.InstallDate, 'yyyyMMdd', $null)
                    $date.ToString('dd/MM/yyyy') # Format changed here
                } catch {
                    # If parsing fails, use the original string
                    $Product.InstallDate
                }
            } else {
                # If no InstallDate, leave it blank
                ''
            }

            # Add the product details to the array, with the formatted date
            $programs += [PSCustomObject]@{
                DisplayName = $Product.DisplayName
                Publisher = $Product.Publisher
                InstallDate = $formattedDate
            }
        }
    }
}

# Define the CSV file name with the computer name included
$csvFileName = "InstalledPrograms_$($env:COMPUTERNAME).csv"

# Export the array to a CSV file with the computer name in the file name
$programs | Export-Csv -Path $csvFileName -NoTypeInformation
