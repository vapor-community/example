import Vapor

class HeartbeatController: Controller {

	override func index(request: Request) {
		return ["lub": "dub"]
	}

}