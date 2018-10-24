#!/usr/bin/env bash

set -x

BUCKET_NAME=$CLUSTER_NAME.$DOMAIN_NAME-$(date %s)
SSH_KEY=$CLUSTER_DOMAIN.pub
group_name=kops
IP_ADDRESS=$(curl -s http://ipinfo.io/ip)

export AWS_DEFAULT_PROFILE=${AWS_DEFAULT_PROFILE:-awskops}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-eu-west-1}
export CLUSTER_NAME=${CLUSTER_NAME:-foo}
export CLUSTER_DOMAIN=${CLUSTER_DOMAIN:-k8s.local}
export KOPS_STATE_STORE=s3://$BUCKET_NAME


print_versions() {
  $kops version
  $aws --version
  $kubectl version
}

main() {
  action="$1"

  aws=$(which aws) || exit 1
  kops=$(which kops) || exit 1
  kubectl=$(which kubectl) || exit 1

  $aws sts get-caller-identity || exit 1

  case "$action" in

    "createkeys")
      $aws ec2 create-key-pair --key-name "$SSH_KEY" | jq -r '.KeyMaterial' | tee "$CLUSTER_NAME.pem"
      chmod 400 "$CLUSTER_NAME.pem"
      ssh-keygen -y -f "$CLUSTER_NAME.pem" > "$CLUSTER_NAME.pub"
      cp -f "$CLUSTER_NAME.pem" ~/.ssh/
      cp -f "$CLUSTER_NAME.pub" ~/.ssh/
      ;;

    "create_iam_group")
      echo "*** Creating IAM group $group_name and attaching IAM policies: ***"
      $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name "$group_name"
      $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name "$group_name"
      $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name "$group_name"
      $aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IamFullAccess --group-name "$group_name"
      ;;

    "create_s3")
      $aws s3api create-bucket \
       --acl=private\
       --bucket "$BUCKET_NAME" \
       --create-bucket-configuration LocationConstraint="$AWS_DEFAULT_REGION" || exit 1
      ;;

    "create_cluster")
      $aws s3 ls "$BUCKET_NAME" &>/dev/null || exit 1
      $aws iam get-group --group-name $group_name &>/dev/null || exit 1
      ls -al "$CLUSTER_NAME.pem" || exit 1
      ls -la "$CLUSTER_NAME.pub" || exit 1

      MASTER_COUNT=3
      NODE_COUNT=3
      NETWORKING=kubenet
      KUBERNETES_VERSION=v1.8.4
      AUTHORIZATION=RBAC

      echo "*** Creating $CLUSTER_NAME.$CLUSTER_DOMAIN: ***"

      $kops create cluster\
        --name "$CLUSTER_NAME.$CLUSTER_DOMAIN"\
        --node-count "$NODE_COUNT"\
        --master-count "$MASTER_COUNT"\
        --node-size "$NODE_SIZE"\
        --master-size "$MASTER_SIZE"\
        --zones "$ZONES"\
        --master-zones "$ZONES"\
        --ssh-public-key "$SH_PUBLIC_KEY"\
        --networking "$NETWORKING"\
        --ssh-access="${IP_ADDRESS}/32"\
        --admin-access="${IP_ADDRESS}/32" \
        --kubernetes-version "$KUBERNETES_VERSION"\
        --authorization "$AUTHORIZATION"\
        --yes
      #$kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.8.3.yaml
    ;;

  "create_private")
      $aws s3 ls "$BUCKET_NAME" &>/dev/null || exit 1
      $aws iam get-group --group-name $group_name &>/dev/null || exit 1

      echo "*** Creating $CLUSTER_NAME.$CLUSTER_DOMAIN with private topology: ***"

      # Create a cluster in AWS that has HA masters.  This cluster
      # will be setup with an internal networking in a private VPC.
      # A bastion instance will be setup to provide instance access.

      $kops create cluster\
          --name "$CLUSTER_NAME.$CLUSTER_DOMAIN"\
          --node-count 3 \
          --zones "$ZONES" \
          --node-size "$NODE_SIZE" \
          --master-size "$MASTER_SIZE" \
          --master-zones "$ZONES" \
          --networking weave \
          --topology private \
          --bastion="true" \
          --yes
      ;;

    "status")
      echo "Status: $CLUSTER_NAME.$CLUSTER_DOMAIN:"
      $kops get cluster
      $kubectl cluster-info
      $kops validate cluster
      ;;

    "delete")
      echo "*** Deleting $CLUSTER_NAME.$CLUSTER_DOMAIN: ***"
      $kops delete cluster \
        --name "$CLUSTER_NAME.$CLUSTER_DOMAIN"\
        --state=s3://"${BUCKET_NAME}"\
        --yes
      sleep 1
      echo "Deleting bucket: ${BUCKET_NAME}"
      $aws s3 rm s3://"${BUCKET_NAME}" --recursive
      $aws s3api delete-bucket --bucket "$BUCKET_NAME"
      ;;

    *)
      echo "<info>|<create_cluster>|<create_group>|<delete>|<status>"
      ;;

  esac
}

main "$@"
