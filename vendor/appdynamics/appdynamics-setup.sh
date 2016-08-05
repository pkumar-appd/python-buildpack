#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

BUILD_DIR=$1

if [ `echo $VCAP_SERVICES | grep -c "appdynamics" ` -gt 0 ];
then
  mkdir -p $BUILD_DIR/.profile.d
  SETUP_APPDYNAMICS=$BUILD_DIR/.profile.d/appdynamics-setup.sh

  #set application name
  if [ -z "$APPD_APP_NAME" ]; then
    echo "export APPD_APP_NAME=`echo $APPD_APP_NAME`" >> $SETUP_APPDYNAMICS
  elif [[ $VCAP_SERVICES == *application-name* ]]; then
    echo "export APPD_APP_NAME=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"application-name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "export APPD_APP_NAME=`echo $VCAP_APPLICATION | python -m json.tool | sed -n -e '/"application_name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  fi

  #set tier name
  if [ -z "$APPD_TIER_NAME" ]; then
   echo "export APPD_TIER_NAME=`echo $APPD_TIER_NAME`" >> $SETUP_APPDYNAMICS
  elif [[ $VCAP_SERVICES == *tier-name* ]]; then
    echo "export APPD_TIER_NAME=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"tier-name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "export APPD_TIER_NAME=`echo $VCAP_APPLICATION | python -m json.tool | sed -n -e '/"application_name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  fi

  #set node name
  if [ -z "$APPD_NODE_NAME" ]; then
    echo "export APPD_NODE_NAME=`echo $APPD_NODE_NAME`" >> $SETUP_APPDYNAMICS
  elif [[ $VCAP_SERVICES == *node-name* ]]; then
    echo "export APPD_NODE_NAME=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"node-name":/ s/^.*"\(.*\)".*/\1/p'`:`echo $VCAP_APPLICATION | python -m json.tool | sed -n -e '/"instance_index":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "export APPD_NODE_NAME=`echo $VCAP_APPLICATION | python -m json.tool | sed -n -e '/"application_name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  fi

  #set host name
  if [[ $VCAP_SERVICES == *host-name* ]]; then
    echo "export APPD_CONTROLLER_HOST=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"host-name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "Unable to find controller host"
  fi

  #set port name
  if [[ $VCAP_SERVICES == *port* ]]; then
    echo "export APPD_CONTROLLER_PORT=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"port":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "Unable to find controller port"
  fi

  #set ssl enable
  if [[ $VCAP_SERVICES == *ssl-enabled* ]]; then
    echo "export APPD_SSL_ENABLED=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"ssl-enabled":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "Unable to find ssl enabled flag"
  fi

  #set account-access-key
  if [[ $VCAP_SERVICES == *account-access-key* ]]; then
    echo "export APPD_ACCOUNT_ACCESS_KEY=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"account-access-key":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "Unable to find controller account access key"
  fi

  #set account-name
  if [[ $VCAP_SERVICES == *account-name* ]]; then
    echo "export APPD_ACCOUNT_NAME=`echo $VCAP_SERVICES | python -m json.tool | sed -n -e '/"account-name":/ s/^.*"\(.*\)".*/\1/p'`" >> $SETUP_APPDYNAMICS
  else
    echo "Unable to find controller account name"
  fi
fi
