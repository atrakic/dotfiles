MY_HUB=xomodo

_aws(){
    docker run -it --rm \
     -v "${HOME}/.aws:/root/.aws" \
     --log-driver none \
     --name aws \
     $MY_HUB/awscli "$@"
}
_terraform(){
  docker run -it --rm \
    -v "$PWD:/tf" \
    --workdir /tf \
    --name terraform \
    hashicorp/terraform:light "$@"
}
_gradle(){
  docker run -it --rm \
    -u "$(id -u):$(id -g)"\
    -v "$PWD:/project" \
    -w /project \
    --name gradle \
    gradle gradle
}
_gitsome(){
  docker run -it --rm \
  -v $(pwd):/src/ \
  -v ${HOME}/.gitsomeconfig:/root/.gitsomeconfig\
  -v ${HOME}/.gitconfig:/root/.gitconfig\
  --name gitsome \
  mariolet/gitsome
}
_cloud-custodian(){
  // fixme:
  local DOCKER=cloud-custodian
  #curl -sLo /tmp/custodian-ec2-stop.yaml https://gist.githubusercontent.com/atrakic/597faae64cb0ec7bea8d3c02e22cf159/raw/b28a9c8acf81cb4a0dca4844ef1a84111e45ad60/custodian-ec2-stop.yaml
  docker run -it --rm \
    --name "$DOCKER" \
    -v "/tmp:/tf:ro"\
    -w /tmp \
    capitalone/cloud-custodian #run --dryrun /tmp/custodian-ec2-stop.yaml
}

##
# Detached daemons
##

_nginx(){
    docker run -d \
      --restart always \
      -v "${HOME}/.nginx:/etc/nginx" \
      --net host \
      --name nginx \
      nginx
}

_postgresqld() {
  local DOCKER=postgresqld
  docker run -d \
    --name "$DOCKER" \
    -e POSTGRES_PASSWORD=admin \
    postgres:11-alpine
}
_mysqld(){
  local DOCKER=mysqld
    docker run -d \
     --name "$DOCKER" \
     -e MYSQL_ROOT_PASSWORD=petclinic \
     -e MYSQL_DATABASE=petclinic \
     -p 3306:3306 \
     mysql:5.7.24
}
_cadvisor() {
  local DOCKER=cadvisor
  docker run -d \
    --name "$DOCKER" \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/dev/disk/:/dev/disk:ro \
    -P \
    google/"$DOCKER":latest
}
_jenkins-evergreen() {
  local DOCKER=jenkins-evergreen
  #curl -sLo /tmp/jenkins.yaml https://raw.githubusercontent.com/Praqma/praqma-jenkins-casc/master/jenkins.yaml \
  docker volume create "$DOCKER-data" && \
  docker pull jenkins/evergreen:docker-cloud && \
  docker run -d \
    --name "$DOCKER" \
    --restart=always \
    -P \
    -v $(which docker):/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$DOCKER-data:/evergreen/data" \
    -e LOG_LEVEL=info \
    jenkins/evergreen:docker-cloud
    #-e CASC_JENKINS_CONFIG=/tmp/jenkins.yaml \
  docker exec "$DOCKER" cat /evergreen/data/jenkins/home/secrets/initialAdminPassword
}
_drone-server(){
  // fixme:
  local DOCKER=drone-server
  local DRONE_SECRET=foo
  local DRONE_HOST=drone

  local DRONE_GITHUB_CLIENT=foo
  local DRONE_GITHUB_SECRET=aaaaasdasdasdfdfsdfsdfsdf

  docker volume create "$DOCKER-data" && \

  docker pull drone/drone:0.8

  docker run -d\
    --name "$DOCKER"\
    --restart=always\
    -p 9000:9000 \
    -e DRONE_OPEN=true\
    -e DRONE_HOST=http://${DRONE_HOST}\
    -e DRONE_SECRET=${DRONE_SECRET}\
    -e DRONE_GITHUB=true\
    -e DRONE_GITHUB_CLIENT=${DRONE_GITHUB_CLIENT}\
    -e DRONE_GITHUB_SECRET=${DRONE_GITHUB_SECRET}\
    -v "$DOCKER-data:/var/lib/drone/"\
    --hostname "$DOCKER"\
  drone/drone:0.8
}
_drone-agent(){
  // fixme: depends on
  local DRONE_SECRET=foo
  docker pull drone/agent:0.8 && \
  docker run -d \
    --name drone-agent\
    --restart=always\
    --volume=/var/lib/docker/:/var/lib/docker:ro\
    -e DRONE_SERVER=drone-server:9000\
    -e DRONE_SECRET=${DRONE_SECRET} \
    drone/agent:0.8
}
_jenkins-lts(){
  local DOCKER=jenkins
  docker volume create "${DOCKER}-lts-data"
  docker run -d\
    --name "$DOCKER-lts"\
    --rm\
    -u root\
    -P \
    -v "$(which docker):/bin/docker"\
    -v "${DOCKER}"-data:/var/jenkins_home\
    -v /var/run/docker.sock:/var/run/docker.sock\
    -v "$HOME":/home\
    jenkins/"$DOCKER":lts
}
