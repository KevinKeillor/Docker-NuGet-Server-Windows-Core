# NuGet Server Windows Server Core
This builds the NuGet server on the ASP.NET SDK image and then copies the files into an IIS version of Server Core.

# Docker
Run this command to access the container with PowerShell.  
`docker exec -it nugetserver powershell`

# NuGet Configuration
There are configuration values in the web.config that can be adjusted. This installation installs choco and vim so it's very easy to modify these configuration values if you are famililar.

web.config  
* requireApiKey
* apiKey
* packagesPath

# Enabling Errors in web.config

    <configuration>
        <system.web>
            <customErrors mode="Off" />
        </system.web>
    </configuration>

## Restart IIS
Stop-WebSite 'NuGetServer'  
Start-WebSite 'NuGetServer'  

## Service Monitor
ServiceMonitor is a Windows executable designed to be used as the entrypoint process when running IIS inside a Windows Server container.

[GitHub: IIS.ServiceMonitor](https://github.com/microsoft/IIS.ServiceMonitor)  