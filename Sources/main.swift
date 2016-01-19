import Vapor

Route.get("heartbeat") { request in
	return ["lub": "dub"]
}

Route.resource("heartbeat2", controller: HeartbeatController())

Route.get("heartbeat3", closure: HeartbeatController().index)

Route.get("/test") { request in 
	return View(path: "index.html")
}

Route.get("/") { request in 
	return "<h1>Welcome.</h1> Server powered by Swift. <pre>\(request.method) \(request.parameters)</pre>"
}

Route.get("param/:thing") { request in 
	return "<h1>param test</h1> <pre>Method: \(request.method)\nParams: \(request.parameters)\nQuery: \(request.query)</pre>"	
}

let server = HttpServer()
server.run(port: 8080)