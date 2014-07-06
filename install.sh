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
# sudo -v

echo ''
info 'Setting up the websocket experiment configuration'
info '================================================='
echo ''

echo ''
info 'Downloading the project'
info '-----------------------'
if [ -x "/usr/bin/git" ] ; then
  git clone --quiet 'https://github.com/HoplaGeiss/WebSocket' experiment || fail 'Impossible to clone the repository'
  cd experiment
else
  fail 'Please install git'
fi
echo ''
echo 'github project imported'

echo ''
info 'Installing dependencies'
info '-----------------------'
if [ -x /usr/bin/nodejs ] ; then
  npm install || fail 'Impossible to install dependencies, check your version of node.js'
  echo 'Dependencies installed'
else
  fail 'Please install nodejs'
fi
echo ''
success 'Setup complete. Enjoy!!'
