#!/usr/bin/env bash

set -ex

DOCKER="postgres"
POSTGRES_PASSWORD="test"
POSTGRES_USER="test"

docker pull ${DOCKER}

if [ $(docker inspect --format='{{.State.Running}}' $DOCKER) ];then docker stop ${DOCKER}; docker volume rm "${DOCKER}"-data; fi

docker volume create "${DOCKER}"-data
docker run -it -d \
    --label "$DOCKER" \
    --name "$DOCKER" \
    --rm \
    -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
    -e POSTGRES_USER="${POSTGRES_USER}" \
    -p 5432:5432 \
    -v "${DOCKER}"-data:/var/lib/postgresql/data \
  ${DOCKER}


while ! docker inspect --format='{{.State.Running}} ' $DOCKER; do sleep 1; done  
while ! nc -z 0.0.0.0 5432; do sleep 1; done


export PGHOST="0.0.0.0"
export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGDATABASE="postgres"

# Testing login from local client
# psql -v ON_ERROR_STOP=1 -tAc "SELECT current_user;" 

# Ansible 
playbook_file="/tmp/playbook.yml"
/bin/cat <<EOL | tee ${playbook_file}
---

- name: Provision postgres db 
  hosts: localhost
  gather_facts: true

  vars:
    dbname: "{{dbname}}"
    dbuser: "{{dbuser}}"
    dbpass: "{{dbpass}}"

  tasks:

  - name: Create db
    postgresql_db: >
      encoding=UTF-8
      template='template0'
      name={{dbname}}
      state=present
      login_host={{login_host}}
      login_password={{login_password}}
      login_user={{login_user}}

  - name: Create user and give access to database
    postgresql_user: >
      db={{dbname}}
      name={{dbuser}}
      priv="CONNECT"
      encrypted='yes'
      password="{{dbpass}}"
      no_password_changes='yes'
      state=present
      login_host={{login_host}}
      login_password={{login_password}}
      login_user={{login_user}}

  - name: Ensure user has necessary roles
    postgresql_user: >
      db={{dbname}}
      name={{dbuser}}
      password="{{dbpass}}"
      encrypted='yes'
      state=present
      role_attr_flags="LOGIN,CREATEDB"
      login_host={{login_host}}
      login_password={{login_password}}
      login_user={{login_user}}

  - name: Ensure the user has schema privileges
    postgresql_privs: >
      privs=ALL
      type=schema
      objs=public
      role={{dbuser}}
      db={{dbname}}
      login_host={{login_host}}
      login_password={{login_password}}
      login_user={{login_user}}

  - name: Fix permissions
    shell: |
      PGHOST={{login_host}} PGDATABASE=postgres PGUSER={{login_user}} PGPASSWORD={{login_password}} psql -tAc '{{item}}'
    with_items:
    - "GRANT CREATE ON DATABASE {{dbname}} TO {{dbname}};"

##
# Switch over as new user:
##

  - name: Ensure user can login
    shell: |
      PGHOST={{login_host}} PGDATABASE={{dbname}} PGUSER={{dbuser}} PGPASSWORD={{dbpass}} psql -tAc '{{item}}'
    with_items:
    - "SELECT current_user;"
EOL

login_host="${PGHOST}"
login_password="${PGPASSWORD}"
login_user="${PGUSER}"

dbname="foo"
dbuser="foo"
dbpass="foo"

echo "ANSIBLE_NOCOLOR=true PYTHONUNBUFFERED=1 ansible-playbook -vvv --connection=local \
  ${playbook_file} \
  --extra-vars='login_host=${login_host} login_password=${login_password} login_user=${login_user}    dbname=${dbname} dbuser=${dbuser} dbpass=${dbpass}'" | sh
