import SwiftUI

struct ZButton: View {
    private var buttonText: String
    private var onButtonClick: () -> Void
    private var showProgress = false
    private var disabled = false
    
    init(_ buttonText: String, _ onButtonClick: @escaping () -> Void, showProgress: Bool = false, disabled: Bool = false) {
        self.buttonText = buttonText
        self.onButtonClick = onButtonClick
        self.showProgress = showProgress
        self.disabled = disabled
    }

    var body: some View {
        Button(action: onButtonClick) {
            if showProgress {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: Sizing.buttonHeight, maxHeight: Sizing.buttonHeight)
                    .foregroundColor(.App.cocoaBean)
                    .background(
                        RoundedRectangle(
                            cornerRadius: .infinity,
                            style: .continuous
                        )
                        .stroke(Color.App.cocoaBean, lineWidth: 2)
                    )
                
            } else {
                Text(buttonText)
                    .frame(maxWidth: .infinity, minHeight: Sizing.buttonHeight, maxHeight: Sizing.buttonHeight)
                    .foregroundColor(.App.cocoaBean)
                    .background(
                        RoundedRectangle(
                            cornerRadius: .infinity,
                            style: .continuous
                        )
                        .stroke(Color.App.cocoaBean, lineWidth: 2)
                    )
            }
        }.buttonStyle(PlainButtonStyle())
            .disabled(disabled)
        
    }
}

#Preview {
    ZButton("test testic") {
        
    }
}


#Preview {
    ZButton("test testic", {}, showProgress: true)
}
