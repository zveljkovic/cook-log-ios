import SwiftUI

struct ZRecipeTextSection: View {
    @State var editMode = false
    @State var text: String
    @State var header: String
    var onTextChanged: (_ newText: String) -> Void
    
    init(_ header: String, _ text: String, _ onTextChanged: @escaping (_ newText: String) -> Void = {_ in }, _ editMode: Bool = false) {
        self.header = header
        self.text = text
        self.onTextChanged = onTextChanged
        self.editMode = editMode
    }
    
    
    var body: some View {
        HStack {
            Text(self.header).section()
                .padding(.bottom, Sizing.verComponentSmall)
            Spacer()
            Button {
                Router.shared.path.append(RecipeTextEntryModel(header: "Instructions", text: "Lorem ipsum"))
                self.editMode = true
            } label: {
                Image(systemName: "pencil.line")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.App.cocoaBean)
            }.padding(.horizontal, Sizing.horEdge/2)
        }
        if (editMode) {
            TextField(text: self.$text, axis: .vertical, label: {
                Text("Enter your instructions")
            })
                .lineLimit(10, reservesSpace: true)
                .padding(.all)
                .background(
                    RoundedRectangle(cornerRadius: Sizing.textFieldRadius)
                    .strokeBorder(Color.App.cocoaBean)
                )
            HStack() {
                Spacer()
                ZButton("Accept") {
                    self.editMode = false
                    self.onTextChanged(self.text)
                }
                .padding(.horizontal, Sizing.horEdge)
            }
        } else {
            Text(text).body(.leading)
        }
    }
}

#Preview {
    ZRecipeTextSection("Section", "Lorem ipsum dolor sit amet")
}

#Preview {
    ZRecipeTextSection("Section", "Lorem ipsum dolor sit amet", {newText in}, true)
}
