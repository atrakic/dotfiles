# https://loige.co/aws-command-line-s3-content-from-stdin-or-to-stdout/


# dump the data from PostgreSQL to a compressed csv
psql -U user -d db_name -c "Copy (Select * From geoip_v4) To STDOUT With CSV HEADER DELIMITER ',';" | gzip > geoip_v4_data.csv
# upload the resulting file to S3
aws s3 cp geoip_v4_data.csv.gz s3://my-amazing-bucket/geoip_v4_data.csv.gz

# download the file from S3
aws s3 cp s3://my-amazing-bucket/geoip_v4_data.csv.gz .
# decompress the file and search inside it
gunzip -c geoip_v4_data.csv.gz | grep "1.0.8.0/21"


cat "hello world" | aws s3 cp - s3://some-bucket/hello.txt
psql -U user -d db_name -c "Copy (Select * From geoip_v4) To STDOUT With CSV HEADER DELIMITER ',';" \
  | gzip | aws s3 cp - s3://my-amazing-bucket/geoip_v4_data.csv.gz

aws s3 cp s3://some-bucket/hello.txt -

aws s3 cp s3://my-amazing-bucket/geoip_v4_data.csv.gz - | gunzip -c geoip_v4_data.csv.gz | grep "1.0.8.0/21"

aws s3 cp s3://my-images/image.png - | imagemin | aws s3 cp - s3://my-images-optimized/image.png
