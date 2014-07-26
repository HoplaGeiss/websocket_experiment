var app = require('http').createServer(handler)
var io = require('socket.io')(app);
var fs = require('fs');

app.listen(8080);

function handler (req, res) {
  fs.readFile(__dirname + '/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }

    res.writeHead(200);
    res.end(data);
  });
}
var count =0;
io.on('connection', function (socket) {
  socket.on('ping', function(N){
    // console.log("Incoming : " + N );
    socket.emit('pong', ++count);
  })
 
});


setTimeout(function(){
  process.stdout.write("Experiment in progress: ");
},1000);

setInterval(function(){
  process.stdout.write(".");
},2000);

