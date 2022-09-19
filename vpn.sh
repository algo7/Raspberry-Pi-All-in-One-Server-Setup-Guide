#!/bin/bash

# Return to the case menu
while : ; do


# Option Menu
cat << EOF
Select Option:
1. List Active VPN Sessions
2. List Available Configs
3. Connect to CH5
4. Connect to DE5
5. Connect to DE6
6. Connect to UK5
7. Connect to UK6
8. Connect to FR4
9. Connect to FR5 [Not Working]
10. Connect to FR6 [Not Working]
11. Connect to Qual
12. Connect to Demo
13. Close Specific VPN Session
14. Close all Connections
15. Log Specific VPN Connection

EOF

# Read user input
read OPTION

## Global variables
# Create an array base on active connection names
readarray -t active_connection_names < <(openvpn3 sessions-list | grep "Config name:" | awk '{print $3}')

# Create an array base on active connection paths
readarray -t active_connection_paths < <(openvpn3 sessions-list | grep "Path" | awk '{print $2}')

readarray -t available_connection_names < <(openvpn3 configs-list | grep "$(whoami)" | awk '{print $1}')

# Function to check for duplicate VPN connections
function check_dup() {

# Print the array
# declare -p active_connections_names

# If the array contains the given connection name, then exit
if [[ "${active_connection_names[*]}" =~ $1 ]]; then
  echo -e "Duplicate Connection Attempted.\n"
  exit 1
fi
}

# Function to close a specific VPN connection
function close_specific_connection() {

# If there is no active connection, then exit
if [[ ${#active_connections[@]} == 0 ]]; then
  echo -e "No Active Connections Found.\n"
  exit 0
fi

# Print the array
echo "Active Connections:"
for i in "${active_connections[@]}"
do 
   echo "$i"
done

# Read user input
read -p "Enter the name of the connection you want to close: " CONNECTION_NAME

# Empty input check
if [[ -z "$CONNECTION_NAME" ]]; then
        echo -e "Connection Name is Required.\n"
        exit 1
fi

# If the array doesn't contain the given connection name, then exit
if [[ ! "${active_connections[*]}" =~ "$CONNECTION_NAME" ]]; then
  echo -e "No Such Connection.\n"
  exit 1
fi

CONNECTION_TO_CLOSE=`openvpn3 sessions-list | grep "$CONNECTION_NAME" -B 3 | grep Path | awk '{print $2}'`

openvpn3 session-manage --disconnect --path $CONNECTION_TO_CLOSE
}

# Function to close all active VPN connections
function close_all_connection() {

for i in "${active_connection_path[@]}"

# Loop through all paths and close all active connections
do 
   echo -e "Closing Connection: $i"
   openvpn3 session-manage --disconnect --path $i
done
}

# Log the given connection
function log_connection() {

# Read user input
read -p "Enter the name of the connection: " CONNECTION_NAME

# If the array doesn't contain the given connection name, then exit
if [[ ! "${available_connection_names[*]}" =~ "$CONNECTION_NAME" ]]; then
  echo -e "No Such Connection.\n"
  exit 1
fi

# Log the given connection
openvpn3 log --config $CONNECTION_NAME
}


# Switch case to handle user input
case $OPTION in

  1)
    echo -e "Active VPN Sessions: \n"
    openvpn3 sessions-list
    echo -e "\n"
    ;;

  2)
    echo -e "Available Configs: \n"
    openvpn3 configs-list
    ;;

  3)
    echo -e "Connect to CH5... \n"
    check_dup CH5
    openvpn3 session-start --config CH5
    ;;
  4)
    echo -e "Connect to DE5... \n"
    check_dup DE5
    openvpn3 session-start --config DE5
    ;;
  5)
    echo -e "Connect to DE6... \n"
    check_dup DE6
    openvpn3 session-start --config DE6
    ;;
  6)
    echo -e "Connect to UK5... \n"
    check_dup UK5
    openvpn3 session-start --config UK5
    ;;
  7)
    echo -e "Connect to UK6... \n"
    check_dup UK6
    openvpn3 session-start --config UK6
    ;;
  8)
    echo -e "Connect to FR4... \n"
    check_dup FR4
    openvpn3 session-start --config FR4
    ;; 
  9)
    echo -e "Connect to FR5... \n"
    check_dup FR5
    openvpn3 session-start --config FR5
    ;;
  10)
    echo -e "Connect to FR6... \n"
    check_dup FR6
    openvpn3 session-start --config FR6
    ;;
  11)
    echo -e "Connect to Qual... \n"
    check_dup Qual
    openvpn3 session-start --config Qual
    ;;
  12)
    echo -e "Connect to Demo... \n"
    check_dup Demo
    openvpn3 session-start --config Demo
    ;;
  13)
    close_specific_connection
    ;;
  14)
    echo -e "Close all Connections... \n"
    close_all_connection
    ;;
  15)
    log_connection
    ;;
  *)
    echo -e "Invalid Option!\n"
    ;;
esac

done
