import SwiftUI

struct ZTextFieldPicker: View {
    var text: Binding<String>
    var options: [String]
    var label: String
    let labelWidth: CGFloat
    @State var myvar: String = ""
    @State private var selection = "Red"
    let colors = ["Red", "Green", "Blue", "Black", "Tartan"]

    func onOptionSelect(_ value: String) -> Void {
        text.wrappedValue = value
    }
     
    init(_ label: String, _ text: Binding<String>, _ options: [String], _ labelWidth: Int) {
        self.label = label
        self.text = text
        self.options = options
        self.labelWidth = String(repeating: "W", count: labelWidth + 1).widthOfString(usingFont: .body) + Sizing.textFieldPadding * 2
    }
    
    
    
    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .frame(width: self.labelWidth, height: Sizing.textFieldHeight)
                .padding(.horizontal, Sizing.textFieldPadding)
                .foregroundColor(.App.alto)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: Sizing.textFieldRadius,
                        bottomLeadingRadius: Sizing.textFieldRadius,
                        topTrailingRadius: 0
                    )
                    .foregroundColor(Color.App.cocoaBean)
                )
            TextField(text: text, label: {
                Text(label)
            })
                .frame(height: Sizing.textFieldHeight)
                .padding(.horizontal)
                .background(
                    Rectangle()
                        .stroke(Color.App.cocoaBean)
                )
            
            Menu {
                if (options.isEmpty) {
                    Text("No selection available")
                } else {
                    ForEach(options, id: \.self) {o in
                        Button(o, action: { onOptionSelect(o) })
                    }
                }
            } label: {
                Image(systemName: "eyedropper")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.App.alto)
                .frame(width: 36, height: Sizing.textFieldHeight)
                .padding(.horizontal, Sizing.textFieldPadding)
                .foregroundColor(.App.alto)
                .background(
                    UnevenRoundedRectangle(
                        bottomTrailingRadius: Sizing.textFieldRadius,
                        topTrailingRadius: Sizing.textFieldRadius
                    )
                    .foregroundColor(Color.App.cocoaBean)
                )
            }
        }
    }
}

#Preview {
    ZTextFieldPicker("text", .constant("zed"), ["asdf", "qwer", "zxcv"], 5)
}
