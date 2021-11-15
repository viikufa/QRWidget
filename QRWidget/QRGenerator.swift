//
//  QRGenerator.swift
//  QRWidget
//
//  Created by Vitaliy on 15.11.2021.
//

import UIKit
import CoreImage.CIFilterBuiltins

struct QRGenerator {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    func generate(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.correctionLevel = "Q"
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledQrImage = outputImage.transformed(by: transform)
            if let cgimg = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
