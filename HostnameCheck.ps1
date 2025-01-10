# Import the Active Directory module
Import-Module ActiveDirectory

# Define the input and output file paths
$InputFilePath = "C:\Temp\REPLACE WITH INPUT.csv" # Replace with your actual input file path
$OutputFilePath = "C:\Temp\REPLACE WITH OUTPUT.csv" # Replace with your desired output path

# Import the CSV file
$ComputerList = Import-Csv -Path $InputFilePath

# Initialize an array to store results
$Results = @()

# Initialize progress bar variables
$TotalComputers = $ComputerList.Count
$CurrentComputer = 0

# Loop through each computer name in the list
foreach ($Computer in $ComputerList) {
    $CurrentComputer++
    Write-Progress -Activity "Checking Computers in AD" -Status "Processing $CurrentComputer of $TotalComputers" -PercentComplete (($CurrentComputer / $TotalComputers) * 100)


    # Check if the computer exists in Active Directory
    $ComputerCheck = $Computer | Select -Expand ComputerName
    $ComputerExists = Get-ADComputer -Filter {Name -eq $ComputerCheck} -ErrorAction SilentlyContinue

    # Add the result to the array
    $Results += [PSCustomObject]@{
        ComputerName = $Computer.ComputerName
        FoundInAD    = if ($ComputerExists) { $true } else { $false }
    }
}

# Export the results to a single CSV file
$Results | Export-Csv -Path $OutputFilePath -NoTypeInformation

Write-Host "Script completed. Results have been saved."
