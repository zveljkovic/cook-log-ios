import Foundation

class UserData: Codable {
    var versionNumber: UInt32 = 1
    var recipes: [Recipe] = []
    var showListScreenHelp: Bool = true
    var showDetailsScreenHelp: Bool = true
    var hideSupportButtonUntilDate: Date? = nil
    var totalSupport: Int = 0
    
    func showSupportButton() -> Bool {
        // show if we haven't hidden it
        if hideSupportButtonUntilDate == nil {
            return true
        }
        
        if Date.now.compare(hideSupportButtonUntilDate!) == .orderedAscending {
            // now is before hideSupportButtonUntilDate
            return false
        }
        
        return true
    }
    func hideForFree() {
        hideSupportButtonUntilDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: .now)
    }
    func hideForMoney(_ supportAmount: Int) {
        hideSupportButtonUntilDate = Calendar.current.date(byAdding: .year, value: 1, to: .now)
        totalSupport += supportAmount
    }
}
