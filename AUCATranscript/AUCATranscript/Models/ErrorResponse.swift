//
//  ErrorResponse.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 26/08/2024.
//

import Foundation

struct ErrorResponse: Decodable {
    let detail: ErrorDetail
    
    struct ErrorDetail: Decodable {
        let message: String
        let hint: String
        let status_code: Int
    }
}
