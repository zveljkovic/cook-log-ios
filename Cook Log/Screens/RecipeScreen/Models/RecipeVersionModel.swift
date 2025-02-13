import Foundation
import Factory

class RecipeVersionModel : ObservableObject, Hashable  {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: RecipeVersionModel, rhs: RecipeVersionModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    
    @Published var id: String = UUID().uuidString
    @Published var orderNumber: Int = 1
    @Published var instructions: String = ""
    @Published var notes: String = ""
    @Published var ingredients: [RecipeIngredientModel] = []
    
    init() {}
    
    init(_ recipeVersion: RecipeVersion) {
        self.id = recipeVersion.id
        self.orderNumber = recipeVersion.orderNumber
        self.instructions = recipeVersion.instructions
        self.notes = recipeVersion.notes
        self.ingredients = recipeVersion.ingredients.map(RecipeIngredientModel.init)
    }
    
    func tabName() -> String {
        return "v" + String(orderNumber)
    }
    
    
    func duplicate(newOrderNumber: Int) -> RecipeVersionModel {
        return RecipeVersionModel(
            RecipeVersion(
                id: UUID().uuidString,
                orderNumber: newOrderNumber,
                instructions: self.instructions,
                notes: self.notes,
                ingredients: self.ingredients.map({ ri in
                    ri.toIngredient()
                }))
        )
    }
}
