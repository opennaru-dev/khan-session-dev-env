#!/bin/bash

Is_Docker_Running(){
# Check if docker daemon is running
echo "# Check if docker daemon is running"
echo "============================================================================"
if (! ps -ef|grep "/usr/bin/docker" |grep -v 'grep' &> /dev/null  )
then
   echo "Docker is not running!!"
   echo "Trying to start docker daemon"         
   service docker start &> ./error.log

   if [ $? -eq "1" ];then
      echo "Docker is successfully started!"
   else
      echo "There are some problems to start docker up such as permissions"
      echo "Please check ./error.log"
      exit
   fi
else 
   echo "Docker is running"
fi
}


