// based on: k8spatterns.io
http = require('http');
fs = require('fs');

server = http.createServer( function(req, res) {
    if (req.method == 'POST') {
        var body = '';

        req.on('data', function (data) {
          body += data;
        });
        
        req.on('end', function () {
          var resp = JSON.parse(body);
          console.log('Message received:')
          console.log(
            '>>> ID: ' + resp.id +
            ' -- Duration: ' + resp.duration +
            ' -- Random: ' + resp.random);
        });
    }
    else {
        console.warn('Method ' + req.method + ' not supported');
      }
    res.writeHead(200);
    res.end();
  });

var port = 9898;
var host = 'localhost';

server.listen(port, host);
console.log('=========================')
console.log('Starting up Ambassador')
console.log('host: ' + host);
console.log('port: ' + port);
console.log('=========================')