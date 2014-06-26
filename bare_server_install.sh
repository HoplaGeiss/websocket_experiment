#!/bin/bash

sudo apt-get update
sudo apt-get install git python-software-properties -qq -y
sudo add-apt-repository ppa:chris-lea/node.js -y
sudo apt-get update
sudo apt-get install nodejs --quiet -y

# Time to run the usual script
wget 'https://raw.githubusercontent.com/HoplaGeiss/websocket_experiment/master/install.sh' -O - | sh
