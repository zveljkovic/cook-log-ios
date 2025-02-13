import SwiftUI
import Factory

struct RecipeScreen: View {
    @ObservedObject var model: RecipeModel
    @ObservedObject private var keyboard = KeyboardResponder()
    @Injected(\.log) var log
    
    init(_ recipe: Recipe) {
        self.model = RecipeModel(recipe)
    }
    
    var body: some View {
        VStack() {
            StatusBar()
            HStack(alignment: .center) {
                if (self.model.editTitle) {
                    TextField(text: self.$model.title, label: {
                        Text("Title")
                            .padding(.bottom, 0)
                    })
                        .title()
                        .padding(.horizontal, Sizing.horEdge/2)
                    Spacer()
                    Button {
                        self.model.editTitle = false
                        self.model.needSave = true
                    } label: {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.App.cocoaBean)
                    }.padding(.horizontal, Sizing.horEdge/2)
                } else {
                    Text(self.model.title).title()
                        .padding(.horizontal, Sizing.horEdge/2)
                        .padding(.bottom, 0)
                        .onLongPressGesture {
                            self.model.editTitle = true
                        }
                    Spacer()
                    if (model.needSave) {
                        Button {
                            Task {
                                await model.save()
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.App.cocoaBean)
                        }.padding(.horizontal, Sizing.horEdge/2)
                    }
                }
                
            }
            RecipeVersionSelector(model)
            ScrollView {
                // Ingredients header
                HStack() {
                    Text("Ingredients").section().fixedSize()
                    Spacer().frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    ZButton("Add", self.model.addIngredient)
                }
                .padding(.vertical, Sizing.verComponent/2)
                // Ingredients list
                ForEach(self.model.activeVersion.ingredients) { ingredient in
                    HStack() {
                            Text(ingredient.name)
                                .body(.leading)
                            Image(systemName: "checkmark.seal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.App.cocoaBean)
                                .opacity(ingredient.checked ? 1.0 : 0.0)
                        Spacer()
                        Text("\(ingredient.amount) \(ingredient.unit)").body(.trailing)
                    }
                    .padding(.vertical, Sizing.verComponent/2)
                    .overlay(
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .bottom)
                            .foregroundColor(Color.App.cocoaBean), alignment: .bottom)
                    .onTapGesture { _ in
                        self.model.toggleIngredient(ingredient)
                    }.onLongPressGesture {
                        self.model.editIngredient(ingredient)
                    }
                }
                // Instructions
                HStack {
                    Text("Instructions").section()
                        .padding(.bottom, Sizing.verComponentSmall)
                    Spacer()
                    Button {
                        self.model.editInstructions()
                    } label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.App.cocoaBean)
                    }
                }
                Text(model.activeVersion.instructions).body(.leading)
            
                // Notes
                HStack {
                    Text("Notes").section()
                        .padding(.bottom, Sizing.verComponentSmall)
                    Spacer()
                    Button {
                        self.model.editNotes()
                    } label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.App.cocoaBean)
                    }
                }
                Text(model.activeVersion.notes).body(.leading)

            }
            .padding(.horizontal, Sizing.horEdge/2)
            .padding(.bottom, keyboard.currentHeight)
            .frame(idealHeight: .infinity)
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
    RecipeScreen(Recipe(id: "id", userId: "userId", name: "My sunny funny running eggs", recipeVersions: RecipeVersionFixture.standardArray(n: 2)))
}
