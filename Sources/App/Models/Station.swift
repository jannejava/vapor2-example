import Vapor

final class Station: NodeRepresentable, JSONRepresentable {
    
    var name: String
    var description: String
    var country: String
    var stream: String
    
    init(name: String, description: String, country: String, stream: String) {
        self.name = name
        self.description = description
        self.country = country
        self.stream = stream
    }
}

extension Station: NodeRepresentable {
    
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        
        try node.set("name", name)
        try node.set("description", description)
        try node.set("country", country)
        try node.set("stream", stream)
        
        return node
    }
}

extension Station: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("headline", headline)
        try json.set("excerpt", excerpt)
        return json
    }
}
