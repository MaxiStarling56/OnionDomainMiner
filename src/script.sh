#!/bin/bash
# Banner
echo " ██████╗    ██████╗    ███╗   ███╗   "
echo "██╔═══██╗   ██╔══██╗   ████╗ ████║   "
echo "██║   ██║   ██║  ██║   ██╔████╔██║   "
echo "██║   ██║   ██║  ██║   ██║╚██╔╝██║   "
echo "╚██████╔╝██╗██████╔╝██╗██║ ╚═╝ ██║██╗"
echo " ╚═════╝ ╚═╝╚═════╝ ╚═╝╚═╝     ╚═╝╚═╝"

# Creating the directory to operate on
mkdir -p /odm/hidden_service/
chmod 700 /odm/hidden_service/

# Modifying the tor configuration files
echo "HiddenServiceDir /odm/hidden_service/" > /etc/tor/torrc
echo "HiddenServicePort 80 127.0.0.1:80" >> /etc/tor/torrc
echo "HiddenServicePort 443 127.0.0.1:443" >> /etc/tor/torrc

# Getting/Setting env vars
REGEX="${REGEX:-.}"                                     

# Killing tor before starting
if [[ $(pidof tor) ]]; then
    kill -9 $(pidof tor)
fi

echo "Mining... (Regex => $REGEX)"
# Forever Loop
while true
do
    # Mining the domain
    tor | while read line ;
    do
        if [[ "$(echo $line | grep Done)" ]] # The domain is generated
        then
            # Cleaning the domain
            domain=$(cat /odm/hidden_service/hostname | sed 's/.onion//')

            # If the domain verify the regex ...
            if [[ domain =~ $REGEX ]]
            then
                # ... will be saved ...
                echo "Saving $domain"
                mkdir -p /odm/domains/$domain
                mv /odm/hidden_service/* /odm/domains/$domain/
            else
                # ... else will be discarded.
                echo "$domain does not match regex"
                rm -rf /odm/hidden_service/*
            fi

            # Killing tor
            kill -9 $(pidof tor)
        fi
    done
done