# WebSocket experiments

As part of my master thesis at Cranfield university I have been brought to make concurrent WebSocket connections tests. These tests have been carried out on the highly scalable WebSocket library [socketcluster](https://github.com/TopCloud/socketcluster).

## Installation

`wget 'https://raw.githubusercontent.com/HoplaGeiss/websocket_experiment/master/install.sh' -O - | sh`

## Run experiment

`./plot.sh <nb_client_sec> <time_experiment>`

Running `plot.sh` runs a concurrent WebSocket connections experiment during `<time_experiment>`. Each seconds `<nb_client_sec>` WebSocket clients are created. Every second, each clients sends a random number to the server and the server answers back the same number. 

The scripts also plots the node processus processor usage in function of the time.





