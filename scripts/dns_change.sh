#!/bin/bash

read -p "Enter the new DNS address (e.g., 1.1.1.1): " NEW_DNS

# Validate input using regex for IPv4 format
if [[ ! "$NEW_DNS" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
   echo "Error: Invalid DNS format. Please enter a valid IPv4 address (e.g., 8.8.8.8)."
   exit 1
fi

# Validate each octet is between 0 and 255
IFS='.' read -r -a OCTETS <<< "$NEW_DNS"
for OCTET in "${OCTETS[@]}"; do
   if (( OCTET < 0 || OCTET > 255 )); then
      echo "Error: Each segment of the IP must be between 0 and 255."
      exit 1
   fi
done

TMP_FILE="/tmp/resolv.conf.tmp"

awk -v dns="$NEW_DNS" '
   BEGIN { replaced = 0 }
   /^nameserver/ {
      if (!replaced) {
         print "nameserver " dns
         replaced = 1
      }
      next
   }
   { print }
' /etc/resolv.conf > "$TMP_FILE"

sudo mv "$TMP_FILE" /etc/resolv.conf

echo "DNS was successfully changed to $NEW_DNS!"
