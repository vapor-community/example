import Vapor

class UserController: Controller {
    typealias Item = User

    required init(application: Application) {
        Log.info("User controller created")
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return Json([
            "controller": "UserController.index"
        ])
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        return Json([
            "controller": "UserController.store"
        ])
    }
    
    /**
    	Since item is of type User, 
    	only instances of user will be received
    */
    func show(request: Request, item user: User) throws -> ResponseRepresentable {
        //User can be used like JSON with JsonRepresentable
        return Json([
            "controller": "UserController.show",
            "user": user
        ])
    }
    
    func update(request: Request, item user: User) throws -> ResponseRepresentable {
        //User is JsonRepresentable
        return user.makeJson()
    }
    
    func destroy(request: Request, item user: User) throws -> ResponseRepresentable {
        //User is ResponseRepresentable by proxy of JsonRepresentable
        return user
    }
    
}