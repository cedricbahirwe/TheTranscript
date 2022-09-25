//
//  PDFViewer.swift
//  AUCATranscript
//
//  Created by Cédric Bahirwe on 24/09/2022.
//

import PDFKit
import SwiftUI

struct PDFViewer: UIViewRepresentable {
    let data: Data

    init(_ data: Data) {
        self.data = data
    }
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(data: data)
    }
}
