import SwiftUI

struct ZSecureField: View {
    var text: Binding<String>
    let label: String
    let labelWidth: CGFloat

    init(_ label: String, _ text: Binding<String>, _ labelWidth: Int) {
        self.label = label
        self.text = text
        self.labelWidth = String(repeating: "W", count: labelWidth + 1).widthOfString(usingFont: .body) + Sizing.textFieldPadding * 2
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .padding(.horizontal)
                .frame(width: labelWidth, height: Sizing.textFieldHeight)
                .foregroundColor(.App.alto)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: Sizing.textFieldRadius,
                        bottomLeadingRadius: Sizing.textFieldRadius,
                        topTrailingRadius: 0
                    ).foregroundColor(Color.App.cocoaBean)
                )
            SecureField(text: text, label: {
                Text(label)
            })
                .frame(height: Sizing.textFieldHeight)
                .padding(.horizontal)
                .background(
                    UnevenRoundedRectangle(
                        bottomTrailingRadius: Sizing.textFieldRadius,
                        topTrailingRadius: Sizing.textFieldRadius
                    )
                    .strokeBorder(Color.App.cocoaBean)
                )
        }
    }
}

#Preview {
    ZSecureField("test", .constant("zed"), 5)
}
