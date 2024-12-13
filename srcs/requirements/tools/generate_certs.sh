#!/bin/bash

# Define the list of domains
domains=(zel-bouz.42.fr zel-bouz.adminer.42.fr)

# Check if an argument is passed for the output directory, otherwise use the default value
if [ -z "$1" ]; then
    output_dir="certs"
else
    output_dir="$1"
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Use OpenSSL to generate the self-signed certificate with additional subject information (organization and location)
openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout "$output_dir/${domains[0]}.key" \
    -out "$output_dir/${domains[0]}.crt" -days 365 \
    -subj "/CN=${domains[0]}/O=1337/L=Morocco/C=MA/ST=Agadir" \
    -extensions SAN \
    -config <(echo -e "[req]\ndistinguished_name=dn\n[dn]\n[SAN]\nsubjectAltName=$(printf "DNS:%s," "${domains[@]}" | sed 's/,$//')")
