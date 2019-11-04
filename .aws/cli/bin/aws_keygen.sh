ssh-keygen -t rsa -C "my-aws-key" -f ~/.ssh/my-aws-key
aws ec2 import-key-pair --key-name "my-aws-key" --public-key-material file://~/.ssh/my-aws-key.pub
aws ec2  describe-key-pairs
