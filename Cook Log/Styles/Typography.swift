import SwiftUI

extension TextField {
    func title() -> some View {
        self
            .font(.largeTitle)
            .foregroundColor(Color.App.cocoaBean)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension Text {
    func h1() -> some View {
        self
            .font(.title2)
            .foregroundColor(Color.App.cocoaBean)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    func title() -> some View {
        self
            .font(.largeTitle)
            .foregroundColor(Color.App.cocoaBean)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func section() -> some View {
        self
            .font(.title)
            .foregroundColor(Color.App.cocoaBean)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func error() -> some View {
        self
            .font(.body)
            .foregroundColor(Color.App.cherryWood)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    func body(_ alignment: Alignment = .center) -> some View {
        self
            .font(.body)
            .foregroundColor(Color.App.cocoaBean)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}
