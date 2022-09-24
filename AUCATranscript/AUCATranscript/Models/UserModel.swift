//
//  UserModel.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import Foundation

struct UserModel: Codable {
    init?(userID: Int, firstName: String, lastName: String, createdDate: Date = Date()) {
        guard String(userID).count == 5 else { return nil }
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.createdDate = createdDate
    }

    var userID: Int
    var firstName: String
    var lastName: String
    var createdDate: Date
}
