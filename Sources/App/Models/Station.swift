import Vapor
import MySQLProvider

final class Station: Model {
    
    // The storage property is there to allow Fluent to store extra information on your model like the model's database id or if it's a existing or new entity.
    let storage = Storage()
    
    var id: Node?
    var name: String
    var description: String
    var country: String
    var stream: String
    
    // Just static variables holding the names to prevent typos
    static let nameKey = "name"
    static let descriptionKey = "description"
    static let countryKey = "country"
    static let streamKey = "stream"
    
    init(name: String, description: String, country: String, stream: String) {
        self.id = nil
        self.name = name
        self.description = description
        self.country = country
        self.stream = stream
    }
    
    // The Row struct represents a database row. Your models should be able to parse from and serialize to database rows. Here's the code for parsing the Stations from the database.
    init(row: Row) throws {
        id = try row.get(Station.idKey)
        name = try row.get(Station.nameKey)
        description = try row.get(Station.descriptionKey)
        country = try row.get(Station.countryKey)
        stream = try row.get(Station.streamKey)
    }
    
    // Init model from a Node-structure
    init(node: Node) throws {
        name = try node.get(Station.nameKey)
        description = try node.get(Station.descriptionKey)
        country = try node.get(Station.countryKey)
        stream = try node.get(Station.streamKey)

    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Station.nameKey, name)
        try row.set(Station.descriptionKey, description)
        try row.set(Station.countryKey, country)
        try row.set(Station.streamKey, stream)
        
        return row
    }
}

extension Station: NodeRepresentable {
    
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        
        try node.set(Station.idKey, id?.int)
        try node.set(Station.nameKey, name)
        try node.set(Station.descriptionKey, description)
        try node.set(Station.countryKey, country)
        try node.set(Station.streamKey, stream)
        
        return node
    }
}

extension Station: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Station.nameKey, name)
        try json.set(Station.descriptionKey, description)
        try json.set(Station.countryKey, country)
        try json.set(Station.streamKey, stream)
        return json
    }
}

extension Station: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Station.nameKey)
            builder.string(Station.descriptionKey)
            builder.string(Station.countryKey)
            builder.string(Station.streamKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Station: Timestampable { }
