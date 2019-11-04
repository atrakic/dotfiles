#/bin/sh 

# https://wiki.debian.org/Cloud/AmazonEC2Image/Jessie 

#### SSH to Debian instances as user admin using your SSH key, and then sudo -i to gain root access.### 

aws ec2 describe-images --owners 379101102735 --filters "Name=architecture,Values=x86_64" "Name=name,Values=debian-jessie-*" "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm" 
