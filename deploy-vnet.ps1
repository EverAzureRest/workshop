param(
    $vnetResourceGroupName = "workshopSimpleVnet",
    $deploymentlocation = "WestUS2",
    $subscriptionName
)

$ParamHash = @{
    'vnetName' = "simpleVnet";
    'vnetAddressPrefix' = "10.2.0.0/16";
    'subnet1Name' = "Subnet1";
    'subnet1Prefix' = "10.2.1.0/24";
    'subnet2Name' = "Subnet2";
    'subnet2Prefix' = "10.2.2.0/24";
    'subnet3Name' = "Subnet3";
    'subnet3Prefix' = "10.2.3.0/24"
}

Login-AzureRmAccount

if $subscriptionName (
    Get-AzurermSubscription -SubscriptionName $subscriptionName | Select-AzureRmSubscription
)

New-AzureRmResourceGroup -Name $vnetResourceGroupName -Location $deploymentlocation

New-AzureRmResourceGroupDeployment -Name workshopvnet -ResourceGroupName $vnetResourceGroupName -Mode Incremental -Templatefile .\simplevnet.json -TemplateParameterObject $ParamHash
