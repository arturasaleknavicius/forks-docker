if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

cd /ethgreen-blockchain

. ./activate

cethgreen init

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  ethgreen keys generate
elif [[ ${keys} == "copy" ]]; then
  if [[ -z ${ca} ]]; then
    echo "A path to a copy of the farmer peer's ssl/ca required."
	exit
  else
  ethgreen init -c ${ca}
  fi
else
  ethgreen keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    ethgreen plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.ethgreen/mainnet/config/config.yaml

ethgreen configure -log-level INFO

if [[ ${farmer} == 'true' ]]; then
  ethgreen start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    ethgreen configure --set-farmer-peer ${farmer_address}:${farmer_port}
    ethgreen start harvester
  fi
else
  ethgreen start farmer
fi

#farmr
if [ -f "/farmr/blockchain/xch.json" ] ; then
	rm /farmr/blockchain/xch.json
fi 
wget https://raw.githubusercontent.com/arturasaleknavicius/chia-forks-docker/master/farmr_json/${crypto}.json -P /farmr/blockchain

while true; do sleep 30; done;