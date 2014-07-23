var numWorker = 4;
var worker = [];
var port = 8000;

for( var i = 0; i < numWorker; i++){
  worker.push(port);
  port += 100;
}

console.log(worker);
