#!/bin/bash

# Definition of a few function

info () {
  printf " [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}


# Actual code

sudo -v

echo ''
info 'Setting up the websocket experiment configuration'
info '============================================='
echo ''

echo ''
info 'Downloading the project'
info '-----------------------'

if [ -x "/usr/bin/git" ] ; then
  git clone --quiet --recursive 'https://github.com/HoplaGeiss/WebSocket' experiment || fail 'Impossible to clone the repository'
else
  fail 'Please install git'
fi
echo 'github project imported'


echo ''
info 'Updating node'
info '-------------'

if [ -x "/usr/bin/nodejs" ]
then
  cd experiment
  sudo npm cache clean -f
  sudo npm install -g n
  sudo n stable
else 
  fail 'Please install npm'
fi
echo 'Node has been updated'

echo ''
info 'Installing dependencies'
info '-----------------------'

npm install || fail 'Impossible to install dependencies'
echo 'Dependencies installed'

echo ''
success 'Setup complete. Enjoy!!'
