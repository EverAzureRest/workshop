param(
    $vnetResourceGroupName = "workshopSimpleVnet",
    $vmResourceGroupName = "workshopVMs",
    $deploymentlocation = "WestUS2",
    $subscriptionName
)

$ParamHash = @{
    'adminUsername' = "LocalAdmin";
    'numberOfInstances' = 2
    'vmNamePrefix' = "workshopvm0"
    'virtualNetworkName' = "workshopvnet"
    'virtualNetworkResourceGroup' = $vnetResourceGroupName
    'storageAccountName' = "workshopstgact" #storage account names must be unique per region in Azure
    'subnetName' = "Subnet2"
}

Login-AzureRmAccount

if $subscriptionName (
    Get-AzurermSubscription -SubscriptionName $subscriptionName | Select-AzureRmSubscription
)

New-AzureRmResourceGroup -Name $vnetResourceGroupName -Location $deploymentlocation

New-AzureRmResourceGroupDeployment -Name workshopvms -ResourceGroupName $vnetResourceGroupName -Mode Incremental -Templatefile .\windowsvm.json -TemplateParameterObject $ParamHash