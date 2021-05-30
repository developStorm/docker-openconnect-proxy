#!/bin/sh
# Credit to https://github.com/wazum/openconnect-proxy

if [[ -z "${SOCKS_USER}" ]]; then
  /usr/local/bin/microsocks -i 0.0.0.0 -p 1080 >/dev/null & 
else
  /usr/local/bin/microsocks -i 0.0.0.0 -p 1080 -u ${SOCKS_USER} -P ${SOCKS_PASSWORD} >/dev/null & 
fi

# Start openconnect
if [[ -z "${OPENCONNECT_PASSWORD}" ]]; then
# Ask for password
  openconnect -u $OPENCONNECT_USER $OPENCONNECT_OPTIONS $OPENCONNECT_URL
elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]] && [[ ! -z "${OPENCONNECT_MFA_HOTP}" ]]; then
  HOTP_COUNT=$(echo ${OPENCONNECT_MFA_HOTP} | sha256sum - | wget -q -O- "https://api.countapi.xyz/hit/"$(awk '{ print $1 }') | cut -d ":" -f2 | cut -d "}" -f1)
  HOTP_CODE=$(/proxy/otp -m hotp -s ${OPENCONNECT_MFA_HOTP} -c ${HOTP_COUNT})
  (echo $OPENCONNECT_PASSWORD; echo $HOTP_CODE) | openconnect -u "$OPENCONNECT_USER" "$OPENCONNECT_OPTIONS" --passwd-on-stdin "$OPENCONNECT_URL"
elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]] && [[ ! -z "${OPENCONNECT_MFA_CODE}" ]]; then
# Multi factor authentication (MFA)
  (echo $OPENCONNECT_PASSWORD; echo $OPENCONNECT_MFA_CODE) | openconnect -u "$OPENCONNECT_USER" "$OPENCONNECT_OPTIONS" --passwd-on-stdin "$OPENCONNECT_URL"
elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]]; then
# Standard authentication
  echo $OPENCONNECT_PASSWORD | openconnect -u "$OPENCONNECT_USER" "$OPENCONNECT_OPTIONS" --passwd-on-stdin "$OPENCONNECT_URL"
fi
