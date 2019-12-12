
# db instances
aws rds describe-db-instances --output table --query 'DBInstances[].[Engine,DBInstanceIdentifier,DBInstanceIdentifier,DBInstanceClass,LatestRestorableTime]'

# cluster snapshots:
for id in `aws rds describe-db-clusters --query 'DBClusters[].DBClusterIdentifier' --output text`; do 
  echo \#$id:; 
    aws rds describe-db-cluster-snapshots \
    --db-cluster-identifier $id \
    --query 'DBClusterSnapshots[].[SnapshotType,DBClusterIdentifier,SnapshotCreateTime]' \
    --output table ; 
  echo \\n; 
done
