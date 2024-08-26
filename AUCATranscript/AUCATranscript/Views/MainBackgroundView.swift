//
//  MainBackgroundView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

struct MainBackgroundView: View {
    var color: Color = .black
    var body: some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            Image("auca.logo")
                .blur(radius:10)

            color.opacity(0.3)
        }
    }
}

struct MainBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MainBackgroundView()
    }
}
