
@_exported import Vapor
import MySQLProvider

extension Droplet {
    public func setup() throws {
        let routes = Routes(view)
        try collection(routes)
        config.preparations.append(Station.self)

        try config.addProvider(MySQLProvider.Provider.self)
        
        
    }
}
