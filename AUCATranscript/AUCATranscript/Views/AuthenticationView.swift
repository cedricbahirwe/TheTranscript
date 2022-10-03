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
    @State private var isShowingScannerSheet = false
    @State private var notMatchFound = false
    @State private var isValidCard = true

    var body: some View {
        ZStack {
            MainBackgroundView()
                .onTapGesture {
                    hideKeyboard()
                }

            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("Enter your AUCA Student ID")
                        .bold()
                        .foregroundColor(.white)

                    HStack {
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

                        if validatedID() != nil {
                            Image(systemName: "checkmark")
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                }

                Divider()
                    .background(Color.black)

                HStack {
                    Text("Scan your AUCA Student Card")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button(action: openCamera) {
                        Image(systemName: isValidCard ? "checkmark" : "camera")
                            .padding(isValidCard ? 8 : 16)
                            .foregroundColor(.white)
                            .background(isValidCard ? Color.green : .accentColor)
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
                    .background(validatedID() == nil || !isValidCard ? Color.gray : Color.accentColor)
                    .clipShape(Capsule())
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $notMatchFound) {
            Alert(title: Text("Student Card Validation"),
                  message: Text("No match was found.\nPlease make sure to enter a valid Student ID and the Student Card should be clear and visible."),
                  dismissButton: .default(Text("Okay"))
            )
        }
        .sheet(isPresented: $isShowingScannerSheet) {
            makeScannerView()
                .edgesIgnoringSafeArea(.all)
        }
    }

}

// MARK: - Views
extension AuthenticationView {
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            self.isShowingScannerSheet = false
            DispatchQueue.main.async {
                if let scannedText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("The content is", scannedText)
                    self.isValidCard = appSession.validateStudentCardScan(scannedText, studentID)
                    if self.isValidCard == false {
                        self.notMatchFound = true
                    }
                }
            }

        })
    }
}

private extension AuthenticationView {
    func openCamera() {
        hideKeyboard()
        isShowingScannerSheet = true
    }

    func cleanEnteredID(_ id: String) {
        let lettersRemoved = id.components(separatedBy: CharacterSet.letters).joined()
        let spacesRemoved = lettersRemoved.components(separatedBy: .whitespacesAndNewlines).joined()
        let symbolsRemoved = spacesRemoved.components(separatedBy: .symbols).joined()

        self.studentID = String(symbolsRemoved.prefix(5))
    }

    func validatedID() -> Int? {
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
