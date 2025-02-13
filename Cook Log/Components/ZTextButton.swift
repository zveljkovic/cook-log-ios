import SwiftUI

struct ZTextButton: View {
    private var buttonText: String
    private var onButtonClick: () -> Void
    
    init(_ buttonText: String,_ onButtonClick: @escaping () -> Void) {
        self.buttonText = buttonText
        self.onButtonClick = onButtonClick
    }
    
    var body: some View {
        Button(self.buttonText, action: onButtonClick)
            .foregroundColor(.App.cocoaBean)
    }
}

#Preview {
    ZTextButton("Some text"){}
}
