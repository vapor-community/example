import Vapor

let app = Application()

app.get("/") { request in
	do {
		return try app.view("welcome.html")
	} catch _ {
		return "Something went wrong."
	}
}

app.get("json") { request in
	return Json([
		"number": 123,
		"string": "test",
		"array": [
			0, 1, 2, 3
		],
		"dict": [
			"name": "Vapor",
			"lang": "Swift"
		]
	])
}

app.any("data/:id") { request in
	return Json([
		"request.path": request.path,
		"request.data": "\(request.data)",
		"request.parameters": "\(request.parameters)",
	])
}

app.get("session") { request in
	let response: Response
	let json = Json([
		"session.data": "\(request.session)",
		"request.cookies": "\(request.cookies)",
		"instructions": "Refresh to see cookie and session get set."
	]);
	response = Response(status: .OK, json: json)

	request.session?["name"] = "Vapor"
	response.cookies["test"] = "123"

	return response
}

app.get("heartbeat", handler: HeartbeatController().index)

app.get("stencil") { request in
	return try app.view("template.stencil", context: [
		"greeting": "Hello, world!"
	])
}

// Print what link to visit for default port
print("Visit http://localhost:8080")

app.middleware.append(SampleMiddleware)
app.start(port: 8080)
