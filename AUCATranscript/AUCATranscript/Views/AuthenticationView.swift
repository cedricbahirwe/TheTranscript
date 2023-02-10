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
    @State private var showScannerSheet = false
    @State private var showNoMatchFound = false
    @State private var isStudentCardValid = false

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
                        TextField("", text: $studentID.onChange(cleanEnteredID))
                        .keyboardType(.numberPad)
                        .font(.body.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 1.5)
                        )

                        if isStudentIDValid() {
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
                        Image(systemName: isStudentCardValid ? "checkmark" : "camera")
                            .padding(isStudentCardValid ? 8 : 16)
                            .foregroundColor(.white)
                            .background(isStudentCardValid ? Color.green : .accentColor)
                            .clipShape(Circle())
                    }
                }

                Button(action: completeVerification) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.green)
                        Text("Complete").bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background((isStudentIDValid() && isStudentCardValid) ? Color.accentColor : Color.gray)
                    .clipShape(Capsule())
                }
                .disabled(!(isStudentIDValid() && isStudentCardValid))

            }
            .frame(maxWidth: CGFloat.infinity > 500 ? 400 : .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $showNoMatchFound) {
            Alert(title: Text("Student Card Validation"),
                  message: Text("No match was found.\nPlease make sure to enter a valid Student ID and the Student Card should be clear and visible."),
                  dismissButton: .default(Text("Okay"))
            )
        }
        .sheet(isPresented: $showScannerSheet) {
            makeScannerView()
                .edgesIgnoringSafeArea(.all)
        }
    }

}

// MARK: - Views
private extension AuthenticationView {

    /// Scanner Component used for Computer Vision Scann
    /// - Returns: the view to use for scanning
    func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            self.showScannerSheet = false
            DispatchQueue.main.async {
                if let scannedText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.isStudentCardValid = appSession.validateStudentCardScan(scannedText, studentID)
                    if self.isStudentCardValid == false {
                        self.showNoMatchFound = true
                    }
                }
            }
        })
    }
}

// MARK: - Private Methods
private extension AuthenticationView {

    /// Grant access if the validations have succeed
    func completeVerification() {
        guard isStudentIDValid() else { return }
        guard let studentID = Int(studentID) else { return }
        appSession.setLogginState(true, studentID)
    }

    /// Open the camera to the scanning process
    func openCamera() {
        hideKeyboard()
        showScannerSheet = true
    }

    /// Clean the `StudentID` entered
    /// - Parameter id: the id value provided by the user
    func cleanEnteredID(_ id: String) {
        let lettersRemoved = id.components(separatedBy: CharacterSet.letters).joined()
        let spacesRemoved = lettersRemoved.components(separatedBy: .whitespacesAndNewlines).joined()
        let symbolsRemoved = spacesRemoved.components(separatedBy: .symbols).joined()

        self.studentID = String(symbolsRemoved.prefix(5))
    }


    /// Validate whether the `StudentID` follow the correct format
    /// - Returns: return whether the id is valid or not
    func isStudentIDValid() -> Bool {
        guard studentID.count == 5 else { return false }
        return Int(studentID) != nil
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
