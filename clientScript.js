var args = process.argv.slice(2);
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


function spawnClientsEachSecond(numberClientsEachSecond) {
  for (var i = 0; i < numberClientsEachSecond; i++) {

    // Adds the new websocket client to an array.
    clients.push(socketCluster.connect(options));
    

    // Optionnal, just prints a message when a new websocket client is created.
    /*
     * clients[clients.length -1].on("connect", function () {
     *   console.log("\nCONNECTED #" + this.id);
     * });

     * clients[clients.length -1].on("pong", function(message){
     *   console.log("CLIENT: message from server " + message);
     * });
     */

  }
}

// During "timeExperiment", "numberClientsEachSecond" are created each seconds.
var timer = setInterval(function(){
  spawnClientsEachSecond(numberClientsEachSecond);
  console.log(clients.length);
},1000);
setTimeout(function(){clearInterval(timer)},timeExperiment*1000);

// Each seconds, every clients sends a ping to the servers.
setInterval(function () {
  clients.map(function(client){
    client.emit("ping", "ping" + Math.floor(Math.random() * 100));
  });
}, 1000);

