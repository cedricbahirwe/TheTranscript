//
//  ContentView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appSession: AppSession
    var body: some View {
        ZStack {
            if #available(iOS 14.0, *) {
                homeView
                    .fullScreenCover(isPresented: appSession.isPresentingLoginSheet()) {
                        AuthenticationView()
                    }
            } else {
                ZStack {
                    homeView
                    if !appSession.isLoggedIn {
                        AuthenticationView()
                    }
                }
            }
        }
        .environmentObject(appSession)
    }

    private var homeView: some View {
        HomeView()
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppSession.shared)
    }
}
