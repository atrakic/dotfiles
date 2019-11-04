PRIVATE_IP=`wget -q -O - 'http://169.254.169.254/latest/meta-data/local-ipv4'`
PUBLIC_IP=`wget -q -O - 'http://169.254.169.254/latest/meta-data/public-ipv4'
