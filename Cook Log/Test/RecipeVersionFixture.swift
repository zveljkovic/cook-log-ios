import Foundation

struct RecipeVersionFixture {
    private static var id = 0
    static func standard() -> RecipeVersion {
        RecipeVersionFixture.id += 1
        return RecipeVersion(
            id: "RecipeVersion Id " + RecipeVersionFixture.id.formatted(),
            orderNumber: RecipeVersionFixture.id,
            instructions: "Recipe Version Instructions " + RecipeVersionFixture.id.formatted() + " Lorem ipsum dolor sit amet, consectetur adipiscing elit. In maximus sem eget ipsum placerat, ut sollicitudin metus sollicitudin. Morbi id rhoncus nulla. Morbi volutpat porttitor efficitur. In sit amet purus feugiat, consequat nibh sit amet, fermentum nisl. In iaculis massa odio, ac iaculis dolor porttitor in. Pellentesque dapibus mauris id euismod hendrerit. Sed eu mi pretium, dictum ligula quis, consequat leo. Integer vitae dui id arcu pulvinar aliquet et sed mauris. Integer euismod, nibh at porta lacinia, ante lacus accumsan risus, quis sagittis felis mauris et odio. Ut hendrerit quis nibh non fermentum. Ut sit amet felis ullamcorper, porta metus nec, aliquet mi. Quisque vel nunc non velit maximus tempus eu quis magna. Quisque vitae justo eu eros interdum egestas id et risus. Duis sodales commodo egestas.",
            notes: "Recipe Version Notes " + RecipeVersionFixture.id.formatted() + "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In maximus sem eget ipsum placerat, ut sollicitudin metus sollicitudin. Morbi id rhoncus nulla. Morbi volutpat porttitor efficitur. In sit amet purus feugiat, consequat nibh sit amet, fermentum nisl. In iaculis massa odio, ac iaculis dolor porttitor in. Pellentesque dapibus mauris id euismod hendrerit. Sed eu mi pretium, dictum ligula quis, consequat leo. Integer vitae dui id arcu pulvinar aliquet et sed mauris. Integer euismod, nibh at porta lacinia, ante lacus accumsan risus, quis sagittis felis mauris et odio. Ut hendrerit quis nibh non fermentum. Ut sit amet felis ullamcorper, porta metus nec, aliquet mi. Quisque vel nunc non velit maximus tempus eu quis magna. Quisque vitae justo eu eros interdum egestas id et risus. Duis sodales commodo egestas.",
            ingredients: IngredientFixture.standardArray(n: 3)
        )
    }
    
    static func standardArray(n: Int) -> [RecipeVersion] {
        var array = [RecipeVersion]()
        for _ in 0 ... n {
            array.append(RecipeVersionFixture.standard())
        }
        return array
    }
}
