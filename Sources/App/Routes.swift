import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        /// GET /
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
