//
//  AlertModel.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 25/09/2022.
//

import Foundation

struct AlertModel: Identifiable {
    var id = UUID()
    var title: String = "Alert"
    var message: String
}
