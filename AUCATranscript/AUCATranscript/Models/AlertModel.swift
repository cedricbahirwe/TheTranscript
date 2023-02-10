//
//  AlertModel.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 25/09/2022.
//

import Foundation

struct AlertModel: Identifiable {
    let id = UUID()
    var title: String = "Alert"
    let message: String
}
