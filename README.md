# WebSocket experiments

As part of my master thesis at Cranfield university I have been brought to make concurrent WebSocket connections tests. These tests have been carried out on the highly scalable WebSocket library [socketcluster](https://github.com/TopCloud/socketcluster).

## Installation

There is two kind of installation. One on a bar metal server or typically a virtual machine and one on the users's local machine.

#### User local machine installation
`wget 'https://raw.githubusercontent.com/HoplaGeiss/websocket_experiment/master/install.sh' -O - | sh`

#### Virtual machine installation
`wget 'https://raw.githubusercontent.com/HoplaGeiss/websocket_experiment/master/bare_server_install.sh' -O - | sh`

## Experiment

### Concurrency experiment

Concurrency experiments evalutate the amount of concurrent connections a WebSocket server can handle.
To simulate this, the client script spawns new clients every seconds, each clients are sending every second a ping message to the server and the server answers by a pong message.

### Run the experiment

To run the the experiment

```
cd experiment
./run_experiment.sh <nb_client_sec> <time_experiment>
```

The experiment can be run on a remote server without graphical output.
In this case, the user needs to have gnuplot installed on his local machine. 
He also will be prompted for the remote IP and login for ssh purposes.

WARNING: the git project must absolutly be named experiment and placed in the root folder of the remote server

`nb_client_sec` Number of clients beeing spawnd every seconds

`time_experiment` Time of the experiment





