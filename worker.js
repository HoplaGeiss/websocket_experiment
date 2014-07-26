var fs = require("fs");
var dl  = require('delivery');

console.log("WORKER:", process.pid);

function isPrime(i) {
  for (var c = 2; c <= Math.sqrt(i); ++c)
    if (i % c === 0) return false;
  return true;
}
function fibonacciList(N) {
  var list = [];
   for (var i = 2; i != N; ++i)
     if (isPrime(i)) list.push(i);
   return list;
}

function fibonacci(n){
    if (n <= 1){
      return n;
    }
    else{
      return fib(n-1) + fib(n-2);
    }
}


module.exports.run = function (worker) {
    // Get a reference to our raw Node HTTP server
    var httpServer = worker.getHTTPServer();
    // Get a reference to our WebSocket server
    var wsServer = worker.getSCServer();

    var htmlPath = __dirname + "/index.html";
    var clientPath = __dirname + "/node_modules/socketcluster-client/socketcluster.js"; 

    var html = fs.readFileSync(htmlPath, {
        encoding: "utf8"
    });

    var clientCode = fs.readFileSync(clientPath, {
        encoding: "utf8"
    });

    httpServer.on("req", function (req, res) {
        if (req.url == "/socketcluster.js") {
            res.setMaxListeners(0);
            res.writeHead(200, {
                "Content-Type": "text/javascript"
            });
            res.end(clientCode);
        } else if (req.url == "/") {
            res.writeHead(200, {
                "Content-Type": "text/html"
            });
            res.end(html);
        }
    });

    var activeSessions = {};
    var count = 0;

    // Handles incoming WebSocket connections and listens for events
    wsServer.on("connection", function (socket) {
        
     // console.log("Socket " + socket.session.id + " is connected.");  // Prints the id of the newly connected clients.  

     activeSessions[socket.session.id] = socket.session; // Stores the id of the sockets
      
      // The server listens to the ping event from the clients
      socket.on("ping", function (N) {
        
        // SENDS SIMPLE PONG EVENT
        // socket.emit('pong', ++count);
        // console.log("Incoming : " + N );
        // console.log("Socket " + this.session.id + " reveived a ping: " + data);

        // SENDS FILE

        var delivery = dl.listen(socket);
        delivery.connect();
        delivery.on('delivery.connect',function(delivery){

          delivery.send({
            name: 'small_file',
            path : './small_file'
          });

          delivery.on('send.success',function(file){
            // console.log('File successfully sent to client!');
          });
        });

      });
    });

    wsServer.on("disconnection", function (socket) {
        //console.log("Socket " + socket.id + " was disconnected");
    });

    wsServer.on("sessiondestroy", function (ssid) {
        delete activeSessions[ssid];
    });
    
};
