//
//  ImageVisionHelper.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/01/27
//  
//

import Foundation
import CoreImage
import Vision

struct SubjectLiftingHelper {
    
    private let ciContext: CIContext
    
    init() {
        self.ciContext = CIContext()
    }
    
    func render(ciImage img: CIImage) -> CGImage? {
        return ciContext.createCGImage(img, from: img.extent)
    }
    
    func doSubjectLifting(from image: CIImage, croppedToInstanceExtent: Bool) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Vision request execution failed: \(error.localizedDescription)")
            return nil
        }
        
        guard let result = request.results?.first else {
            print("No Subject Found")
            return nil
        }
        
        do {
            let mask = try result.generateMaskedImage(
                ofInstances: result.allInstances,
                from: handler,
                croppedToInstancesExtent: croppedToInstanceExtent
            )
            return CIImage(cvPixelBuffer: mask)
        } catch {
            print("Generation of mask image failed: \(error.localizedDescription)")
            return nil
        }
    }
    
}
