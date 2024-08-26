//
//  StudentCredentials.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 26/08/2024.
//

import Foundation

struct StudentCredentials: Codable {
    var username = ""
    var password = ""
    
    /// Validate whether the `StudentID` follow the correct format
    /// - Returns: return whether the id is valid or not
    func isValid() -> Bool {
        let isUserNameValid = !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isPasswordValid = !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return isUserNameValid && isPasswordValid
    }
}
