import SwiftUI
import Factory


extension RecipeListScreen {
    var currentUser: String {
        authService.currentUser?.id ?? ""
    }
    
    var errorText: String? {
        dataService.dataError
    }

    
    func loadData() async {
        self.log.data.info("Loading for recipeList")
        self.loading = true
        await self.dataService.loadData()
        self.recipes = self.dataService.userData!.recipes
        self.firstTimeHelp = self.dataService.userData!.showListScreenHelp
        self.loading = false
    }
    
    func logout() {
        authService.logOut()
    }
    
    func openSettings() {
        withAnimation {
            showSettings = true
        }
    }
    
    func closeSettings() {
        withAnimation {
            showSettings = false
        }
    }
    
    func resetHelp() {
        helpStatus = true
    }
    
    func closeHelp() async {
        self.firstTimeHelp = false
        self.dataService.userData!.showListScreenHelp = false
        await self.dataService.saveData()
    }
    func closeSupport() async {
        self.supportDevShown = false
        // self.dataService.userData!.showListScreenHelp = false
        // await self.dataService.saveData()
    }
}

@MainActor
struct RecipeListScreen: View {
    @Injected(\.log) private var log
    @InjectedObject(\.authService) private var authService
    @InjectedObject(\.dataService) private var dataService
    
    @State var loading = false
    @State var showSettings = false
    @State var helpStatus = true
    @State var recipes: [Recipe] = []
    @State var firstTimeHelp = false
    @State var supportDevShown = true

    var body: some View {
        ZStack {
            VStack{
                StatusBar()
                if showSettings {
                    HStack {
                        Text("Settings").title()
                            .padding(.horizontal, Sizing.horEdge/2)
                        Spacer()
                        Button {closeSettings()} label: {
                            Image(systemName: "x.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.App.cocoaBean)
                        }.padding(.horizontal, Sizing.horEdge/2)
                    }
                    Spacer()
                    Text("Help status: " + (helpStatus ? "Enabled" : "Disabled"))
                        .padding(.bottom, Sizing.verComponent)
                    ZButton("Reset help") {
                        resetHelp()
                    }
                        .padding(.horizontal, Sizing.horEdge)
                        .padding(.bottom, Sizing.verComponent)
                    ZButton("Logout") {
                        logout()
                    }
                        .padding(.horizontal, Sizing.horEdge)
                    
                    Spacer()
                } else {
                    HStack {
                        Text("Recipe list").title()
                            .padding(.horizontal, Sizing.horEdge/2)
                        Spacer()
                        Button {openSettings()} label: {
                            Image(systemName: "ellipsis.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.App.cocoaBean)
                        }.padding(.horizontal, Sizing.horEdge/2)
                    }
                    Spacer()
                    if loading {
                        ProgressView()
                    } else {
                        if (recipes.isEmpty) {
                            Text("No recipes found, \n go go create one now")
                                .body()
                                .multilineTextAlignment(.center)
                        } else {
                            List(recipes, id: \.id) { recipe in
                                HStack(alignment: .center){
                                    Text(recipe.name)
                                        .h1()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, Sizing.verComponentSmall)
                                        .padding(.horizontal, Sizing.horEdge / 4)
                                        .background(Color.App.beaver)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.App.cocoaBean)
                                        )
                                        .onTapGesture {
                                            Router.shared.path.append(recipe)
                                        }
                                }
                                    .listRowInsets(.init(top: Sizing.verComponentSmall, leading: Sizing.horEdge/2, bottom: Sizing.verComponentSmall, trailing: Sizing.horEdge/2))
                                    .listRowBackground(Color.clear)
                                
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    Spacer()
                    ZButton("Support developer") {
                       
                    }
                    .padding(.horizontal, Sizing.horEdge)
                    ZButton("Create new recipe") {
                        let rv = RecipeVersion(id: UUID().uuidString, orderNumber: 1, instructions: "Instructions text", notes: "Notes", ingredients: [IngredientFixture.standard()])
                        let r = Recipe(id: nil, userId: "asd", name: "Recipe title", recipeVersions: [rv])
                        Router.shared.path.append(r)
                    }
                    .padding(.horizontal, Sizing.horEdge)
                }
                
                
            }
            .task {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                    await loadData()
                }
            }
            .background(alignment: .topTrailing, content: {
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
            if self.firstTimeHelp {
                HelpPopUp {
                    await self.closeHelp()
                }
            }
            if self.supportDevShown {
                SupportDevPopUp {
                    await self.closeSupport()
                }
            }
        }
        
        
        
    }
}

#Preview {
    RecipeListScreen()
}

#Preview {
    RecipeListScreen(firstTimeHelp: true)
}

#Preview {
    RecipeListScreen(recipes: [
        Recipe(id: "id", userId: "userId", name: "My sunny funny running eggs My sunny funny running eggs My sunny funny running eggs", recipeVersions: RecipeVersionFixture.standardArray(n: 2)),
        
        Recipe(id: "id", userId: "userId", name: " running eggs", recipeVersions: RecipeVersionFixture.standardArray(n: 2))
        
    ])
}

#Preview {
    RecipeListScreen(showSettings: true)
}
