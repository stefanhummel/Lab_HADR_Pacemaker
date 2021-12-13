#! /bin/bash
if [ "$1" != "--no-register" ];then
  if [ -z $rhsm_user ];then
    echo 'Subscripion manager user (rshm_user):'
    read rhsm_user
    if [ -z $rhsm_user ];then
      echo "Error: Subscription manager user not entered. Red Hat Subscription Manager user must be set in environment v
ariable rhsm_user or entered at prompt"
      exit 1
    fi
  fi
  if [ -z $rhsm_password ];then
    echo 'Subscripion manager password (rshm_password):'
    read -s rhsm_password
    if [ -z $rhsm_password ];then
      echo "Error: Subscription manager password not entered. Red Hat Subscription Manager password must be set in envir
onment variable rhsm_password or entered at prompt"
      exit 1
    fi
  fi
  if [ -z $rhsm_pool_id ];then
    echo 'Subscription manager pool ID (rhsm_pool_id):'
    read rhsm_pool_id
    if [ -z $rhsm_pool_id ];then
      echo "Error: Subscription manager pool ID not entered. Red Hat Subscription Manager password must be set in enviro
nment variable rhsm_pool_id or entered at prompt"
      exit 1
    fi
  fi
  # Check if configured to wrong RSHM
  if subscription-manager config | grep -E "^\s*hostname\s*=" | grep -q "subscription.rhsm.redhat.com";then
    echo "Subscription manager already configured correctly"
  else
    echo "Re-registering Red Hat Subscription Manager ..."
    subscription-manager clean
    echo "Configuring Red Hat Subscription Manager"
    subscription-manager config \
      --server.hostname=subscription.rhsm.redhat.com \
      --server.port=443 \
      --server.prefix="/subscription" \
      --rhsm.baseurl=https://cdn.redhat.com \
      --rhsm.repo_ca_cert=/etc/rhsm/ca/redhat-uep.pem
  fi
  echo "Registering to subscription manager and attaching pool ..."
  subscription-manager register --username="$rhsm_user" --password="$rhsm_password" --force
  subscription-manager attach --pool="$rhsm_pool_id"
fi

