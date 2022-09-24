//
//  LoginView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct LoginView: View {
    @State var loginModel = LoginModel()

    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack(alignment: .leading, spacing: 30) {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter a few details to get started")
                        .font(.system(size: 30))

                    Text("For privacy and security reasons, All information collected is always kept on your device.")
                        .font(.system(.body).italic())
                        .opacity(0.9)
                }

                vstack("Your AUCA Student ID", $loginModel.studentId)

                vstack("Your First Name", $loginModel.firstName)

                vstack("Your Last Name", $loginModel.lastName)

                Button {

                } label: {
                    HStack {
                        Text("Get Transcript")
                            .font(.headline)

                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.accentColor)
                .cornerRadius(16)
                }


                Group {
                    ForEach(0..<2) { _ in
                        Spacer()
                    }
                }

            }
            .padding()
            .foregroundColor(.white)
        }
    }

    private var backgroundView: some View {
        Color.black.edgesIgnoringSafeArea(.all)
    }

    private func vstack(_ title: String, _ textBinding: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            TextField("...",
                      text: textBinding)
            .autocorrectionDisabled()
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .font(.system(size: 20,
                          design: .rounded))
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .foregroundColor(.black)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView {
    struct LoginModel {
        var studentId = ""
        var firstName = ""
        var lastName = ""
    }
}
