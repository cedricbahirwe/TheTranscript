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
    @Published private(set) var isFetchingData = false
    @Published private(set) var pdfData: Data?
    @Published public var alert: AlertModel?

    private var cancellables = Set<AnyCancellable>()

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
