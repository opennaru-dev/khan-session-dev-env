#!/bin/bash
Build_All_Images(){
# All docker images building 
echo "# All docker images building"
echo "============================================================================"
echo "Build infinispan Image"
cd $KHAN_HOME/infinispan
./docker-builder.sh

echo "Build weblogic Image"
cd $KHAN_HOME/weblogic
./docker-builder.sh

echo "Build wildfly Image"
cd $KHAN_HOME/wildfly
./docker-builder.sh

echo $LINE_BLANK
cd $KHAN_HOME
echo "All Images are built up"
docker images |grep ljhiyh/centos65
}

#Check if docker daemon is running
Is_Docker_Running

if [ ! $# -eq 1 ]; then
   echo "Usage: docker-build.sh infinispan|weblogic|wildfly|all"
   echo "Build image for khan session manager demo"
else
   case $1 in
       infinispan)
         echo "infinispan image is building now"
         cd $KHAN_HOME/infinispan
         `pwd`
         ./docker-builder.sh
         ;;
       weblogic)
         echo "weblogic image is building now"
         cd $KHAN_HOME/weblogic
         ./docker-builder.sh
         ;;
       wildfly)
         echo "wildfly image is building now"
         cd $KHAN_HOME/wildfly
         ./docker-builder.sh
         ;;
       all)
         echo "All images are building now"
         Build_All_Images
         ;;
       *)
         echo "Please select one of those : infinispan, weblogic, infinispan"
         ;;
   esac
fi
