//
//  ContentViewModel.swift
//  Camera
//
//  Created by Khayrul on 2/11/22.
//

import Foundation

import CoreImage
import VideoToolbox
import UIKit

class ContentViewModel: ObservableObject {
  
  @Published var frame: CGImage?
        
  
  private let frameManager = FrameManager.shared

  init() {
    setupSubscriptions()
  }
  
  func setupSubscriptions() {
    // 1
    frameManager.$current
      // 2
      .receive(on: RunLoop.main)
      // 3
      .compactMap { buffer in
          guard let buffer = buffer else {
              return nil
          }
          return UIImage(pixelBuffer: buffer)?.cgImage

      }
      // 4
      .assign(to: &$frame)

  }
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}
