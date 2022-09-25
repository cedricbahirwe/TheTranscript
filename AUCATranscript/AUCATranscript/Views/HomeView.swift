//
//  HomeView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var userMode: AppMode = .normal
    @State private var enteredID = ""
    @State private var isPresentingShareSheet = false


    private var titleView: some View {
        Text("AUCA Transcript")
            .font(.system(size: 40, weight: .black, design: .rounded))
    }
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
                    .background(
                        Color.white.opacity(0.1)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(16)
                    )

                ZStack {

                    Group {
                        if let pdfData = appSession.pdfData {
                            PDFViewer(pdfData, singlePage: false)
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
                    .opacity(appSession.pdfData == nil || userMode == .search ? 0 : 1)
                    //                    .animation(.easeInOut, value: userMode)
                    VStack {
                        HStack {
                            TextField("Enter your friend's student ID",
                                      text: $enteredID.onChange(handleNewID))
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
                        .background(Color.white.opacity(0.3))
                        .clipShape(Capsule())
                        .animation(.easeInOut, value: enteredID)

                        Text("It should be a 5 digits number")
                            .italic()
                    }
                    .opacity(userMode == .search ? 1 : 0)
                    .animation(.easeInOut, value: userMode)
                    .padding(16)
                }
                .frame(maxHeight: .infinity)

                Button(action: handleModeChange) {
                    Group {
                        switch userMode {
                        case .search:
                            HStack {
                                Image(systemName: "house")
                                Text("Go Home")
                            }
                        case .normal:
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search transcript for friend")
                            }
                        }
                    }
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                }
            }

            progressView
        }
        .foregroundColor(.white)
        .alert(item: $appSession.alert) { alert in
            Alert(title: Text(alert.title),
                  message: Text(alert.message),
                  dismissButton: .default(Text("Okay!"),
                                          action: handleOkayAction)
            )
        }
        .shareSheet(isPresented: $isPresentingShareSheet, items: [appSession.pdfData ?? []])
        .onAppear {
            Task {
                await loadTranscript()
            }
        }
    }

    private func handleOkayAction() {

    }

    private func loadTranscript() async {
        switch userMode {
        case .normal:
            await appSession.loadMyTranscript()
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
        userMode.toggle()
    }

    private func findTranscript() {
        hideKeyboard()

        Task {
            await loadTranscript()
            userMode = .normal
            enteredID = ""
        }
    }

    private func handleNewID(_ id: String) {

    }

    private var progressView: some View {
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
}

extension HomeView {
    enum AppMode {
        case normal
        case search
        mutating func toggle()  {
            self = self == .normal ? .search : .normal
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
