aws rds describe-db-instances --query 'DBInstances[*].{ARN:DBInstanceArn,Engine:Engine,ID:DBInstanceIdentifier}'
