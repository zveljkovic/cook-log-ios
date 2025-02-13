import Foundation
import SwiftUI
import Factory

@MainActor
class RecipeModel : ObservableObject {
    @Injected(\.log) var log
    @InjectedObject(\.dataService) private var dataService
    private let initialRecipe: Recipe
    private var currentRecipe: Recipe
    @Published var needSave: Bool
    @Published var recipeVersions: [RecipeVersionModel]
    @Published var activeVersion: RecipeVersionModel
    @Published var editTitle: Bool = false
    @Published var title: String
    init(_ recipe: Recipe) {
        self.initialRecipe = recipe
        self.currentRecipe = recipe
        self.title = self.currentRecipe.name
        self.needSave = self.initialRecipe.id == nil
        let rvm = recipe.recipeVersions.map(RecipeVersionModel.init)
        self.recipeVersions = rvm
        self.activeVersion = rvm[0]
    }
    
//    var name: String {
//        self.currentRecipe.name
//    }
    
    
    func duplicateActive() {
        let dupe = activeVersion.duplicate(newOrderNumber: self.recipeVersions.count + 1)
        self.recipeVersions = [dupe] + self.recipeVersions
        self.activeVersion = dupe
        self.needSave = true
    }
    
    func setActiveVersion(_ active: RecipeVersionModel) {
        self.activeVersion = active
    }
    
    func getUnitList() -> [String] {
        var unitList : [String] = []
        let recipes = dataService.userData?.recipes ?? []
        for r in recipes {
            for rv in r.recipeVersions {
                for i in rv.ingredients {
                    if !unitList.contains(i.unit) {
                        unitList.append(i.unit)
                    }
                }
            }
        }
        
        return unitList
    }
    
    func getNameList() -> [String] {
        var nameList : [String] = []
        let recipes = dataService.userData?.recipes ?? []
        for r in recipes {
            for rv in r.recipeVersions {
                for i in rv.ingredients {
                    if !nameList.contains(i.name) {
                        nameList.append(i.name)
                    }
                }
            }
        }
        return nameList
    }
    
    func addIngredient() {
        Router.shared.path.append(
            RecipeIngredientEntryModel(
                ingredient: RecipeIngredientModel(Ingredient(id: UUID().uuidString, name: "", amount: "", unit: "")),
                nameList: getNameList(),
                unitList: getUnitList(),
                enableDelete: false,
                onUpdate: { ingredient in
                    self.activeVersion.ingredients.append(ingredient)
                    let index = self.currentRecipe.recipeVersions.firstIndex { rv in
                        rv.id == self.activeVersion.id
                    }
                    self.currentRecipe.recipeVersions[index!].ingredients.append(ingredient.toIngredient())
                    self.needSave = true
                },
                onDelete: { _ in
                },
                onCancel: {
                }
            ))
    }
    
    func editIngredient(_  ingredient: RecipeIngredientModel) {
        Router.shared.path.append(
            RecipeIngredientEntryModel(
                ingredient: ingredient,
                nameList: getNameList(),
                unitList: getUnitList(),
                enableDelete: true,
                onUpdate: { ing in
                    ingredient.name = ing.name
                    ingredient.amount = ing.amount
                    ingredient.unit = ing.unit
                    self.needSave = true
                },
                onDelete: { _ in
                    self.objectWillChange.send()
                    self.activeVersion.ingredients.remove(at: self.activeVersion.ingredients.firstIndex(of: ingredient )!)
                },
                onCancel: {
                }
            ))
    }
    
    func toggleIngredient(_ ingredient: RecipeIngredientModel) {
        self.objectWillChange.send()
        ingredient.checked = !ingredient.checked
    }
    
    func editInstructions() {
        Router.shared.path.append(
            RecipeTextEntryModel(
                header: "Instructions",
                text: self.activeVersion.instructions,
                onUpdate: { newText in
                    self.activeVersion.instructions = newText
                    self.needSave = true
                }))
    }
    
    func editNotes() {
        Router.shared.path.append(
            RecipeTextEntryModel(
                header: "Notes",
                text: self.activeVersion.notes,
                onUpdate: { newText in
                    self.activeVersion.notes = newText
                    self.needSave = true
                }))
    }
    
    func save() async {
        let ud = self.dataService.userData!
        
        self.currentRecipe.name = self.title
        if (self.initialRecipe.id == nil) {
            self.currentRecipe.id = UUID().uuidString
            ud.recipes.append(self.currentRecipe)
        } else {
            let index = ud.recipes.firstIndex(where: { r in
                r.id == self.currentRecipe.id
            })
            ud.recipes.remove(at: index!)
            ud.recipes.insert(self.currentRecipe, at: index!)
        }
        await self.dataService.saveData()
        self.needSave = false
    }
}

