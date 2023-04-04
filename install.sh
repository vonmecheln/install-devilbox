date=$(date '+%Y-%m-%d_%H-%M-%S')

BKP_DIR=bkp_devilbox_$date

cp -r devilbox/data $BKP_DIR 

rm -rf devilbox
git clone https://github.com/cytopia/devilbox

mv -r $BKP_DIR devilbox/data 

cd devilbox
cp env-example .env

HOST_PORT_MYSQL=3307
HOST_PORT_PGSQL=5433

sed -i 's/^\(TLD_SUFFIX\s*=\s*\).*$/\1loc/' .env
sed -i 's#^\(TIMEZONE\s*=\s*\).*$#\1America/Sao_Paulo#' .env
sed -i 's/^\(PHP_MODULES_ENABLE\s*=\s*\).*$/\1bcmath, ctype, fileinfo, json, mbstring, openssl, PDO, Tokenizer, XML, imagick/' .env
sed -i 's/^\(HTTPD_DOCROOT_DIR\s*=\s*\).*$/\1public/' .env
sed -i 's/^\(HTTPD_VHOST_SSL_TYPE\s*=\s*\).*$/\1redir/' .env
sed -i "s/^\(HOST_PORT_MYSQL\s*=\s*\).*$/\1$HOST_PORT_MYSQL/" .env
sed -i "s/^\(HOST_PORT_PGSQL\s*=\s*\).*$/\1$HOST_PORT_PGSQL/" .env

PASS="secret"
sed -i "s/^\(DEVILBOX_UI_PASSWORD\s*=\s*\).*\$/\1$PASS/" .env
sed -i "s/^\(DEVILBOX_HTTP_MGMT_PASSWORD\s*=\s*\).*\$/\1$PASS/" .env
sed -i "s/^\(MYSQL_ROOT_PASSWORD\s*=\s*\).*\$/\1$PASS/" .env
sed -i "s/^\(PGSQL_ROOT_PASSWORD\s*=\s*\).*\$/\1$PASS/" .env

docker-compose up
