#!/usr/bin/env bash

set -ex

DOCKER="postgres"
POSTGRES_PASSWORD="test"
POSTGRES_USER="test"

docker pull ${DOCKER}

docker volume rm "${DOCKER}"-data
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

export PGHOST="0.0.0.0"
export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGDATABASE="postgres"


# Ansible setup
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
      lc_collate='da_DK.utf8'
      lc_ctype='da_DK.utf8'
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
      state=present
      password="{{dbpass}}"
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

  - name: Ensure extensions has been installed
    postgresql_ext: >
      name="{{item}}"
      state=present
      db={{dbname}}
      login_host={{login_host}}
      login_password={{login_password}}
      login_user={{login_user}}
    with_items:
    - postgis
    - fuzzystrmatch

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
      #    - "ALTER DEFAULT PRIVILEGES IN SCHEMA {{dbname}} GRANT SELECT ON TABLES TO rlereaders;"
EOL

login_host=$PGHOST
login_password=$PGPASSWORD 
login_user=$PGUSER

echo "ANSIBLE_NOCOLOR=true PYTHONUNBUFFERED=1 ansible-playbook -vvv --connection=local \
  ${playbook_file} \
  --extra-vars='login_host=${login_host} login_password=${login_password} login_user=${login_user}' \
  --extra-vars='dbname=${dbname} dbuser=${dbuser} dbpass=${dbpass}'

