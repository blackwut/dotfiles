#!/bin/bash

echo "WoW-FI routine started!"
while true
do
    if [ $(networksetup -getinfo Wi-Fi | grep -c 'IP address:') = '1' ] #ho notato che quando vieni disconnesso perdi l'IP.
    then
        networksetup -setairportpower en0 off > /dev/null #disattiva il wifi
        networksetup -setairportpower en0 on  > /dev/null #riattiva il wifi
        echo "$(date) - WoW-FI Resetted"               #scrive che è stata resettata la connessione su terminale
        sleep 60 #evita rimbalzi nel caso il DHCP sia un po' lento a darti l'IP o la connessione non prenda bene
    fi
    sleep 1 # ogni secondo controlla se la connessione si è staccata.
done
