#!/bin/bash

# Add the following to the very top of your ~/.ssh/config file
# Host Multipass-*
# IdentityFile ~/.ssh/multipass
# User ubuntu


# Create an array of multipass instance ips
readarray -t ips < <(multipass ls| awk '{print $3}')

# Create an array of multipass instance name
readarray -t names < <(multipass ls| awk '{print $1}')

# Remove the 1st element, which is the string "IPv4"

# Method 1 => index will not get changed. The value corresponding to 
# index 1 is the same, but index 0 is removed.
# unset ips[0]

# Method 2 => index will get changed
# Index 0 is now the value of index 1, index 1 is now the value of index 2, etc.
ips=("${ips[@]:1}")
names=("${names[@]:1}")

# Print the array, for debugging purpose
# declare -p ips


# Append the multipass instance info to the ssh config
INDEX=0
for ip in "${ips[@]}"; do 
echo "Host Multipass-${names[$INDEX]}" >> ~/.ssh/config
echo "  HostName $ip" >> ~/.ssh/config
echo -e "\n" >> config
let INDEX=${INDEX}+1
done
