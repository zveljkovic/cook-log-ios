import Factory
import SwiftUI

struct AuthScreen: View {
    @State var mainScreen: String
    @Injected(\.log) var log
    @Injected(\.authService) var authService
    @State var loginEmail: String = "zzzveljkovic+cooklog1@gmail.com"
    @State var loginPassword: String = "asdfasdf"
    @State var loginError: String? = nil
    @State var loginShowEmail = false
    
    
    enum FocusedFieldCreate: Hashable{
        case createEmail, createPassword, createPasswordConfirmation
    }
    @FocusState var focusedField: FocusedFieldCreate?
    @State var createEmail: String = "zzzveljkovic+cooklog1@gmail.com"
    @State var createPassword: String = "asdfasdf"
    @State var createPasswordConfirmation: String = "asdfasdf"
    @State var createAwaitingResponse = false
    @State var createError: String? = nil
    
    init(show: String = "login") {
        self.mainScreen = show
    }

    var body: some View {
        GeometryReader { metrics in
            VStack(spacing: 0) {
                Spacer().frame(height: 70)
                Image("AuthScreenLogo")
                    .resizable()
                    .frame(width: metrics.size.width * 0.6, height: metrics.size.width * 0.6)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.App.cocoaBean)
                Spacer()
                if self.mainScreen == "login" {
                    if (!loginShowEmail) {
                        ZButton("Login with Facebook", self.fbLogin).transition(.opacity)
                            .padding(.horizontal, Sizing.horEdge)
                            .padding(.bottom, Sizing.verComponent)
                        ZButton("Login with Google", self.googleLogin).transition(.opacity)
                            .padding(.horizontal, Sizing.horEdge)
                            .padding(.bottom, Sizing.verComponent)
                        ZButton("Login with Email", self.showEmailLogin)
                            .padding(.horizontal, Sizing.horEdge)
                            .padding(.bottom, Sizing.verComponent)
                    }
                    if (loginShowEmail) {
                        ZTextField("Email", self.$loginEmail, 8)
                            .padding(.horizontal, Sizing.horEdge)
                            .padding(.bottom, Sizing.verComponent)
                            .transition(.opacity)
                        ZSecureField("Password", self.$loginPassword, 8)
                            .padding(.horizontal, Sizing.horEdge)
                            .padding(.bottom, Sizing.verComponent)
                            .transition(.opacity)
                        ZButton("Login", self.login)
                            .padding(.horizontal, Sizing.horEdge)
                            .padding(.bottom, Sizing.verComponent)
                    }
                    Text(self.loginError ?? " ").error()
                } else {
                    Text(self.createError ?? " ").error()
                    ZTextField("Email", $createEmail, 14)
                        .padding(.horizontal, Sizing.horEdge)
                        .padding(.bottom, Sizing.verComponent)
                        .transition(.opacity)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .createEmail)
                        .onSubmit {
                            focusedField = .createPassword
                        }

                    ZSecureField("Password", $createPassword, 14)
                        .padding(.horizontal, Sizing.horEdge)
                        .padding(.bottom, Sizing.verComponent)
                        .transition(.opacity)
                        .focused($focusedField, equals: .createPassword)
                        .onSubmit {
                            focusedField = .createPasswordConfirmation
                        }
                    ZSecureField("Password again", $createPasswordConfirmation, 14)
                        .padding(.horizontal, Sizing.horEdge)
                        .padding(.bottom, Sizing.verComponent)
                        .transition(.opacity)
                        .focused($focusedField, equals: .createPasswordConfirmation)
                        .onSubmit {
                            focusedField = nil
                        }
                    ZButton("Create account", self.createAccount, showProgress: createAwaitingResponse)
                        .padding(.horizontal, Sizing.horEdge)
                        .padding(.bottom, Sizing.verComponent)
                }
                Spacer()
                if self.mainScreen == "login" {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                        ZTextButton("Back to login options", self.showAllLoginOptions)
                        .padding(.horizontal, Sizing.horEdge)
                        .opacity(self.loginShowEmail ? 1 : 0)
                        Spacer()
                        ZTextButton("Create email account?") {
                            withAnimation {
                                self.mainScreen = "createAccount"
                            }
                        }
                        .padding(.horizontal, Sizing.horEdge)
                    })
                } else {
                    ZTextButton("I have an account") {
                        withAnimation {
                            self.mainScreen = "login"
                        }
                    }
                    .padding(.horizontal, Sizing.horEdge)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }.background(alignment: .topLeading, content: {
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
}

#Preview {
    AuthScreen()
}

#Preview {
    AuthScreen(show: "create") 
}
