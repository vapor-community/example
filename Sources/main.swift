import Vapor
import Foundation

Route.get("/") { request in 
	return View(path: "welcome.html")
}

Route.get("json") { request in 
	let response: NSDictionary = [
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

Route.any("data/:id") { request in
	let response: NSDictionary = [
		"request.path": request.path,
		"request.data": request.data,
		"request.parameters": request.parameters,
	]

	return response
}

Route.get("session") { request in
	let response: Response
	do {
		let json: NSDictionary = [
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

Route.get("heartbeat", closure: HeartbeatController().index)

print("Visit http://localhost:8000")

let server = Server()
server.run(port: 8000)

