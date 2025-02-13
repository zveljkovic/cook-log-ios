import Foundation

struct RecipeFixture {
    private static var id = 0
    static func standard() -> Recipe {
        RecipeFixture.id += 1
        return Recipe(
            id: "Recipe Id " + RecipeFixture.id.formatted(),
            userId: "User Id " + RecipeFixture.id.formatted(),
            name: "Recipe Name " + RecipeFixture.id.formatted(),
            recipeVersions: RecipeVersionFixture.standardArray(n: 3)
        )
    }
    
    static func standardArray(n: Int) -> [Recipe] {
        var array = [Recipe]()
        for _ in 0 ... n {
            array.append(RecipeFixture.standard())
        }
        return array
    }
}
