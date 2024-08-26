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
                    Text("About")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding(.bottom)

                    Text("The purpose of this application is to allow AUCA (Adventist University of Central Africa) students access their transcripts quickly and easily.\n\nEasing the process to check  their semesters grades anytime, anywhere.\n\nThe transcript is shown as a PDF file with the ability to share it with others or save it for later use.")

                    Text("\nFor privacy and security reasons, Your information is always kept on your device.\n")
                        .foregroundColor(.green)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your session will expire after 1 week of inactivity.")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.accentColor)

                        Text("This means you will have to enter your Student ID and Password again to check your transcript.")
                            .foregroundColor(.secondary)

                        Divider()
                        
                        HStack {
                            Text("You can manually delete your session now.")
                                .opacity(0.8)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                appSession.clearSession()
                            }) {
                                Text("Delete Now")
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
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(15)
                    .foregroundColor(.black)

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                            .font(.system(.body, design: .rounded))
                            .bold()
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                    .padding(.vertical)
                }
                .foregroundColor(.white)
                .padding(20)
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
