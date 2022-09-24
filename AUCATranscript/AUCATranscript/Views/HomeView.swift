//
//  HomeView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

enum AppMode {
    case normal
    case search
    mutating func toggle()  {
        self = self == .normal ? .search : .normal
    }
}
struct HomeView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var userMode: AppMode = .normal
    @State private var enteredID = ""

    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack {
                Image("gradient1")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .rotationEffect(.degrees(-180))
                    .offset(x: 35)
                    .mask(
                        Text("AUCA Transcript")
                            .font(.system(size: 35, weight: .black, design: .rounded))
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
                        }
                    }
                    .opacity(appSession.pdfData == nil ? 0 : 1)
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
                            Text("Go Home")
                        case .normal:
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search transcript a friend")
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
        .onAppear {
            Task {
                await loadTranscript()
            }
        }
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

    private func handleModeChange() {
        hideKeyboard()
        userMode.toggle()
        appSession.removePDFData()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppSession.shared)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
