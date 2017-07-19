import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {

        builder.get { req in
            
            // Get all stations
            let stations = try Station.makeQuery().all()
            
            
            return try self.view.make("index", [
                "stations": stations
            ])
        }
    
        builder.get("station", ":id") { req in
            
            // Make sure the request contains an id
            guard let stationId = req.parameters["id"]?.int else {
                throw Abort.badRequest
            }

            let station = try Station.makeQuery().find(stationId)
            
            return try self.view.make("edit", [
                "station": station
            ])
        }
        
        builder.get("add") { req in
            return try self.view.make("edit")
        }
        
        builder.post("station") { req in
            guard let form = req.formURLEncoded else {
                throw Abort.badRequest
            }
            
            let station = try Station(node: form)
            try station.save()
            
            return Response(redirect: "/")
        }
        
        builder.post("station", ":id") { req in
            
            // Make sure it's a form posted
            guard let form = req.formURLEncoded else {
                throw Abort.badRequest
            }
            
            // Make sure the request contains an id
            guard let stationId = req.parameters["id"]?.int else {
                throw Abort.badRequest
            }
            
            guard let station = try Station.makeQuery().find(stationId) else {
                throw Abort.notFound
            }
            
            // Use Vapor's node functions to create a new entity
            let newStation = try Station(node: form)
            
            // Assign the new values back to the old
            station.country = newStation.country
            station.name = newStation.name
            station.description = newStation.description
            
            // ...and save
            try station.save()
            
            return Response(redirect: "/")
        }
        
        builder.get("stations.json") { req in
            return try Station.makeQuery().all().makeJSON()
        }
    }
}
