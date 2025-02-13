import Foundation
import Factory

import SwiftUI



struct ErrorScreen: View {
    @State var error:  any Error
    
    init(_ error: any Error) {
        self.error = error
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Error happened!")
            Text(error.localizedDescription)
        }
        .padding()
    }
}

#Preview {
    ErrorScreen(URLError(URLError.Code.badURL))
}

