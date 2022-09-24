//
//  MainBackgroundView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct MainBackgroundView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Image("auca.logo")
                .blur(radius:10)

            Color.black.opacity(0.3)
        }
    }
}

struct MainBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MainBackgroundView()
    }
}
