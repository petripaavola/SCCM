# Read computer names from list and add them to collection if computer is in SCCM database
#
# Petri.Paavola@yodamiitti.fi
# 20190227

# Collection where computers are added to
$collectionName = "Support - Delete Computers"

# List of computer names text file (just list of computer name in each line, no csv or headers)
$computers = get-content 'C:\temp\computers.txt'

# Loop through computers in list
foreach ($computer in $computers) {
    Write-Output "Processing computer $computer"

    $resourceId = $null

    # Get Device
    # If this fails then device is not in database
    $CMDevice = Get-CMDevice -Name "$computer"
    $resourceId = $CMDevice.ResourceID

    # Add computer to database if it exist
    if($resourceId) {
        
        # Add computer to collection
        Add-CMDeviceCollectionDirectMembershipRule -CollectionName "$collectionName" -ResourceID $resourceID
        $success = $?

        if($success) {
            # Collection add succeeded
            Write-Output "Computer $computer (resourceId: $resourceId) added to collection $collectionName"
        } else {
            # Collection add failed
            Write-Output "Error adding computer $computer (resourceId: $resourceId) to collection $collectionName"
        }
    } else {
        Write-Output "Computer $computer does not exist in SCCM database"
    }
}

