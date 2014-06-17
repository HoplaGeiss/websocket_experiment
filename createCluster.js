var SocketCluster = require('socketcluster').SocketCluster;

var socketCluster = new SocketCluster({
    workers: [9100, 9200],
    stores: [9001],
    port: 8080,
    appName: 'myapp',
    workerController: 'worker.js',
    addressSocketLimit: 2000 
});
