
import Foundation
import Factory
import FirebaseAuth

class DataModel: ObservableObject {
    @Published var userData: UserData?
    @Published var dataError: String?
}


extension Container {
    var dataModel: Factory<DataModel> { self { DataModel() }.singleton}
}
