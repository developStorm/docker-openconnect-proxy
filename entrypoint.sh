#!/bin/sh
# Credit to https://github.com/wazum/openconnect-proxy

if [[ -z "${SOCKS_USER}" ]]; then
  /usr/local/bin/microsocks -i 0.0.0.0 -p 1080 & 
else
  /usr/local/bin/microsocks -i 0.0.0.0 -p 1080 -u ${SOCKS_USER} -P ${SOCKS_PASSWORD} & 
fi

# Start openconnect
if [[ -z "${OPENCONNECT_PASSWORD}" ]]; then
# Ask for password
  openconnect -u $OPENCONNECT_USER $OPENCONNECT_OPTIONS $OPENCONNECT_URL
elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]] && [[ ! -z "${OPENCONNECT_MFA_CODE}" ]]; then
# Multi factor authentication (MFA)
  (echo $OPENCONNECT_PASSWORD; echo $OPENCONNECT_MFA_CODE) | openconnect -u $OPENCONNECT_USER $OPENCONNECT_OPTIONS --passwd-on-stdin $OPENCONNECT_URL
elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]]; then
# Standard authentication
  echo $OPENCONNECT_PASSWORD | openconnect -u $OPENCONNECT_USER $OPENCONNECT_OPTIONS --passwd-on-stdin $OPENCONNECT_URL
fi
