var args = process.argv.slice(2);
var cluster = require('cluster');
var clientSC = require("socketcluster-client");
var dl  = require('delivery');
var numberClientsEachSecond = args[0];
var timeExperiment = args[1];
var numProcs = args[2];
var hostname = args[3];
var clients = [];
var fs = require("fs");

if(args.length != 4){
  console.log("clientScript <num_client_each_seconds> <time_experiment> <num_client_processor> <server_ip>");
  process.exit(1);
}

if (cluster.isMaster) {
	for (var i = 0; i < numProcs; i++) {
		var worker = cluster.fork();
	}
} else {
	var count = 0;
  var domain = require('domain');
  var errorDomain = domain.createDomain();
	var connectSC = function () {
		var options = {
			protocol: 'http',
			hostname: hostname,
			port: "8080",
      autoReconnect: true 
		};
		var socket = clientSC.connect(options);
    clients.push(socket);
		errorDomain.add(socket);



		// SENDS PINGS
		var intv = Math.round(Math.random() * 12000);
		setInterval(function () {
			// socket.emit('ping', {param: 'pong'});
			socket.emit('ping', Math.floor(Math.random() * 50));
			// console.log('CLIENT: ping sent')
		}, intv);

    // RECEPTION OF CLIENTS' ANSWERS

    // clients.map(function(client){
    //   // RECEPTION OF FILES
    //   var delivery = dl.listen(socket);
    //   delivery.on('receive.success',function(file){
    //
    //     fs.writeFile(file.name, file.buffer, function(err){
    //       if(err){
    //         // console.log('File could not be saved: ' + err);
    //       }else{
    //         // console.log('File ' + file.name + " saved");
    //       };
    //     });
    //   });
    //
    //   // console.log('Incoming: ' + N);
    // });
    
    // CREATION OF NEW CLIENTS
    setTimeout(connectSC, 1000/numberClientsEachSecond);
		// if (count < 1314*numProcs) {
		// 	setTimeout(connectSC, 1000/numberClientsEachSecond);
		// }
	};


	connectSC();

}

