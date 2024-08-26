//
//  HomeView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var showShareSheet = false
    @State private var showSettingsView = false

    var body: some View {
        ZStack {
            MainBackgroundView(color: .white)
            
            VStack(spacing: 0) {
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

                ZStack {

                    Group {
                        if let pdfData = appSession.pdfData, false {
                            PDFViewer(pdfData)
                                .overlay(HStack {
                                    settingsBtn
                                    Spacer()
                                    shareBtn
                                }, alignment: .bottom)
                        } else {
                            Text("No Transcript to show yet😰")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(.darkGray))

                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }

            progressView
        }
        .foregroundColor(.white)
        .sheet(isPresented: $showSettingsView, content: SettingsView.init)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [appSession.pdfData ?? []])
        }
    }
}

// MARK: - Helper Methods
private extension HomeView {

    private func sharePDF() {
        guard let _ = appSession.pdfData else {
            return
        }
        showShareSheet.toggle()
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
                ActivityIndicatorView()
            }
        }
    }

    var settingsBtn: some View {
        Button {
            showSettingsView.toggle()
        } label: {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.accentColor)
                .clipShape(Circle())
        }
            .padding()
    }

    var shareBtn: some View {
        Image(systemName: "square.and.arrow.up")
            .foregroundColor(.white)
            .padding(10)
            .background(Color.accentColor)
            .clipShape(Circle())
            .onTapGesture(perform: sharePDF)
            .padding(12)
    }
}


#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppSession.shared)
//            .previewDevice("iPad Pro (12.9-inch) (3rd generation)")
    }
}
#endif
