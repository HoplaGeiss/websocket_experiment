var args = process.argv.slice(2);
var cluster = require('cluster');
var socketCluster = require("socketcluster-client");
var options = { 
    protocol: "http", 
    hostname: "localhost", 
    port: "8080", 
    autoReconnect: true 
}; 
var clients = [];
var numberClientsEachSecond = args[0];
var timeExperiment = args[1];
var numProcs = args[2];
// var numberClientsEachSecond = 1;
// var timeExperiment = 100;
// var numProcs = 4;



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
    if(clients.length < 2000){
      spawnClientsEachSecond(numberClientsEachSecond);
    }
    // console.log(clients.length);
  },1000);
  setTimeout(function(){clearInterval(timer)},timeExperiment*1000);

  setInterval(function () {
    clients.map(function(client){
      client.emit("ping", "ping");
      console.log( "OUTGOING message: ping");
    });
  }, 1000);
}
