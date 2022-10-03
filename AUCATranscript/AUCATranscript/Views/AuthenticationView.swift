//
//  AuthenticationView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 01/10/2022.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var studentID = ""
    @State private var studentIDPictureData: Data?

    var body: some View {
        ZStack {
            MainBackgroundView()

            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("Enter your AUCA Student ID")
                        .bold()
                        .foregroundColor(.white)

                    TextField("",
                              text: $studentID.onChange(cleanEnteredID))
                    .keyboardType(.decimalPad)
                    .font(.body.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(width: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 1.5)
                    )
                }

                Divider()
                    .background(Color.black)

                HStack {
                    Text("Upload your student ID card picture")
                        .bold()
                        .foregroundColor(.white)

                    Button(action: {}) {
                        Image(systemName: "camera")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }

                    Button(action: {}) {
                        Image(systemName: "photo.on.rectangle")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                }

                Button(action: {
                    guard let id = validatedID() else { return }
                    appSession.setLogginState(true, id)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.green)
                        Text("Complete").bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(validatedID() == nil ? Color.gray : Color.accentColor)
                    .clipShape(Capsule())
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
    }

    private func cleanEnteredID(_ id: String) {
        let lettersRemoved = id.components(separatedBy: CharacterSet.letters).joined()
        let spacesRemoved = lettersRemoved.components(separatedBy: .whitespacesAndNewlines).joined()
        let symbolsRemoved = spacesRemoved.components(separatedBy: .symbols).joined()

        self.studentID = String(symbolsRemoved.prefix(5))
    }

    private func validatedID() -> Int? {
        guard studentID.count == 5 else { return nil }
        return Int(studentID)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AppSession.shared)
    }
}
