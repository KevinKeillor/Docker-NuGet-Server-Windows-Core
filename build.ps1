Write-Host "Building NuGet Server image..."

# empty directory
Get-ChildItem -Path ${PWD}\source -Include *.* -File -Recurse | foreach { $_.Delete()}
Get-ChildItem -Path ${PWD}\published -Include *.* -File -Recurse | foreach { $_.Delete()}


# clone nuget server into source folder
git clone https://github.com/NuGet/NuGet.Server.git source


docker build -t mrjamiebowman/nugetserver .