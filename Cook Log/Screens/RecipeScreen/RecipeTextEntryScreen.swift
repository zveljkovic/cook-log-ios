import SwiftUI
import Factory

class RecipeTextEntryModel : Hashable {
    static func == (lhs: RecipeTextEntryModel, rhs: RecipeTextEntryModel) -> Bool {
        lhs.header == rhs.header && lhs.text == rhs.text
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.header)
        hasher.combine(self.text)
    }
    
    var header: String
    var text: String
    var onUpdate: (_ newText: String) -> Void
    var onCancel: () -> Void
    
    init(header: String, text: String, onUpdate: @escaping (_: String) -> Void = {_ in }, onCancel: @escaping () -> Void = { }) {
        self.header = header
        self.text = text
        self.onUpdate = onUpdate
        self.onCancel = onCancel
    }
}

struct RecipeTextEntryScreen: View {
    @State var header: String
    @State var text: String
    @State var onUpdate: (_ newText: String) -> Void
    @State var onCancel: () -> Void
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(_ model: RecipeTextEntryModel) {
        self.header = model.header
        self.text = model.text
        self.onUpdate = model.onUpdate
        self.onCancel = model.onCancel
    }
    
    var body: some View {
        VStack() {
            StatusBar()
            Text(self.header).title()
                .padding(.horizontal, Sizing.horEdge/2)
            TextEditor(text: self.$text)
                .padding(.horizontal, Sizing.horEdge/2)
                .scrollContentBackground(.hidden)
            HStack {
                ZButton("Cancel", {
                    self.onCancel()
                    presentationMode.wrappedValue.dismiss()
                })
                Spacer()
                ZButton("Update", {
                    self.onUpdate(self.text)
                    presentationMode.wrappedValue.dismiss()
                })
            }.padding(.horizontal, Sizing.horEdge/2)
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
    RecipeTextEntryScreen(RecipeTextEntryModel(header: "Instructions", text: "Lorem ipsum"))
}
