import Foundation

struct Ingredient: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var amount: String
    var unit: String
    
    init(id: String, name: String, amount: String, unit: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

