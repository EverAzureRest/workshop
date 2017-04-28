param (
    $subscriptionName,
    $storageAccountName = "workshopstgact",
    $storageAccountResourceGroupName = "workshopstoragerg"
    $deploymentLocation = "westus2"
)

$paramObject @{
    'storageAccountName' = $storageAccountName
}

Login-AzureRmAccount

if (
    $subscriptionName
)
    {
        Get-AzureRmSubscription -SubscriptionName $subscriptionName | Select-AzureRMSubscription
    }

New-AzureRMResourceGroup -name $storageAccountResourceGroupName -location $deploymentLocation

New-AzureRmResourceGroupDeployment -Name storageaccount -ResourceGroupName $storageAccountResourceGroupName -Mode Incremental -Templatefile .\storageaccount.json -TemplateParameterObject $paramObject