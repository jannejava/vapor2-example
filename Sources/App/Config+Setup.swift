import LeafProvider
import MySQLProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [JSON.self, Node.self]

        try setupProviders()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(LeafProvider.Provider.self)
        try addProvider(MySQLProvider.Provider.self)
        
        // Run migrations/preparations
        preparations.append(Station.self)
    }
}
