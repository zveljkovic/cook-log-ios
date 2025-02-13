import Foundation

struct Recipe: Codable, Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(self.id)
//        hasher.combine(self.userId)
//        
//    }
//    
//    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
    var id: String?
    var userId: String
    var name: String
    var recipeVersions: [RecipeVersion]
    
    init(id: String?, userId: String, name: String, recipeVersions: [RecipeVersion]) {
        self.id = id
        self.userId = userId
        self.name = name
        self.recipeVersions = recipeVersions
    }
}
