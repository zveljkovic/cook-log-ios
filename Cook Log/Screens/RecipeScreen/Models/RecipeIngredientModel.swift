import Foundation

class RecipeIngredientModel : ObservableObject, Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: RecipeIngredientModel, rhs: RecipeIngredientModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    @Published var id: String = UUID().uuidString
    @Published var name: String = ""
    @Published var amount: String = ""
    @Published var unit: String = ""
    @Published var checked: Bool = false
    @Published var new: Bool = true
    
    init () {
        
    }
    
    init(_ ingredient: Ingredient) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.amount = ingredient.amount
        self.unit = ingredient.unit
    }
    
    func toIngredient() -> Ingredient {
        return Ingredient(id: self.id, name: self.name, amount: self.amount, unit: self.unit)
    }
}

