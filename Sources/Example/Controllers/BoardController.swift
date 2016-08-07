import Vapor
import HTTP

/**
    Here, we create a group to manage the board, a 
    very basic forum-style site where anyone can post
    anything.
*/
public final class BoardController {
    let drop: Droplet

    public init(droplet: Droplet) {
        drop = droplet
    }

    /**
        At the root, the board view is rendered with the items
        on the board and a form to post new items.
    */
    public func index(_ request: Request) throws -> ResponseRepresentable {
        // Get all the posts
        let posts = try Post.query().all()
        
        // Render the board with all the posts
        return try drop.view("board.mustache", context: ["posts": posts])
    }
            
    /**
        This endpoint is hit by the client using the form at
        /boards. When the request is complete, it redirects
        to /boards.
    */
    public func store(_ request: Request) throws -> ResponseRepresentable {
        // Get the reqeuest data
        guard let username = request.data["username"].string, let text = request.data["text"].string else {
            return "Could not get username and text." // TODO: Error page? Mabye too complex?
        }
        
        // Fetch any user with the username
        var user = try User.query().filter("name", .equals, username).first()
        
        // If none exists, create the user
        if user == nil {
            user = User(name: username)
            try user?.save()
        }
        
        // Create and save the post
        var post = Post(text: text, user: user)
        try post.save()
        
        // Reidrect to /board
        return Response(redirect: "/board")
    }
}

extension BoardController: ResourceRepresentable {
    public func makeResource() -> Resource<String> {
        return Resource(index: index, store: store)
    }
}
