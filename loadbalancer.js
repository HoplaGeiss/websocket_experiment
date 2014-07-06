var fs = require('fs');
console.log('BALANCER:', process.pid);

module.exports.run = function (loadBalancer) {
/*
	loadBalancer.addMiddleware(loadBalancer.MIDDLEWARE_REQUEST, function (req, res, next) {
		//console.log('INTCP', req.url);
		if (req.url == '/favicon.ico' && false) {
			res.writeHead(404);
			res.end();
		} else {
			next();
		}
	});
	
	loadBalancer.addMiddleware(loadBalancer.MIDDLEWARE_UPGRADE, function (req, socket, head, next) {
		//console.log('INWS', req.url);
		next();
	});
*/
};
