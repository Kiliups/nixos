#!/bin/bash
# This script extracts all the necessary information from the easyroam PKCS12 File and put it under /etc/easyroam-certs

# Usage:   bash easyroam_extract.sh <YOUR-PKCS12-File>
set -e

# check if we are root

if [[ $EUID -ne 0 ]]; then
    echo "You must be root to run easyroam_extract.sh" 1>&2
    exit 100
fi


ConfDir="/etc/easyroam-certs"

[ -d "$ConfDir" ] || mkdir -p "$ConfDir"

# check input file

if [ -z "$1" ]; then
        echo ""
        echo "Your pkcs12 file is missed as input parameter."
        echo ""
        exit 1
else
        InputFile="$1"
fi
# set openssl legacy options if necessary

LegacyOption=
OpenSSLversion=$(openssl version | awk '{print $2}' | sed -e 's/\..*$//')
if [ "$OpenSSLversion" -eq "3" ]; then
        LegacyOption="-legacy"
fi

# check pkcs12 file

Pwd="pkcs12"

if ! openssl pkcs12 -in "$InputFile" $LegacyOption -info -passin pass: -passout pass:"$Pwd" > /dev/null 2>&1; then
        echo ""
        echo "ERROR: The given input file does not seem to be a valid pkcs12 file."
        echo ""
        exit 1
fi


# extract key, cert, ca and identity

openssl pkcs12 -in "$InputFile" -clcerts $LegacyOption -nokeys -passin pass: -out "$ConfDir/easyroam_client_cert.pem"
openssl pkcs12 -in "$InputFile" $LegacyOption -nocerts -passin pass: -passout pass:"$Pwd" -out "$ConfDir/easyroam_client_key.pem"
openssl pkcs12 -info -in "$InputFile" $LegacyOption -nokeys -passin pass: -out "$ConfDir/easyroam_root_ca.pem" > /dev/null 2>&1
openssl x509 -noout -in "$ConfDir/easyroam_client_cert.pem" -subject | awk -F \, '{print $6}' | sed -e 's/.*=//' -e 's/\s*//' >  "$ConfDir/identity"
echo "Done."
