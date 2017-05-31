Configuration SimpleWeb
{
Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xNetworking
Import-DscResource -ModuleName xWebDeploy
Import-DscResource -ModuleName cAzureStorage
Import-DSCResource -ModuleName xWebAdministration

$tempdir = "C:\Temp"
$destpath = "C:\inetpub\wwwroot\WebApp"

Node WebServer
    {
    WindowsFeature Web-Server
        {
            Ensure = 'Present'
            Name = 'Web-Server'
            IncludeAllSubFeature = $True
        }
        
    WindowsFeature AspNet45
        {
            Ensure                  = 'Present'
            Name                    = 'Web-Asp-Net45'
        }

    xFirewall Default
        {
            Name                  = 'Default'
            Enabled               = 'True'
            Protocol              = 'TCP'
            LocalPort             = '80'
            Action                = 'Allow'
            Profile               = 'Any'
        }
        
     xWebsite DefaultSite 
        {
            Ensure                  = 'Present'
            Name                    = 'Default Web Site'
            State                   = 'Started'
            PhysicalPath            = 'C:\inetpub\wwwroot'
            DependsOn               = '[WindowsFeature]Web-Server'
        }
        
    xWebAppPool WebAppPool
        {

            Ensure                  = 'Present'
            Name                    = 'WebAppPool'
            DependsOn               = '[WindowsFeature]Web-Server'
        }
    
    File WebContent
        {
            Ensure                  = 'Present'
            SourcePath              = 'C:\inetpub\wwwroot'
            DestinationPath         = $destpath
            Recurse                 = $true
            Type                    = 'Directory'
            DependsOn               = '[WindowsFeature]Web-Server'
        }
    
    xWebApplication WebApplication 
        {
            Ensure                  = 'Present'
            Name                    = 'WebApplication'
            WebAppPool              = 'SampleAppPool'
            Website                 = 'Default Web Site'
            PreloadEnabled          = $true
            ServiceAutoStartEnabled = $true
            PhysicalPath            = $destpath
            DependsOn               = '[xWebsite]DefaultSite','[xWebAppPool]WebAppPool'

        }

    File Tempdir
        {
            DestinationPath = $tempdir
            Ensure = 'Present'
            Type = 'Directory'
        }
    }
}