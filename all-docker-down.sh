. ./dev-env.sh
echo "Stop infinispan container"
cd $HOME/infinispan
./docker-stop.sh

echo "Stop weblogic container"
cd $HOME/weblogic
./docker-stop.sh

echo "Stop wildfly container"
cd $HOME/wildfly
./docker-stop.sh

rm $HOME/containers_info/*


echo "All Down"
