import PlaygroundSupport
import UIKit
import UIKitUtilities
import Accelerate.vImage
@testable
import PiedPiperHomeUI

let uiimage = UIImage(named: "unnamed", in: .module)!
let cgImage = uiimage.cgImage!
let inputImage = CIImage(cgImage: cgImage)
let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!

var pixelBuffer1 = vImage.PixelBuffer<vImage.InterleavedFx4>(width: 1, height: 1)
var pixelBuffer2 = vImage.PixelBuffer<vImage.InterleavedFx4>(width: 4, height: 1)

do {
    let ciContext = CIContext(options: [
        .workingColorSpace: NSNull(),
        .outputColorSpace: NSNull(),
        .useSoftwareRenderer: false,
        .cacheIntermediates: false,
        .allowLowPower: false,
        .priorityRequestLow: false,
    ])
    let filter = CIFilter.areaAverage()
    filter.inputImage = inputImage
    filter.extent = inputImage.extent
    let outputImage = filter.outputImage!
    
    var pixelBuffer = vImage.PixelBuffer<vImage.Interleaved8x4>(width: 1, height: 1)
    pixelBuffer.withUnsafeMutableBufferPointer {
        ciContext.render(outputImage, toBitmap: $0.baseAddress!, rowBytes: 4, bounds: outputImage.extent, format: .RGBA8, colorSpace: nil)
    }
    pixelBuffer.convert(to: pixelBuffer1)
}

do {
    let ciContext = CIContext(options: [
        .workingColorSpace: NSNull(),
        .outputColorSpace: NSNull(),
        .useSoftwareRenderer: false,
        .cacheIntermediates: false,
        .allowLowPower: false,
        .priorityRequestLow: false,
    ])
    let filter = CIFilter.kMeans()
    filter.inputImage = inputImage
    filter.extent = inputImage.extent
    filter.passes = 10
    filter.count = 4
    filter.perceptual = true
    let outputImage = filter.outputImage!
    
    var pixelBuffer = vImage.PixelBuffer<vImage.Interleaved8x4>(width: 4, height: 1)
    pixelBuffer.withUnsafeMutableBufferPointer {
        ciContext.render(outputImage, toBitmap: $0.baseAddress!, rowBytes: 16, bounds: outputImage.extent, format: .RGBA8, colorSpace: colorSpace)
    }
    pixelBuffer.convert(to: pixelBuffer2)
}
pixelBuffer2.array
let color1 = pixelBuffer1.withUnsafeMutableBufferPointer {
    CGColor(colorSpace: colorSpace, components: $0.map { CGFloat($0) })
}

let color2 = pixelBuffer2.withUnsafeBufferPointer {
    CGColor(colorSpace: colorSpace, components: $0.map { CGFloat($0) })
}

color1
color2

PlaygroundPage.current.finishExecution()
