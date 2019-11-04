aws ec2 describe-instances --filters 'Name=tag:Environment,Values=development' --query '[Reservations[*].Instances[*].PublicDnsName]'  
