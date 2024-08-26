//
//  ActivityIndicatorView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 26/08/2024.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
                Text("Wait a moment...")
                    .foregroundColor(.black)
            }
        }
    }
}
