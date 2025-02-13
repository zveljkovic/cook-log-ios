import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack() {
            ProgressView()
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
        )
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
    }
}

#Preview {
    LoadingScreen()
}
