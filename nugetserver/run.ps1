
docker rm -f nugetserver

#w3svc

docker run -d --name nugetserver -p 80:80 -p 443:443 mrjb/nugetserver
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" nugetserver
docker ps -a
docker exec -it nugetserver powershell