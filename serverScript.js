var SocketCluster = require('socketcluster').SocketCluster;

var socketCluster = new SocketCluster({
    workers: [9100, 9200, 9300, 9400],
    stores: [9001],
    balancerCount: 3,
    port: 8080,
    appName: 'myapp',
    workerController: 'worker.js',
    useSmartBalancing: true,
    addressSocketLimit: 100000 
});
