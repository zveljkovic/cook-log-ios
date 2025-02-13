import SwiftUI
import Factory

class RecipeIngredientEntryModel : Hashable {
    static func == (lhs: RecipeIngredientEntryModel, rhs: RecipeIngredientEntryModel) -> Bool {
        lhs.ingredient.id == rhs.ingredient.id
    }
    
    func hash(into hasher: inout Hasher) {
       // hasher.combine(self.ingredient)
    }
    
    var ingredient: RecipeIngredientModel
    var nameList: [String]
    var unitList: [String]
    var enableDelete: Bool
    var onUpdate: (_ ingredient: RecipeIngredientModel) -> Void
    var onDelete: (_ ingredient: RecipeIngredientModel) -> Void
    var onCancel: () -> Void
    
    init(ingredient: RecipeIngredientModel, nameList: [String], unitList: [String], enableDelete: Bool, onUpdate: @escaping (_: RecipeIngredientModel) -> Void = {_ in }, onDelete: @escaping (_: RecipeIngredientModel) -> Void = {_ in }, onCancel: @escaping () -> Void = { }) {
        self.ingredient = ingredient
        self.nameList = nameList
        self.unitList = unitList
        self.enableDelete = enableDelete
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self.onCancel = onCancel
    }
}

struct RecipeIngredientEntryScreen: View {
    let ingredient: RecipeIngredientModel
    @State var name: String
    @State var amount: String
    @State var unit: String
    @State var nameList: [String]
    @State var unitList: [String]
    @State var enableDelete: Bool
    @State var onUpdate: (_ ingredient: RecipeIngredientModel) -> Void
    @State var onDelete: (_ ingredient: RecipeIngredientModel) -> Void
    @State var onCancel: () -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(_ model: RecipeIngredientEntryModel) {
        self.ingredient = model.ingredient
        self.name = model.ingredient.name
        self.nameList = model.nameList
        self.amount = model.ingredient.amount
        self.unit = model.ingredient.unit
        self.unitList = model.unitList
        self.enableDelete = model.enableDelete
        self.onUpdate = model.onUpdate
        self.onDelete = model.onDelete
        self.onCancel = model.onCancel
    }
    
    func disableSubmit() -> Bool {
        if (name.trim().isEmpty) { return true }
        if (amount.trim().isEmpty) { return true }
        if (unit.trim().isEmpty) { return true }
        return false
    }
    
    var body: some View {
        VStack() {
            StatusBar()
            Text("Ingredient").title()
                .padding(.horizontal, Sizing.horEdge/2)
            ZTextFieldPicker("Name", self.$name, nameList, 6)
                .padding(.horizontal, Sizing.horEdge/2)
            ZTextField("Amount", self.$amount, 6)
                .padding(.horizontal, Sizing.horEdge/2)
            ZTextFieldPicker("Unit", self.$unit, unitList, 6)
                .padding(.horizontal, Sizing.horEdge/2)
            if enableDelete {
                ZButton("Delete", {
                    self.onDelete(self.ingredient)
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.horizontal, Sizing.horEdge/2)
                .padding(.top, Sizing.verComponent)
            }
            Spacer()
            HStack {
                ZButton("Cancel", {
                    self.onCancel()
                    presentationMode.wrappedValue.dismiss()
                })
                Spacer()
                ZButton(self.enableDelete ? "Update" : "Add", {
                    let ingredient = RecipeIngredientModel(Ingredient(id: ingredient.id, name: name, amount: amount, unit: unit))
                    self.onUpdate(ingredient)
                    presentationMode.wrappedValue.dismiss()
                }, disabled: disableSubmit())
            }
            .padding(.horizontal, Sizing.horEdge/2)
            .padding(.vertical, Sizing.verComponentSmall)
        }.background(alignment: .top, content: {
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.05)
                .blendMode(.overlay)
                .background {
                    LinearGradient(gradient: Gradient(colors: [.App.zorba, .App.beaver]), startPoint: .top, endPoint: .bottom)
                        .blendMode(.normal)
                }
                .ignoresSafeArea()
        })
    }
}

#Preview {
    RecipeIngredientEntryScreen(RecipeIngredientEntryModel(ingredient: RecipeIngredientModel(IngredientFixture.standard()), nameList: ["n1", "n2"], unitList: ["u1", "u2"], enableDelete: false))
}

#Preview {
    RecipeIngredientEntryScreen(RecipeIngredientEntryModel(ingredient: RecipeIngredientModel(IngredientFixture.standard()), nameList: ["n1", "n2"], unitList: ["u1", "u2"], enableDelete: true))
}
