# NuGet Server Windows Server Core
This builds the NuGet server on the ASP.NET SDK image and then copies the files into an IIS version of Server Core.

# Docker
To get started... cd into the "nugetserver" folder.

`cd nugetserver`

`./build.ps1`

`./run.ps1`

Run this command to access the container with PowerShell.  
`docker exec -it nugetserver powershell`

# Running the Image

`./run.ps1`

or  

`docker run -d --name nugetserver -v ${PWD}\packages:C:\inetpub\wwwroot\Packages -p 80:80 -p 443:443 mrjamiebowman/nugetserver`

# NuGet Configuration
There are configuration values in the web.config that can be adjusted. This installation installs choco and vim so it's very easy to modify these configuration values if you are famililar.

The main Dockerfile is under the "nugetserver" folder. The prior folder, "msbuild" is a Dockerfile explicitly for running msbuild. This was used to build the multi-stage build Dockerfile for the NuGet server.

`vim web.config`

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

### Troubleshooting
Once you've accessed the container you can run this command to see the internal error.

`Invoke-WebRequest 'http://localhost/'`
