import Factory
import Foundation
import Network

public class NetworkService: ObservableObject {
    @Injected(\.log) private var log
    @Published var connected: Bool = false
    private let queue = DispatchQueue(label: "NetworkService")
    private let monitor = NWPathMonitor()
    private var timer: Timer?

    func startConnectivityChecks() {
        monitor.pathUpdateHandler = { _ in
            self.log.network.info("Path update handler")
            Task {
                let connected = await self.ping()
                if connected != self.connected {
                    DispatchQueue.main.async { self.connected = connected }
                    self.log.network.info("Connection state changed to \(connected)")
                }
            }
        }
        monitor.start(queue: queue)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10), repeats: true, block: { _ in
            Task {
                let connected = await self.ping()
                if connected != self.connected {
                    DispatchQueue.main.async { self.connected = connected }
                }
            }
        })
    }
    
    func simulateOnOff() {
        log.network.info("Simulating On/Off Network")
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(5), repeats: true, block: { _ in
            Task {
                DispatchQueue.main.async { self.connected = !self.connected }
            }
        })
    }

    private func ping(completion: @escaping (Bool) -> Void) {
        let endpoint = NWEndpoint.hostPort(host: "google.com", port: 80)
        let connection = NWConnection(to: endpoint, using: .udp)
        var completionSent = false
        connection.stateUpdateHandler = { state in
            switch state {
            case .failed(let error):
                self.log.network.info("Connection state error: \(error.localizedDescription)")
                completion(false)
                return
            case .ready:
                let content = "Ping".data(using: .utf8)
                connection.send(content: content, completion: .contentProcessed { error in
                    connection.cancel()
                    if error != nil {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            case .cancelled:
                break
            case .preparing:
                break
            case .setup:
                break
            case .waiting(let error):
                if (!completionSent && error == NWError.posix(POSIXErrorCode.ENETDOWN)) {
                    connection.cancel()
                    completionSent = true
                    completion(false)
                }
                default:
                    break
            }
        }
        connection.start(queue: .main)
    }

    func ping() async -> Bool {
        return await withCheckedContinuation { continuation in
            ping { success in
                continuation.resume(returning: success)
            }
        }
    }
}

extension Container {
    var networkService: Factory<NetworkService> { self { NetworkService() }.singleton }
}
