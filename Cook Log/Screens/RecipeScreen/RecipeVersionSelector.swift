import SwiftUI
import Combine


struct RecipeVersionSelector: View {
    @ObservedObject private var model: RecipeModel
    
    init(_ model: RecipeModel) {
        self.model = model
    }
    
    var body: some View {
        HStack() {
            ScrollView(.horizontal) {
                HStack() {
                    ForEach(model.recipeVersions, id: \.self) { version in
                        Text("\(version.tabName())")
                            .font(.body)
                            .foregroundColor(Color.App.cocoaBean)
                            .frame(minHeight: 36, alignment: .center)
                            .padding(.horizontal, Sizing.horEdge / 2)
                            .background(version == model.activeVersion ? Color.App.beaver : Color.clear)
                            .onTapGesture {
                                self.model.setActiveVersion(version)
                            }
                    }
                }
            }
            Button {self.model.duplicateActive()} label: {
                Image(systemName: "doc.on.doc.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.App.cocoaBean)
            }.padding(.horizontal, Sizing.horEdge/2)
        }
            .background(Color.App.zorba)
            .border(Color.App.cocoaBean)
    }
}

#Preview {
    return RecipeVersionSelector(
        RecipeModel(RecipeFixture.standard())
    )
}
