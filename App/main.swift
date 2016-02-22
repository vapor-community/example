import Vapor
import VaporStencil

let app = Application()

app.get("/") { request in
	do {
		return try View(path: "welcome.html")
	} catch _ {
		return "Something went wrong."
	}
}

app.get("json") { request in
	let response: [String: Any] = [
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

	return response
}

app.any("data/:id") { request in
	let response: [String: Any] = [
		"request.path": request.path,
		"request.data": request.data,
		"request.parameters": request.parameters,
	]

	return response
}

app.get("session") { request in
	let response: Response
	do {
		let json: [String: Any] = [
			"session.data": request.session.data,
			"request.cookies": request.cookies,
			"instructions": "Refresh to see cookie and session get set."
		];
		response = try Response(status: .OK, json: json)
	} catch {
		response = Response(error: "Invalid JSON")
	}

	request.session.data["name"] = "Vapor"
	response.cookies["test"] = "123"

	return response
}

app.get("heartbeat", closure: HeartbeatController().index)

app.get("stencil") { request in
	return try View(path: "template.stencil", context: [
		"greeting": "Hello, world!"
	])
}

// Print what link to visit for default port
print("Visit http://localhost:8080")

app.providers.append(VaporStencil.Provider) // Adds support for stencil rendering for all .stencil views)
app.middleware.append(SampleMiddleware)
app.start(port: 8080)
