# clean up if previous nugetserver is running...
docker rm -f nugetserver

docker run -d --name nugetserver -v ${PWD}\packages:C:\inetpub\wwwroot\Packages -p 80:80 -p 443:443 mrjamiebowman/nugetserver
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" nugetserver

# docker exec -it nugetserver powershell