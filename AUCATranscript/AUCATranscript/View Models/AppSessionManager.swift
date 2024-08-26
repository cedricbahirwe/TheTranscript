//
//  AppSessionManager.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import SwiftUI

/// Due to some legal reasons,  the app has been left with no path forward.
final class AppSession: ObservableObject {
    public static let shared = AppSession()

    /// The  functional base url has been removed and disabled due to legal reasons
    /// This is just a placeholder and won't work unfortunately ‼️
    private let baseURL = URL(string: "https://auca-transcript-be-production-9b93.up.railway.app/get-transcript/")! // The base url for accessing the data source

    private var credentials: StudentCredentials?
    private var sessionCookie: String?
    private var sessionDate: Date?
    private var transcriptData: Data?
    private let storage = UserDefaults.standard

    @Published private(set) var isFetchingData = false
    @Published private(set) var isLoggedIn: Bool
    @Published private(set) var pdfData: Data?

    @Published public var alert: AlertModel?

    init() {
        self.isLoggedIn = storage.bool(forKey: Keys.isLoggedIn)
        self.credentials = storage.decode(forKey: Keys.studentCredentials)
        self.sessionCookie = storage.string(forKey: Keys.sessionCookie)
        self.sessionDate = storage.value(forKey: Keys.sessionDate) as? Date
        self.transcriptData = storage.data(forKey: Keys.transcriptData)

        Task {
            guard let credentials else { return }
            await loadTranscript(credentials)
        }
    }

    @MainActor
    @discardableResult
    func loadTranscript(_ credentials: StudentCredentials) async -> Bool {
        // Check if the transcript is already stored
        if let transcriptData {
            self.pdfData = transcriptData
            return true
        }

        var request = URLRequest(url: baseURL)
        
        let encoded = try! JSONEncoder().encode(credentials)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")            

        DispatchQueue.main.async {
            self.isFetchingData = true
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    // Successful response
                    DispatchQueue.main.async {
                        self.isFetchingData = false
                        self.saveTranscript(data)
                        self.pdfData = data
                    }
                    return true
                case 401:
                    // Handle unauthorized error specifically
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        showAlert(message: "\(errorResponse.detail.message)\n\(errorResponse.detail.hint)")
                    } else {
                        showAlert(message: "Unauthorized access. Please check your credentials.")
                    }
                    return false
                default:
                    showAlert(message: "An error occurred (Status code: \(httpResponse.statusCode)). Please try again.")
                    print("Unexpected status code: \(httpResponse.statusCode)")
                    return false
                }
            } else {
                showAlert(message: "An unexpected error occurred. Please try again.")
                return false
            }
        } catch {
            showAlert(message: "Sorry, We could not find the transcript for the provided credentials.")
            return false
        }
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            self.isFetchingData = false
            self.pdfData = nil
            self.transcriptData = nil
            self.alert = AlertModel(message:  message)
        }
    }
}

// MARK: - AppSession User State
extension AppSession {
    func validateStudentCardScan(_ scannedText: String, _ studentID: String) -> Bool {
        scannedText.contains(studentID)
    }
    
    func loginWith(credentials: StudentCredentials) {
        Task { @MainActor in
            guard await loadTranscript(credentials) else { return }
            setLogginState(true, credentials)
        }
    }

    func setLogginState(_ state: Bool, _ credentials: StudentCredentials) {
        let newDate = Date()
        UserDefaults.standard.set(state, forKey: Keys.isLoggedIn)
        UserDefaults.standard.encode(credentials, forKey: Keys.studentCredentials)
        UserDefaults.standard.set(newDate, forKey: Keys.sessionDate)
        setStates(loggedIn: state, credentials: credentials, sessionDate: newDate, transcriptData: nil, sessionCookie: nil)
    }

    func clearSession() {
        self.pdfData = nil
        UserDefaults.standard.set(false, forKey: Keys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: Keys.studentCredentials)
        UserDefaults.standard.removeObject(forKey: Keys.sessionCookie)
        UserDefaults.standard.removeObject(forKey: Keys.sessionDate)
        UserDefaults.standard.removeObject(forKey: Keys.transcriptData)
        setStates(loggedIn: false, credentials: nil, sessionDate: nil, transcriptData: nil, sessionCookie: nil)
    }

    func isPresentingLoginSheet() -> Binding<Bool> {
        Binding(get: {
            self.isLoggedIn == false
        }, set: { newValue in
            DispatchQueue.main.async {
                self.isLoggedIn = !newValue
            }
        })
    }
}


// MARK: - Private Methods
private extension AppSession {
    func saveTranscript(_ data: Data) {
        print("Counting", data.count / 1024)
        UserDefaults.standard.set(data, forKey: Keys.transcriptData)
        self.transcriptData = data
    }

    func removeTranscript() {
        UserDefaults.standard.set(nil, forKey: Keys.transcriptData)
        self.transcriptData = nil
    }

    func setStates(loggedIn: Bool, credentials: StudentCredentials?, sessionDate: Date?, transcriptData: Data?, sessionCookie: String?) {
        self.isLoggedIn = loggedIn
        self.credentials = credentials
        self.sessionDate = sessionDate
        self.transcriptData = transcriptData
        self.sessionCookie = sessionCookie
    }
}

// MARK: - Local Keys
extension AppSession {
    enum Keys {
        static let isLoggedIn =  "app.session.isLoggedIn"
        static let studentCredentials = "app.session.credentials"
        static let sessionCookie = "app.session.sessionCookie"
        static let sessionDate =  "app.session.sessionDate"
        static let transcriptData =  "app.session.transcriptData"
    }
}

extension UserDefaults {
    func decode<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func encode<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        self.setValue(data, forKey: key)

    }
}
