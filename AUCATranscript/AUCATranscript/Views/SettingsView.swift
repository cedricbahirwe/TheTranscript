//
//  SettingsView.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 03/10/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var appSession: AppSession
    
    var body: some View {
        ZStack {
            MainBackgroundView()

            ScrollView {
                VStack(alignment: .leading) {
                    Text("Help")
                        .font(.largeTitle.weight(.bold))
                        .padding(.vertical)

                    Text("The purpose of this application is to allow AUCA (Adventist University of Central Africa) students access their transcripts quickly and easily.\n\nEasing the process to check  their semesters grades anytime, anywhere.\n\nThe transcript is shown as a PDF file with the ability to share it with others or save it for later use.")

                    Text("\n\nFor privacy and security reasons, All information is always kept on your device.")
                        .foregroundColor(.green)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your session will expire after 1 week of inactivity.")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.accentColor)

                        Text("This means you will have to enter your Student Card and ID again to check your transcript.")
                            .italic()

                        HStack {
                            Text("You can also delete your session now.")
                                .opacity(0.8)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                appSession.clearSession()
                            }) {
                                Text("Delete now")
                                    .font(.system(.body, design: .rounded))
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                            }
                        }

                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)


                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Return")
                            .font(.system(.body, design: .rounded))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
