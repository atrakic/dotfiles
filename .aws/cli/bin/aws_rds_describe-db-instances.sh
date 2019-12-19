aws rds describe-db-instances --output table --query 'DBInstances[].[Engine,DBInstanceIdentifier,DBInstanceIdentifier,DBInstanceClass,BackupRetentionPeriod,LatestRestorableTime]'
