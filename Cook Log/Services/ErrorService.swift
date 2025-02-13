import Factory

class ErrorService: ObservableObject {
    @Published var error: (any Error)?
}

extension Container {
    var errorService: Factory<ErrorService> {
        self { ErrorService() }.cached
    }
}
