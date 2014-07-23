var args = process.argv.slice(2);
var cluster = require('cluster');
var socketCluster = require("socketcluster-client");
var clients = [];
var numberClientsEachSecond = args[0];
var timeExperiment = args[1];
var numProcs = args[2];
var hostname = args[3];
// var numberClientsEachSecond = 1;
// var timeExperiment = 100;
// var numProcs = 4;

if(args.length != 4){
  console.log("clientScript <num_client_each_seconds> <time_experiment> <num_client_processor> <server_ip>");
  process.exit(1);
}

var options = { 
    protocol: "http", 
    hostname: hostname, 
    port: "8080", 
    autoReconnect: true 
}; 


function spawnClientsEachSecond(numberClientsEachSecond) {
  for (var i = 0; i < numberClientsEachSecond; i++) {

    // Adds the new websocket client to an array.
    clients.push(socketCluster.connect(options));
    
    // Optionnal, just prints a message when a new websocket client is created.
    // clients[clients.length -1].on("connect", function () {
    // console.log("\nCONNECTED #" + this.id);
    // });

  }
}

if (cluster.isMaster) {
	for (var i = 0; i < numProcs; i++) {
		var worker = cluster.fork();
	}
} else {
  // During "timeExperiment", "numberClientsEachSecond" are created each seconds.
  var timer = setInterval(function(){
    if(clients.length < 1000){
      spawnClientsEachSecond(numberClientsEachSecond);
    }
  },1000);
  setTimeout(function(){clearInterval(timer)},timeExperiment*1000);

  setInterval(function () {
    clients.map(function(client){
      client.emit("ping", "ping");
      // console.log( "OUTGOING message: ping");
    });
  }, 1000);
}
