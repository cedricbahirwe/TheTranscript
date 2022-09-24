//
//  AppSessionManager.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import Foundation

final class AppSession: ObservableObject {
    public static let shared = AppSession()
    private let storage: UserDefaults
    @Published private(set) var sessionUser: UserModel?

    public var isLoggedIn: Bool {
        sessionUser != nil
    }

    init() {
        storage = UserDefaults.standard
        self.sessionUser = getUser()
    }

    // MARK: - Network
    func loadTranscript() {

    }
}

// MARK: - Authentication
extension AppSession {
    func saveUser(_ user: UserModel) {
        guard let encodeData = try? JSONEncoder().encode(user) else { return }
        storage.set(encodeData, forKey: AppSession.Keys.user)
        self.sessionUser = user
    }

    func getUser() -> UserModel? {
        guard let userData = storage.data(forKey: AppSession.Keys.user) else { return  nil}

        do {
            let user = try JSONDecoder().decode(UserModel.self, from: userData)
            sessionUser = user
            return sessionUser
        } catch {
            print("Unable to decode", error.localizedDescription)
            return nil
        }
    }
}

// MARK: - Local Keys
extension AppSession {
    enum Keys {
        static let user = "app.session.user"
    }
}
