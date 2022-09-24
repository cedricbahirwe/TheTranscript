//
//  HomeView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

enum UserMode {
    case `self`
    case other
    mutating func toggle()  {
        self = self == .`self` ? .other : .`self`
    }
}
struct HomeView: View {
    @State private var userMode: UserMode = .self
    @State private var enteredID = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            backgroundView
            Image("auca.logo")
                .blur(radius:10)
            //                .zIndex(10)
            Color.black.opacity(0.3)
                .zIndex(0)

            VStack {
                Image("gradient1")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .rotationEffect(.degrees(-180))
                    .offset(x: 50)
                    .mask(
                        Text("AUCA Transcript")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                    )
                    .background(
                        Color.white.opacity(0.1)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(16)
                    )

                
                VStack {

                    Group {
                        TextField("Enter your friend's student ID",
                                  text: $enteredID.onChange(handleNewID))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .font(.system(size: enteredID.isEmpty ? 20 : 40,
                                      weight: .black,
                                      design: .rounded))
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .animation(.easeInOut, value: enteredID)

                        Text("It should be a 5 digits number")
                            .italic()
                    }
                    .opacity(userMode == .`self` ? 0 : 1)
                    .animation(.easeInOut, value: userMode)

                    Group {
                        VStack {
                            // Transcript goes here
                            Text("Transcript")
                        }
                    }
                    .opacity(userMode == .other ? 0 : 1)
                    .animation(.easeInOut, value: userMode)

                }
                .padding(16)
                .frame(maxHeight: .infinity)


                Button(action: {
                    userMode.toggle()
                }, label: {
                    Group {
                        switch userMode {
                        case .other:
                            Text("Go Home")
                        case .`self`:
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search transcript a friend")
                            }
                        }
                    }
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                })
            }

            progressView
        }
        .foregroundColor(.white)
    }

    private var backgroundView: some View {
        Color.black.edgesIgnoringSafeArea(.all)
    }

    private func handleNewID(_ id: String) {

    }

    private var progressView: some View {
        Group {
            if isLoading {
                ZStack {
                    Color.black

                    VStack(spacing: 15) {
                        if #available(iOS 14.0, *) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        } else {
                            // Fallback on earlier versions
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
