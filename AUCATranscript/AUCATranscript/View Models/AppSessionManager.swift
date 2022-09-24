//
//  AppSessionManager.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import Foundation
import Combine
import PDFKit

final class AppSession: ObservableObject {
    public static let shared = AppSession()
    private let baseURL = "http://154.68.94.26/Rapport/"
    private let storage: UserDefaults
    @Published private(set) var sessionUser: UserModel?
    @Published private(set) var isFetchingData = false
    @Published private(set) var pdfData: Data?

    private var cancellables = Set<AnyCancellable>()

    public var isLoggedIn: Bool {
        sessionUser != nil
    }

    init() {
        storage = UserDefaults.standard
        self.sessionUser = getUser()
    }

    private func getFullURL(_ studentId: Int) -> URL? {
        let urlString = baseURL.appending(String(studentId)).appending(".pdf")
        return URL(string: urlString)
    }

    // MARK: - Networking
    func loadMyTranscript() async {
        guard let myID = sessionUser?.userID else { return }
        return await loadTranscript(myID)
    }

    func loadTranscript(_ studentId: Int) async {
        guard let url = getFullURL(studentId) else { return }
        DispatchQueue.main.async {
            self.isFetchingData = true
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            DispatchQueue.main.async {
                self.pdfData = data
                self.isFetchingData = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isFetchingData = false
            }
            print(error.localizedDescription)
        }
    }

    func removePDFData() {
        pdfData = nil
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
