import Vapor

Route.get("/") { request in 
	return View(path: "welcome.html")
}

Route.get("json") { request in 
	return [
		"number": 123,
		"string": "test",
		"array": [
			0, 1, 2, 3
		],
		"dict": [
			"name": "Vapor",
			"lang": "Swift"
		]
	]
}

Route.any("data/:id") { request in
	let response = [
		"request": [
			"path": request.path,
			"data": request.data,
			"parameters": request.parameters,
		]
	]

	return response
}

Route.get("session") { request in
	let response: Response
	do {
		response = try Response(status: .OK, json: [
			"session.data": request.session.data,
			"request.cookies": request.cookies,
			"instructions": "Refresh to see cookie and session get set."
		])
	} catch {
		response = Response(error: "Invalid JSON")
	}

	request.session.data["name"] = "Vapor"
	response.cookies["test"] = "123"

	return response
}

Route.get("heartbeat", closure: HeartbeatController().index)

print("Visit http://localhost:8080")

let server = Server()
server.run(port: 8080)

