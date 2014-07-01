var SocketCluster = require('socketcluster').SocketCluster;

var socketCluster = new SocketCluster({
    workers: [9100, 9200, 9300],
    stores: [9001, 9002, 9003],
    balancerCount: 1,
    port: 8080,
    appName: 'myapp',
    workerController: 'worker.js',
    addressSocketLimit: 100000 
});
