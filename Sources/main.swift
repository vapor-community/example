import Vapor

Route.get("/") { request in 
	return "<h1>Welcome.</h1> Server powered by Swift."
}

Route.get("heartbeat") { request in
	return ["lub": "dub"]
}

Route.get("/heartbeat/alternate", closure: HeartbeatController().index)

Route.get("/test") { request in 
	return View(path: "index.html")
}

Route.get("param/:thing") { request in 
	return "<h1>param test</h1> <pre>Method: \(request.method)\nParams: \(request.parameters)\nQuery: \(request.query)</pre>"	
}

//start the server up
let server = Server()
server.run(port: 8080)