import Foundation

struct RecipeVersion: Codable, Hashable, Identifiable {
    var id: String
    var orderNumber: Int
    var instructions: String
    var notes: String
    var ingredients: [Ingredient]
    
    init(id: String, orderNumber: Int, instructions: String, notes: String, ingredients: [Ingredient]) {
        self.id = id
        self.orderNumber = orderNumber
        self.instructions = instructions
        self.notes = notes
        self.ingredients = ingredients
    }
    
    func string() -> String {
        return "v" + String(orderNumber)
    }

}
