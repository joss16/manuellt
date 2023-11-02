//
//  DoModel.swift
//  basicML
//
//  Created by BillU on 2023-09-18.
//

import Vision
import Foundation
import UIKit

class DoModel {
    
    // Lägg till en completion handler som en parameter
    func doImage(with imageName: String, completion: @escaping (String, String) -> Void) {
        let defaultConfig = MLModelConfiguration()
        let imageClassifierWrapper = try? MobileNet(configuration: defaultConfig)
        
        guard let theimage = UIImage(named: imageName),
              let theimageBuffer = buffer(from: theimage) else {
            print("Kunde inte ladda eller konvertera bilden.")
            return
        }
        
        do {
            let output = try imageClassifierWrapper!.prediction(image: theimageBuffer)
            let label = output.classLabel
            let probability = String(format: "%.2f", output.classLabelProbs[label] ?? 0)
            completion(label, probability)
        } catch {
            print("Fel vid bildanalys: \(error)")
        }
    }

    }

    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }

        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }


