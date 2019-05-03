//request third party node module
const express = require('express');
//request core module http
const http = require('http');

//declare the hostname and the port
const hostname = 'localhost';
const port = 3000;

//create the express app to set up express server
const app = express();

//.use has 3 parameters - next is not required, but optional
app.use((req, res, next) => {
	console.log(req.headers);
	res.statusCode = 200;
	res.setHeader('Content-Type', 'text/html');
	res.end('<html><body><h1> This is an Express server </h1></body></html>');
});

//add the functionality to the server
const server = http.createServer(app);

server.listen(port, hostname,() => {
	console.log(`Server runing at http://${hostname}:${port}`)
});