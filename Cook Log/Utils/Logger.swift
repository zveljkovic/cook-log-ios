import OSLog
import Factory

class Log {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!
    let auth = Logger(subsystem: subsystem, category: "auth")
    let g = Logger(subsystem: subsystem, category: "general")
    let statistics = Logger(subsystem: subsystem, category: "statistics")
    let data = Logger(subsystem: subsystem, category: "data")
    let network = Logger(subsystem: subsystem, category: "network")
}

extension Container {
    var log: Factory<Log> { self { Log() }.singleton}
}
