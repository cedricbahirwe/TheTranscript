//
//  HomeView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var uiMode: UIMode = .search
    @State private var enteredID = ""
    @State private var isPresentingShareSheet = false
    @State private var showHelpView = false

    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack {
                titleView
                    .opacity(0)
                    .overlay (
                        Image("auca.home")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .mask(titleView)
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.white.opacity(0.1)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(16)
                    )
                    .clipShape(Capsule())
                    .padding()

                ZStack {

                    Group {
                        if let pdfData = appSession.pdfData {
                            PDFViewer(pdfData)
                                .overlay (
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.accentColor)
                                        .clipShape(Circle())
                                        .onTapGesture(perform: sharePDF)
                                        .padding(12)
                                    , alignment: .topTrailing
                                )
                        }
                    }
                    .opacity(appSession.pdfData == nil || uiMode == .search ? 0 : 1)

                    VStack {
                        HStack {
                            TextField("Enter your friend's student ID",
                                      text: $enteredID.onChange(cleanEnteredID))
                            .colorMultiply(enteredID.isEmpty ? .gray : .white)
                            .colorMultiply(enteredID.isEmpty ? .gray : .white)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .frame(minWidth: 100)
                            .font(.system(size: enteredID.isEmpty ? 16 : 40,
                                          weight: .black,
                                          design: .rounded))

                            Button(action: findTranscript) {
                                Image(systemName: "magnifyingglass")
                                    .padding()
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(height: 50)
                        .background(Color.white.opacity(0.3))
                        .clipShape(Capsule())
                        .animation(.easeInOut, value: enteredID)

                        Text("It should be a 5 digits number")
                            .italic()
                    }
                    .opacity(uiMode == .search ? 1 : 0)
                    .animation(.easeInOut, value: uiMode)
                    .padding(16)
                }
                .frame(maxHeight: .infinity)

                bottomBarView
                    .padding(.horizontal)
            }

            progressView
        }
        .foregroundColor(.white)
        .alert(item: $appSession.alert) { alert in
            Alert(title: Text(alert.title),
                  message: Text(alert.message),
                  dismissButton: .default(Text("Okay"),
                                          action: handleOkayAction)
            )
        }
        .sheet(isPresented: $showHelpView, content: HelpView.init)
        .shareSheet(isPresented: $isPresentingShareSheet, items: [appSession.pdfData ?? []])
    }
}

// MARK: - Functions
private extension HomeView {
    private func handleOkayAction() {}

    private func loadTranscript() async {
        switch uiMode {
        case .display:
            break;
        case .search:
            guard enteredID.count == 5,
                  let otherId = Int(enteredID) else { return }

            await appSession.loadTranscript(otherId)
        }
    }

    private func sharePDF() {
        guard let _ = appSession.pdfData else {
            return
        }
        isPresentingShareSheet.toggle()
    }

    private func handleModeChange() {
        hideKeyboard()
        uiMode.toggle()
    }

    private func findTranscript() {
        guard enteredID.count == 5,
              let _ = Int(enteredID) else { return }
        hideKeyboard()

        Task {
            await loadTranscript()
            uiMode = .display
            enteredID = ""
        }
    }

    private func cleanEnteredID(_ id: String) {
        let lettersRemoved = id.components(separatedBy: CharacterSet.letters).joined()
        let spacesRemoved = lettersRemoved.components(separatedBy: .whitespacesAndNewlines).joined()
        let symbolsRemoved = spacesRemoved.components(separatedBy: .symbols).joined()

        self.enteredID = String(symbolsRemoved.prefix(5))
    }
}

// MARK: - Views
private extension HomeView {
    var titleView: some View {
        Text("AUCA Transcript")
            .font(.system(size: 38, weight: .black, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.9)
    }

    var progressView: some View {
        Group {
            if appSession.isFetchingData {
                ZStack {
                    Color.black

                    VStack(spacing: 15) {
                        if #available(iOS 14.0, *) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        } else {
                            ActivityIndicator()
                        }
                        Text("Wait a moment...")
                    }
                }
            }
        }
    }

    var bottomBarView: some View {
        HStack {

            Button("Help") {
                showHelpView.toggle()
            }
            .padding()
            .foregroundColor(.accentColor)
            Spacer()
            Button(action: handleModeChange) {
                let isSearch = uiMode == .search
                HStack {
                    Image(systemName: isSearch ? "house" : "magnifyingglass")
                    Text(isSearch ? "Go Home" : "Search for a transcript")
                }
                .padding()
                .background(Color.accentColor)
                .clipShape(Capsule())
            }

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Models
extension HomeView {
    enum UIMode {
        case display
        case search
        mutating func toggle()  {
            self = self == .display ? .search : .display
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppSession.shared)
    }
}
#endif
