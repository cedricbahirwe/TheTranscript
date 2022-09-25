//
//  HelpView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 25/09/2022.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        ZStack {
            MainBackgroundView()

            VStack(alignment: .leading) {
                Text("Help")
                    .font(.largeTitle.weight(.bold))
                    .padding(.vertical)

                Text("The purpose of this application is to allow AUCA (Adventist University of Central Africa) students access their transcripts quickly and easily.\n\nEasing the process to check  their semesters grades anytime, anywhere.\n\nThe transcript is shown as a PDF file with the ability to share it with others or save it for later use.")

                Text("\n\nFor privacy and security reasons, All information is always kept on your device.")
                    .foregroundColor(.green)

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Return")
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
                .padding(.vertical)

            }
            .foregroundColor(.white)
            .padding(25)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
