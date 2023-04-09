docker kill $(docker ps -q) || true
docker rm $(docker ps -a -q) || true
# docker rmi $(docker images -q)
