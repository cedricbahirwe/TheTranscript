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
        HomeView()
            .preferredColorScheme(.light)
            .fullScreenCover(isPresented: appSession.isPresentingLoginSheet()) {
                AuthenticationView()
            }
            .environmentObject(appSession)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppSession.shared)
    }
}
