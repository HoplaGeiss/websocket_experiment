var fs = require("fs");

module.exports.run = function (worker) {
    // Get a reference to our raw Node HTTP server
    var httpServer = worker.getHTTPServer();
    // Get a reference to our WebSocket server
    var wsServer = worker.getSCServer();

    /*
        We"re going to read our main HTML file and the socketcluster-client
        script from disk and serve it to clients using the Node HTTP server.
    */

    var htmlPath = __dirname + "/index.html";
    var clientPath = __dirname + "/node_modules/socketcluster-client/socketcluster.js"; 

    var html = fs.readFileSync(htmlPath, {
        encoding: "utf8"
    });

    var clientCode = fs.readFileSync(clientPath, {
        encoding: "utf8"
    });

    /*
        Very basic code to serve our main HTML file to clients and
        our socketcluster-client script when requested.
        It may be better to use a framework like express here.
        Note that the "req" event used here is different from the standard Node.js HTTP server "request" event 
        - The "request" event also captures SocketCluster-related requests; the "req"
        event only captures the ones you actually need. As a rule of thumb, you should not listen to the "request" event.
    */
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
      // socket.on("ping", function (num) {
      //   // console.log("Socket " + this.session.id + " reveived a ping: " + num);
      //   socket.session.emit("pong","pong" + num);        
      // });

      socket.on("ping", function () {
        socket.session.emit("pong","pong");        
      });



    });

    wsServer.on("disconnection", function (socket) {
        //console.log("Socket " + socket.id + " was disconnected");
    });

    wsServer.on("sessiondestroy", function (ssid) {
        delete activeSessions[ssid];
    });
    
};
