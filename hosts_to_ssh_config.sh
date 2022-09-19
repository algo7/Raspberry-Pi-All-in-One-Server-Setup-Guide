#!/bin/bash
input="./hosts"
while IFS= read -r line
do
  if [[ $line =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$* ]]; then
        HostName=`echo "$line" | awk '{print $1}'`
        Host=`echo "$line" | awk '{print $2}'`
        Host2=`echo "$line" | awk '{print $3}'`
        if [ -n "$Host2" ]; then
            echo "Host $Host $Host2" >> config
            echo "  HostName $HostName" >> config
            echo -e "\n" >> config
        else
            echo "Host $Host" >> config
            echo "  HostName $HostName" >> config
            echo -e "\n" >> config
        fi
  else
        echo "$line" >> config
  fi

done < "$input"
