FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 as msbuild
LABEL maintainer="@mrjamiebowman"

SHELL ["powershell"]

# install choco
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install git -y
RUN choco install vim -y

# set up dirs
RUN New-Item -Path C:\source -ItemType Directory -Force
RUN New-Item -Path C:\published -ItemType Directory -Force
WORKDIR /source

# clone and run msbuild
RUN git clone https://github.com/NuGet/NuGet.Server.git .
RUN nuget restore

# wrapping the msbuild command in a powershell scripts returns 0 and does not fail...
COPY scripts/msbuild.ps1 .
RUN ./msbuild.ps1
COPY scripts/FolderProfile.pubxml /source/src/NuGet.Server/Properties/PublishProfiles/FolderProfile.pubxml
COPY scripts/release.ps1 .
RUN ./release.ps1

# build server image
FROM mcr.microsoft.com/windows/servercore/iis as nugetserver

SHELL ["powershell"]

# todo: create user for least priviliged
# todo: volume for packages

# install choco, vim
RUN Set-ExecutionPolicy Bpass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install vim -y

# install
RUN Add-WindowsFeature Web-Asp-Net45
RUN Add-WindowsFeature NET-Framework-45-ASPNET

# dirs
RUN New-Item -Path C:\setup -ItemType Directory -Force
RUN New-Item -Path C:\inetpub\wwwroot\Packages -ItemType Directory -Force

# clean iis folder
RUN -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

# unlock sections in web.config
RUN & $env:windir\system32\inetsrv\appcmd.exe unlock config -section:system.webServer/handlers
RUN & $env:windir\system32\inetsrv\appcmd.exe unlock config -section:system.webServer/modules

# enable directory browsing (useful for debugging)
#RUN & $env:windir\system32\inetsrv\appcmd set config /section:directoryBrowse /enabled:true

# copy files
WORKDIR /inetpub/wwwroot
COPY --from=msbuild /published/ .