#!/bin/bash
# This script will provide the R and S signature values for a ECDSA signature that
# can be included in a binary object to validate authenticity of the binary object.
####
PRIVATE="private.pem"
PUBLIC="public.pem"
DOCUMENT=${1}
if [ -z "${1}" ]; then
   echo Error, Plese provide one argument.. the file to create the signature for
   echo Syntax: signing.sh  BINARYFILE
   exit 1
fi
   ##
# Create private ECC key, use NIST 256 curve

if [ ! -f "$PRIVATE" ]; then
openssl ecparam -genkey -name prime256v1 -noout -out ${PRIVATE}
fi
# Create public key from private key
if [ ! -f "$PRIVATE" ]; then
openssl ec -in ${PRIVATE} -pubout -out ${PUBLIC}
fi
#
###
# Sign file
openssl dgst -sha256 -sign ${PRIVATE} ${DOCUMENT} > signature.bin
# dump R and S
R=`openssl asn1parse -inform DER -in signature.bin | sed -n '2p'|awk -F: ' { print $4 } '`
S=`openssl asn1parse -inform DER -in signature.bin | sed -n '3p'|awk -F: ' { print $4 } '`
echo R=${R}
echo S=${S}
###################
# if you want to manually valudate a file, here is the openssl command
#openssl dgst -sha256 -verify public.pem -signature signature.bin secret.doc
####################### 
