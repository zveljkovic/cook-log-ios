import Foundation

struct IngredientFixture {
    private static var id = 0
    
    static func standard() -> Ingredient {
        IngredientFixture.id += 1
        return Ingredient(
            id: "Ingredient Id" + IngredientFixture.id.formatted(),
            name: "Ingredient Name " + IngredientFixture.id.formatted(),
            amount: Int.random(in: 1 ..< 100).formatted(),
            unit: "Ingredient unit " + IngredientFixture.id.formatted()
        )
    }
    
    static func standardArray(n: Int) -> [Ingredient] {
        var array = [Ingredient]()
        for _ in 0 ... n {
            array.append(IngredientFixture.standard())
        }
        return array
    }
}
