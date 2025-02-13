import SwiftUI

struct HelpPopUp: View {
    @State var closeAction: () async -> Void  = {}
    
    var body: some View {
        VStack {
            Text("Welcome to Cook Log")
                .title()
                .padding()
                .foregroundStyle(.gray)
            Text("This is a small app to track your notes and versions of the recipes. It is free to use with non intrusive option to support developer.")
                .body()
                .padding()
                .foregroundStyle(.gray)
            Text("This is one time help screen, but you can reset help again in options..")
                .body()
                .padding()
                .foregroundStyle(.gray)
            
            ZButton("Lets Start") {
                Task {
                    await closeAction()
                }
            }
            .padding()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.App.zorba)
                .shadow(radius: 6)
        }
        .padding()
    }
    
    
}

#Preview {
    HelpPopUp()
}
