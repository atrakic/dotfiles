
PORT=${1:-8080}

docker run -it -d --name whoami -p $PORT:80 --restart=unless-stopped containous/whoami

ssh -R 80:localhost:$PORT ssh.localhost.run

