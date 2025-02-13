import SwiftUI
import Factory

@MainActor
struct SupportDevPopUp: View {
    @State var closeAction: () async -> Void  = {}
    @InjectedObject(\.dataService) private var dataService
    
    func support(_ supportAmount: Int) async {
        if (supportAmount == 0) {
            dataService.userData!.hideForFree()
        } else {
            dataService.userData!.hideForMoney(supportAmount)
        }
        await dataService.saveData()
    }
    
    var body: some View {
        VStack {
            Text("Support developer")
                .title()
                .padding()
                .foregroundStyle(.gray)
            Text("If you find the app useful please consider supporting the developer for his time and also to cover running costs for the app. ")
                .body()
                .padding(.bottom)
                .padding(.horizontal)
                .foregroundStyle(.gray)
            Text("If you use payed option, support button will be disabled for a year. After a year you will have option to support the developer again or to disable it free for another year. Free option disables support button for a week.")
                .body()
                .padding(.bottom)
                .padding(.horizontal)
                .foregroundStyle(.gray)
            
            HStack {
                ZButton("Free"){
                    Task {
                        await support(0)
                    }
                }
                ZButton("$1"){
                    Task {
                        await support(1)
                    }
                }
                ZButton("$2"){
                    Task {
                        await support(2)
                    }
                }
                ZButton("$3"){
                    Task {
                        await support(3)
                    }
                }
            }
            .padding(.horizontal)
            HStack {
                ZButton("$5"){
                    Task {
                        await support(5)
                    }
                }
                ZButton("$10"){
                    Task {
                        await support(10)
                    }
                }
                ZButton("$20"){
                    Task {
                        await support(20)
                    }
                }
                ZButton("$50"){
                    Task {
                        await support(50)
                    }
                }
            }
            .padding(.horizontal)
            ZButton("Close (no action)") {
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
    SupportDevPopUp()
}
