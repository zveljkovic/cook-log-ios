import Foundation

class MockUser: User {
    private var _id: String
    
    var id: String {
        get { self._id }
    }
    
    init(_ id: String) {
        self._id = id
    }
}
