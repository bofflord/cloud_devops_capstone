IP=$1
PORT=$2
echo "IP address: $IP"
echo "port number: $PORT"
RESULT=$(./make_prediction.sh "$IP" "$PORT" | jq .'prediction'[0])
if $RESULT==20.35373177134412
    then 
        echo "Smoketest passed."; exit 1
    else
        echo "Smoketest failed."; exit 0
fi