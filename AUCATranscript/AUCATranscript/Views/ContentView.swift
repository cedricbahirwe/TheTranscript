//
//  ContentView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool
    var body: some View {
        if isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: false)
    }
}
