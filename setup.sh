#!/bin/bash
. ./dev-env.sh
echo "Hello, "$USER".  This script will help you set up ENV for khan session manager development."

Check_Value=1
while [ $Check_Value == 1 ]
do
  echo "  1) Docker Image Build "
  echo "  2) Set up Development Envinronment"
  echo -n  "(2): "
  read -n1  FIRST_SELECT
  if [[ $FIRST_SELECT == "" ]]; 
  then
    FIRST_SELECT=2
     Check_Value=0
  elif [ $FIRST_SELECT -gt 0 ] && [ $FIRST_SELECT -lt 3 ]; 
  then
     Check_Value=0
  else 
     echo "Please select 1 or 2"
  fi
done
echo $LINE_BLANK

#reset Check_Value for Second menu
Check_Value=1
if [ "$FIRST_SELECT" == "1" ];
then
  while [ $Check_Value == 1 ]
  do
    echo "Select image :"
    echo "  1) Infinispan"
    echo "  2) Weblogic"
    echo "  3) Wildfly"
    echo "  4) All"
    echo -n "(1): "
    read -n1 SEC_SELECT
    
    if [[ $SEC_SELECT == "" ]]; 
    then
        SEC_SELECT=1
       Check_Value=0
    elif [ $SEC_SELECT -gt 0 ] && [ $SEC_SELECT -lt 5 ]; then
       Check_Value=0
    else 
       echo "Please select 1 ~ 4"
    fi

    case $SEC_SELECT in
         1)
           DOCKER_IMAGE_NAME=infinispan
           ;;
         2)
           DOCKER_IMAGE_NAME=weblogic
           ;;
         3)
           DOCKER_IMAGE_NAME=wildfly
           ;;
         4)
           DOCKER_IMAGE_NAME=all
           ;;
         *)
           echo "Please select proper number"
           ;;
     esac
  done 
  echo $LINE_BLANK
  echo ./docker-build.sh $DOCKER_IMAGE_NAME
  ./docker-build.sh $DOCKER_IMAGE_NAME
else
  echo "Application folder path(~/khan_session_demo/applications):"
  ./dev-env-builder.sh
fi


