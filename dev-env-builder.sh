#!/bin/bash
. ./dev-env.sh
. ./dev-func.sh

#Usage : getInfo infinispan .NetworkSettings.IPAddress
#test=$(getInfo infinispan .NetworkSettings.IPAddress)
#echo $test +"TTT"
getInfo() 
{
      echo  `cat ./containers_info/$1_info.json | ./jq $2`
}

deleteBracket()
{
   json_info=$(cat ./$1_info.txt)
   len=$((${#json_info}-2))
   echo ${json_info:1:${len}} > ./containers_info/$1_info.json
   rm ./$1_info.txt
   echo "$1_info.json is saved"
}



# Create folder to store containers information
echo "# Create folder to store containers information" 
echo "============================================================================"
if [ ! -d $KHAN_HOME/containers_info ]; then
   mkdir -p $KHAN_HOME/containers_info
   echo "./containers_info folder is created"
else 
   echo " ./containers_info folder is existed." 
   echo "This folder will store container detail information."
fi
echo $LINE_BLANK

# Create a shared folder which will be used for deploying sample application
echo "# Create a shared folder which will be used for deploying sample application"
echo "============================================================================"
if [ ! -d ~/khan_session_dev/applications ]; then
   mkdir -p ~/khan_session_dev/applications
   echo "~/khan_session_dev/applications folder is created"
else 
   echo "~/khan_session_dev/applications folder is existed." 
   echo "This folder will be used for shared application folder."
fi
echo $LINE_BLANK

# Check if docker daemon is running
Is_Docker_Running

echo $LINE_BLANK
#Download jq
Processor=$(uname -p)
echo "# Checking if jq file exist.."
echo "============================================================================"
if [ ! -f $KHAN_HOME/jq ]; then
   if [ $Processor == x86_64 ]; then
      echo "64bit"
      wget http://stedolan.github.io/jq/download/linux64/jq 
   else
      echo "32bit"
      wget http://stedolan.github.io/jq/download/linux32/jq
   fi
else
   echo "jq is already downloaded"
fi
chmod +x ./jq

echo $LINE_BLANK
#Get docker images 
# - Weblogic
# - Wildfly
# - Infinispan
echo "# Pulling docker images"
echo "============================================================================"
# weblogic images
if (docker images |grep ljhiyh/centos65 |grep weblogic1213)
then 
   echo "Weblogic images is exist"
else
   echo "Weblogic images is not exist. It is pulling from docker hub now..."
   docker pull ljhiyh/centos65:weblogic1213
fi

# wildfly images
if (docker images |grep ljhiyh/centos65 |grep wildfly8)
then 
   echo "Wildfly images is exist"
else
   echo "Wildfly images is not exist. It is pulling from docker hub now..."
   docker pull ljhiyh/centos65:wildfly8
fi

# infinispan images
if (docker images |grep ljhiyh/centos65 |grep infinispan711)
then 
   echo "Infinispan images is exist"
else
   echo "Infinispan images is not exist. It is pulling from docker hub now..."
   docker pull ljhiyh/centos65:infinispan711
fi

echo $LINE_BLANK
#docker run 
echo "# Running docker containers"
echo "============================================================================"
echo "Run infinispan container"
cd $KHAN_HOME/infinispan
./docker-start.sh

echo "Run weblogic container"
cd $KHAN_HOME/weblogic
./docker-start.sh

echo "Run wildfly container"
cd $KHAN_HOME/wildfly
./docker-start.sh

echo $LINE_BLANK
cd $KHAN_HOME
echo "waiting for start up docker containers"
#sleep 3

echo $LINE_BLANK
# Store information of each container to file
echo "# Storing each docker container information"
echo "============================================================================"
docker inspect infinispan >./infinispan_info.txt
deleteBracket infinispan

docker inspect weblogic >./weblogic_info.txt
deleteBracket weblogic

docker inspect wildfly >./wildfly_info.txt
deleteBracket wildfly


echo $LINE_BLANK
#Configure infinispan
echo "# Configuring each software "
echo "============================================================================"
echo "Configuring infinispan..." 
docker exec infinispan /home/jhouse/infinispan/infinispan-server/bin/clustered.sh  -b $(getInfo infinispan .NetworkSettings.IPAddress)  &
sleep 10
docker exec infinispan /home/jhouse/infinispan/infinispan-server/bin/jboss-cli.sh --file=./khan-cache-add.cli -c
docker exec infinispan /home/jhouse/infinispan/infinispan-server/bin/jboss-cli.sh --command=":restart" -c &> /dev/null
echo "Configuring and running infinispan done." 

echo $LINE_BLANK
echo "Configuring weblogic..." 
docker exec weblogic /home/jhouse/oracle/wls12130/domains/weblogic-test-server/bin/startWebLogic.sh  &
#docker exec weblogic /home/jhouse/oracle/wls12130/wlserver/common/bin/wlst.sh -skipWLSModuleScanning /home/jhouse/oracle/update-wls-ip.py
#docker exec weblogic /home/jhouse/oracle/wls12130/domains/weblogic-test-server/bin/startWebLogic.sh -b $(getInfo infinispan .NetworkSettings.IPAddress)  &

echo "Running wildfly..." 
docker exec wildfly /home/jhouse/wildfly/bin/standalone.sh  -b $(getInfo wildfly .NetworkSettings.IPAddress)  &
#docker exec wildfly /home/jhouse/wildfly/bin/standalone.sh  -b $(getInfo wildfly .NetworkSettings.IPAddress)  &
echo "Develpment Environment Set Up Finished!!"
