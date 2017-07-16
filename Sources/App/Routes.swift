import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {

        builder.get { req in
            let stations = try Station.makeQuery().all()
            return try self.view.make("index", [
                "stations": stations
            ])
        }
        
        builder.get("station", ":id") { req in
            guard let stationId = req.parameters["id"]?.int else {
                throw Abort.badRequest
            }

            let station = try Station.makeQuery().find(stationId)
            
            return try self.view.make("edit", [
                "station": station
            ])
        }
        
        builder.get("station", "create") { req in
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
            
            guard let form = req.formURLEncoded else {
                throw Abort.badRequest
            }
            
            guard let stationId = req.parameters["id"]?.int else {
                throw Abort.badRequest
            }
            
            guard let station = try Station.makeQuery().find(stationId) else {
                throw Abort.notFound
            }
            
            let newStation = try Station(node: form)
            
            station.country = newStation.country
            station.name = newStation.name
            station.description = newStation.description
            try station.save()
            
            return Response(redirect: "/")
        }
        // @todo lägg till en station
        
        // @todo lista en station...
        
        /// GET /hello/...
        //builder.resource("hello", HelloController(view))
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        
        builder.get("station") { req in
            let station = Station(name: "Min station", description: "En beskrivning", country: "se", stream: "stream.url")
            try station.save()
            
            return "saved"
        }
        
    }
}
