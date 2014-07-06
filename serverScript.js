var SocketCluster = require('socketcluster').SocketCluster;

var socketCluster = new SocketCluster({
    workers: [9100],
    stores: [9001],
    balancerCount: 2,
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


