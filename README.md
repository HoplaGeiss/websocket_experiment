# WebSocket experiments

As part of my master thesis at Cranfield university I have made concurrent
WebSocket connections tests. These tests have been carried out on the highly
scalable real-time engine
[socketcluster](https://github.com/TopCloud/socketcluster).

## Installation


There is two kind of installation:
* Local installation
* Remote installation

The Local installation doesn't install all dependencies so as not to mess
around with the user software version.  He has to check this manually.

The remote installation installs both the client and the server code on the
remote server.

#### Local machine installation
`wget 'https://raw.githubusercontent.com/HoplaGeiss/websocket_experiment/master/install.sh' -O - | sh`

#### Virtual machine installation
`wget 'https://raw.githubusercontent.com/HoplaGeiss/websocket_experiment/master/bare_server_install.sh' -O - | sh`

## Experiment

#### Concurrency experiment

Concurrency experiments evalutate the amount of concurrent connections a
WebSocket server can handle.  To simulate this, the client script spawns new
clients every seconds, every second each clients send a ping message to
the server and the server answers by a pong message.

#### Run the experiment

To run the the experiment:

```
cd experiment
./run_experiment.sh <nb_client_sec> <time_experiment> <number_of_clients> <run_on_SocketCluster>
```

`nb_client_sec` Number of clients beeing spawned every seconds

`time_experiment` Time of the experiment

`number_of_clients` Number of clients threads used

`run_on_SocketCluster` 

* 0 => The application will run with pure engine.io 
* 1 => The application will be run with SocketCluster 

Also make sure gnuplot is installed on your local machine.

###### Local experiment
The application will store the data in /results/local_machine.

###### Remote servers

To run the applcation on remote servers. The application needs to know the
login and IP adress of the server.  The user can either provide this
information in the `confFile.txt` or simply input it when the application asks
for it. 

WARNING: the git project must absolutly be named experiment and placed in the
root folder of the remote server

