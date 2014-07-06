var fs = require("fs");
console.log("WORKER:", process.pid);

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

    // Handles incoming WebSocket connections and listens for events
    wsServer.on("connection", function (socket) {
        
      // console.log("Socket " + socket.session.id + " is connected.");  // Prints the id of the newly connected clients.  

     activeSessions[socket.session.id] = socket.session; // Stores the id of the sockets

      // The server listens to the ping event from the clients
      socket.on("ping", function (data) {
        // console.log("Socket " + this.session.id + " reveived a ping: " + data);
        socket.session.emit("pong","pong" + data);        
      });


    });

    wsServer.on("disconnection", function (socket) {
        //console.log("Socket " + socket.id + " was disconnected");
    });

    wsServer.on("sessiondestroy", function (ssid) {
        delete activeSessions[ssid];
    });
    
};
