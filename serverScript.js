var SocketCluster = require('socketcluster').SocketCluster;
var args = process.argv.slice(2);
var numWorker = args[0];
var numBalancer = args[1];
var workerList = [];
var portInitial = 8000;

for( var i = 0; i < numWorker; i++){
  workerList.push(portInitial);
  portInitial += 100;
}

var socketCluster = new SocketCluster({
    workers: workerList,
    stores: [9001],
    balancerCount: numBalancer,
    logLevel: 2,
    port: 8080,
    appName: 'myapp',
    workerController: 'worker.js',
    balancerController: 'loadbalancer.js',
    storeController: 'store.js',
    workerStatusInterval: 1,
    useSmartBalancing: true,
    addressSocketLimit: 0 
});

setTimeout(function(){
  process.stdout.write("Experiment in progress: ");
},1000);

setInterval(function(){
  process.stdout.write(".");
},2000);


