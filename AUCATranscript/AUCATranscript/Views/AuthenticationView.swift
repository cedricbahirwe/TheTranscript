//
//  AuthenticationView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 01/10/2022.
//

import SwiftUI

struct AuthenticationView: View {
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
                    .colorMultiply(.blue)
                    .colorMultiply(.blue)
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
                            .multilineTextAlignment(.leading)
                    }

                    Button(action: {}) {
                        Image(systemName: "photo.on.rectangle")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                            .multilineTextAlignment(.leading)
                    }
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
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
