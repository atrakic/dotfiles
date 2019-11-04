### aws "$@" ec2 describe-security-groups --filters "Name=ip-permission.from-port,Values=22 Name=ip-permission.to-port,Values=22 Name=ip-permission.cidr,Values='0.0.0.0/0'" --query 'SecurityGroups[*].{Name:GroupName}'

aws ec2 describe-security-groups \
  --filters "Name=ip-permission.to-port,Values=22"  \
  --query 'SecurityGroups[?length(IpPermissions[?ToPort==`22` && contains(IpRanges[].CidrIp, `0.0.0.0/0`)]) > `0`].{GroupName: GroupName, TagName: Tags[?Key==`Name`].Value | [0]}' \
  --output table

