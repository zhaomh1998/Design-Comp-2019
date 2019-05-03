//create a HTTP module
const http = require('http');
//import the file system core module
const fs = require('fs');
//import the path to the files
const path = require('path');
//create a hostname and a port number
const hostname = 'localhost';
const port = 3000;

//create the server - takes in a function with 2 values - request and response
const server = http.createServer((req,res) => {
	
	//display the incoming requests header
	console.log('Request for: ' + req.url + ' by method ' + req.method);

	//only have the server serve GET requests
	if(req.method='GET'){
		
		//specify which file to serve up
		var fileURL;

		if(req.url == '/') fileURL= '/index.html';
		else fileURL = req.url;


		//translate to the fill fetched file path for the file specified above
		var filePath = path.resolve('./public'+fileURL);
		const fileExt = path.extname(filePath);
		//check to make sure file is .html
		if(fileExt == '.html'){
			//if file exists
			fs.exists(filePath, (exists) => {
				if(!exists){
					//send appropriate response and display the error type
					res.statusCode = 404;
					res.setHeader('Content-Type', 'text/html');
					res.end('<html><body><h1> Error 404: ' + fileURL +
					'not found </h1></body></html>');

					return;
				}
				res.statusCode = 200;
				res.setHeader('Content-Type', 'text/html');
				fs.createReadStream(filePath).pipe(res);

			});
		}
		else{
			//send appropriate response and display the error type
      		res.statusCode = 404;
			res.setHeader('Content-Type', 'text/html');
			res.end('<html><body><h1> Error 404: ' + fileURL +
			'not and HTML file </h1></body></html>');
		}

	}	
	else{
		//send appropriate response and display the error type
		res.statusCode = 404;
		res.setHeader('Content-Type', 'text/html');
		res.end('<html><body><h1> Error 404: ' + req.method +
		'not supported by this node-html server </h1></body></html>');
	}

	//set up the status code for response message
//	res.statusCode = 200; //200 means everythong is ok
	//set up the header for the response message
//	res.setHeader('Content-Type', 'text/html');
	//end the response
//	res.end('<html><body><h1>Hello, World!</h1></body></html>');
})

//start the server in node
server.listen(port,hostname,() => {
	console.log(`Server running at http://${hostname}:${port}/`)
});