#!/usr/bin/env bash

set -x

AWS_DEFAULT_PROFILE=awskops

export AWS_DEFAULT_PROFILE=awskops
export AWS_DEFAULT_REGION=eu-west-1
export KOPS_STATE_STORE=s3://devops23-1536755886 # states
export CLUSTER_NAME=aaaadasdasdfasdfasdf
export CLUSTER_DOMAIN=k8s.local

BUCKET_NAME=$CLUSTER_NAME.$DOMAIN_NAME-$(date %s)
SSH_KEY=$CLUSTER_DOMAIN.pub

aws=$(which aws) || exit 1
kops=$(which kops) || exit 1
kubectl=$(which kubectl) || exit 1

$aws sts get-caller-identity || exit 1
$kops version

action="$1"

case "$action" in

  "createkeys")
  aws ec2 create-key-pair --key-name "$SSH_KEY" | jq -r '.KeyMaterial' > $CLUSTER_NAME.pem
  chmod 400 "$CLUSTER_NAME.pem"
  ssh-keygen -y -f "$CLUSTER_NAME.pem" > "$CLUSTER_NAME.pub"
  ;;

  "create")
  MASTER_COUNT=3 #
  NODE_COUNT=1
  NODE_SIZE=t2.small
  MASTER_SIZE=t2.small
  ZONES=eu-west-1a,eu-west1b,eu-west-1c
  NETWORKING=kubenet
  KUBERNETES_VERSION=v1.8.4
  AUTHORIZATION=RBAC
  group_name=kops
  $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name "$group_name"
  $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name "$group_name"
  $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name "$group_name"
  $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IamFullAccess --group-name "$group_name"
  $aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --create-bucket-configuration LocationConstraint="$AWS_DEFAULT_REGION"
  export KOPS_STATE_STORE=s3://$BUCKET_NAME
  echo "Creating $CLUSTER_NAME.$CLUSTER_DOMAIN"
  $kops create cluster\
    --name "$CLUSTER_NAME.$CLUSTER_DOMAIN"\
    --master-count "$MASTER_COUNT"\
    --node-count "$NODE_COUNT"\
    --node-size "$NODE_SIZE"\
    --master-size "$MASTER_SIZE"\
    --zones "$ZONES"\
    --master-zones "$ZONES"\
    --ssh-public-key "$SH_PUBLIC_KEY"\
    --networking "$NETWORKING"\
    --kubernetes-version "$KUBERNETES_VERSION"\
    --authorization "$AUTHORIZATION"\
    --yes
  ;;

  "info")
  echo "$CLUSTER_NAME.$CLUSTER_DOMAIN:"
  $kops get cluster
  $kubectl cluster-info
  $kops validate cluster
  ;;

  "delete")
  $kops delete cluster \
    --name "$CLUSTER_NAME.$CLUSTER_DOMAIN"\
    --yes
  sleep 1
  $aws s3api delete-bucket --bucket "$BUCKET_NAME"
  ;;

  *)
  echo "<info>|<create>|<delete>"
  ;;

esac

echo "done"
