//
//  AppSessionManager.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import Foundation
import Combine
import PDFKit
import SwiftUI

final class AppSession: ObservableObject {
    public static let shared = AppSession()

    private let baseURL = "http://154.68.94.26/Rapport/"
    @Published private(set) var isFetchingData = false
    @Published private(set) var isLoggedIn: Bool
    @Published private(set) var pdfData: Data?
    private var sessionID: Int?
    private var sessionDate: Date?

    @Published public var alert: AlertModel?
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        self.sessionID = UserDefaults.standard.integer(forKey: Keys.sessionID)
        self.sessionDate = UserDefaults.standard.value(forKey: Keys.sessionDate) as? Date
    }

    private func getFullURL(_ studentId: Int) -> URL? {
        let urlString = baseURL.appending(String(studentId)).appending(".pdf")
        return URL(string: urlString)
    }

    public func loadTranscript(_ studentId: Int) async {
        guard let url = getFullURL(studentId) else { return }
        DispatchQueue.main.async {
            self.isFetchingData = true
        }
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.isFetchingData = false
                self.pdfData = data
            }
        } catch {
            DispatchQueue.main.async {
                self.isFetchingData = false
                self.pdfData = nil
                self.alert = AlertModel(message: "Sorry, We could not find the transcript for the provided student ID.\n Try another student ID")
            }
            print(error.localizedDescription)
        }
    }
}

// MARK: - AppSession User State
extension AppSession {
    public func setLogginState(_ state: Bool, _ studentId: Int) {
        let newDate = Date()
        UserDefaults.standard.set(state, forKey: Keys.isLoggedIn)
        UserDefaults.standard.set(studentId, forKey: Keys.sessionID)
        UserDefaults.standard.set(newDate, forKey: Keys.sessionDate)
        setStates(state, studentId, newDate)
    }

    public func clearSession() {
        UserDefaults.standard.set(false, forKey: Keys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: Keys.sessionID)
        UserDefaults.standard.removeObject(forKey: Keys.sessionDate)
        setStates(false, nil, nil)
    }

    private func setStates(_ loggedIn: Bool, _ studentId: Int?, _ sessionDate: Date?) {
        self.isLoggedIn = loggedIn
        self.sessionID = studentId
        self.sessionDate = sessionDate
    }

    public func isPresentingLogin() -> Binding<Bool> {
        Binding(get: {
            self.isLoggedIn == false
        }, set: { newValue in
            DispatchQueue.main.async {
                self.isLoggedIn = !newValue
            }
        })
    }
}

// MARK: - Local Keys
extension AppSession {
    enum Keys {
        static let isLoggedIn =  "app.session.isLoggedIn"
        static let sessionID =  "app.session.sessionID"
        static let sessionDate =  "app.session.sessionDate"
    }
}
