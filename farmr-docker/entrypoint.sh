# Setup Farmr Files
#if [ ! -d "/data/farmr/config" ] ; then
#	mkdir -p /data/farmr/config
#fi
#rm -rf /farmr/config
#ln -fs /data/farmr/config /farmr/config
#
#if [ ! -d "/data/farmr/cache" ] ; then
#	mkdir -p /data/farmr/cache
#fi
#rm -rf /farmr/cache
#ln -fs /data/farmr/cache /farmr/cache
#ln -fs /data/farmr/id.json /farmr/id.json
if [ -f "/farmr/blockchain/xch.json" ] ; then
	rm /farmr/blockchain/xch.json
fi 
wget https://raw.githubusercontent.com/arturasaleknavicius/chia-forks-docker/master/farmr_json/${crypto}.json -P /farmr/blockchain
#mv /farmr/blockchain/xeth.json.template /farmr/blockchain/xeth.json

while true; do sleep 30; done;