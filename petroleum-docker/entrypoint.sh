if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

cd /petroleum-blockchain

. ./activate

petroleum init

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  petroleum keys generate
elif [[ ${keys} == "copy" ]]; then
  if [[ -z ${ca} ]]; then
    echo "A path to a copy of the farmer peer's ssl/ca required."
	exit
  else
  petroleum init -c ${ca}
  fi
else
  petroleum keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    petroleum plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.petroleum/mainnet/config/config.yaml

petroleum configure -log-level INFO

if [[ ${farmer} == 'true' ]]; then
  petroleum start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    petroleum configure --set-farmer-peer ${farmer_address}:${farmer_port}
    petroleum start harvester
  fi
else
  petroleum start farmer
fi

#farmr
if [ -f "/farmr/blockchain/xch.json" ] ; then
	rm /farmr/blockchain/xch.json
fi 

if [ ! -f "/farmr/blockchain/${crypto}.json" ] ; then
wget https://raw.githubusercontent.com/arturasaleknavicius/chia-forks-docker/master/farmr_json/${crypto}.json -P /farmr/blockchain
fi

while true; do sleep 30; done;