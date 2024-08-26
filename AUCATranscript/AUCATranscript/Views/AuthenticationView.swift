//
//  AuthenticationView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 01/10/2022.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var credentials = StudentCredentials()
    
    var body: some View {
        ZStack {
            MainBackgroundView()
                .onTapGesture(perform: hideKeyboard)

            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("Enter your AUCA Student ID")
                        .bold()
                        .foregroundColor(.white)

                    HStack {
                        TextField("", text: $credentials.username)
                        .keyboardType(.numberPad)
                        .font(.body.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .onChange(of: credentials.username) { newValue in
                            cleanEnteredID(newValue)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                }

                Divider()
                    .background(Color.white)
                
                Group {
                    Text("Enter your password")
                        .bold()
                        .foregroundColor(.white)

                    HStack {
                        SecureField("", text: $credentials.password)
                        .font(.body.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1)
                        )

                    }
                }

                Divider()
                    .background(Color.white)


                Button(action: login) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.green)
                        Text("Complete").bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(credentials.isValid() ? Color.accentColor : Color.gray)
                    .clipShape(Capsule())
                }
                .disabled(!credentials.isValid())

            }
            .frame(maxWidth: CGFloat.infinity > 500 ? 400 : .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            if appSession.isFetchingData {
                ActivityIndicatorView()
            }
        }
        .alert(item: $appSession.alert) { alert in
            Alert(title: Text(alert.title),
                  message: Text(alert.message),
                  dismissButton: .default(Text("Okay"),
                                          action: handleOkayAction)
            )
        }
    }
}

// MARK: - Private Methods

private extension AuthenticationView {

    /// Grant access if the validations have succeed
    func login() {
        appSession.loginWith(credentials: credentials)
    }

    private func handleOkayAction() {
        appSession.clearSession()
    }

    /// Clean the `StudentID` entered
    /// - Parameter id: the id value provided by the user
    func cleanEnteredID(_ id: String) {
        let lettersRemoved = id.components(separatedBy: CharacterSet.letters).joined()
        let spacesRemoved = lettersRemoved.components(separatedBy: .whitespacesAndNewlines).joined()
        let symbolsRemoved = spacesRemoved.components(separatedBy: .symbols).joined()

        self.credentials.username = String(symbolsRemoved.prefix(5))
    }
}

#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AppSession.shared)
    }
}
#endif
