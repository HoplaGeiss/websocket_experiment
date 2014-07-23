var args = process.argv.slice(2);
var cluster = require('cluster');
var clientSC = require("socketcluster-client");
var numberClientsEachSecond = args[0];
var timeExperiment = args[1];
var numProcs = args[2];
var hostname = args[3];


if (cluster.isMaster) {
	for (var i = 0; i < numProcs; i++) {
		var worker = cluster.fork();
	}
} else {
  var domain = require('domain');
  var errorDomain = domain.createDomain();
	var count = 0;
	var connectSC = function () {
		var options = {
			protocol: 'http',
			hostname: hostname,
			port: "8080"
		};
		
		var socket = clientSC.connect(options);
		errorDomain.add(socket);
		var intv = Math.round(Math.random() * 5000 + 5000);
		setInterval(function () {
			socket.emit('ping', {param: 'pong'});
		}, intv);
		if (count < 1314*numProcs) {
			setTimeout(connectSC, 1000/numberClientsEachSecond);
		}
	};

	// console.log('Using SocketCluster');
	connectSC();

}
/*
socket.on('rand', function (num) {
    console.log('RANDOM: ' + num);
});
*/

