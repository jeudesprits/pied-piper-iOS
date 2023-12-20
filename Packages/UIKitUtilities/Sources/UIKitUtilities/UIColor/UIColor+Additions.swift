//
//  UIColor+Additions.swift
//
//
//  Created by Ruslan Lutfullin on 5/2/21.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

extension UIColor {
	
	public var rgbaComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
		var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
		precondition(getRed(&red, green: &green, blue: &blue, alpha: &alpha), "Color is not in a compatible color space")
		return (red, green, blue, alpha)
	}
	
	public var hsbaComponents: (hue: Double, saturation: Double, brightness: Double, alpha: Double) {
		var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
		precondition(getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha), "Color is not in a compatible color space")
		return (hue, saturation, brightness, alpha)
	}
	
	public var waComponents: (white: Double, alpha: Double) {
		var white: CGFloat = 0.0, alpha: CGFloat = 0.0
		precondition(getWhite(&white, alpha: &alpha), "Color is not in a compatible color space")
		return (white, alpha)
	}
}

extension UIColor {
	
	public var luminance: Double {
		func getLumaComponent(forBaseComponent component: Double) -> CGFloat {
			component <= 0.03928 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
		}
		
		let rgbaComponents = self.rgbaComponents
		
		return 0.2126 * getLumaComponent(forBaseComponent: rgbaComponents.red) +
			0.7152 * getLumaComponent(forBaseComponent: rgbaComponents.green) +
			0.0722 * getLumaComponent(forBaseComponent: rgbaComponents.blue)
	}
	
	public var isDark: Bool { luminance < 0.5 }
	
	public var isLight: Bool { !isDark }
	
	public func isDarker(then color: UIColor) -> Bool {
		return luminance < color.luminance
	}
	
	public func isLighter(then color: UIColor) -> Bool {
		return !isDarker(then: color)
	}
}

extension UIColor {
	
	public func contrastRatio(with color: UIColor) -> CGFloat {
		let lhs = luminance
		let rhs = color.luminance
		return lhs < rhs ? (rhs + 0.05) / (lhs + 0.05) : (lhs + 0.05) / (rhs + 0.05)
	}
	
	public func isContrasting(with color: UIColor, strict: Bool = false) -> Bool {
		let contrastRatio = self.contrastRatio(with: color)
		return strict ? (7.0 <= contrastRatio) : (4.5 < contrastRatio)
	}
}

extension UIColor {
	
	public func blended(with color: UIColor, compositeFilter: some CICompositeOperation) -> UIColor {
        let (inputColor, backgroundColor) = (CIColor(cgColor: cgColor), CIColor(cgColor: color.cgColor))
		compositeFilter.inputImage = CIImage(color: inputColor)
		compositeFilter.backgroundImage = CIImage(color: backgroundColor)
		
		var bitmap = Array<UInt8>(repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: NSNull(), .outputColorSpace: NSNull()])
		context.render(
			compositeFilter.outputImage!,
			toBitmap: &bitmap,
			rowBytes: 4,
			bounds: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0),
            format: .RGBA8, // should be the same as CIFormat.RGBA8.rawValue, (rawValue: 264)
			colorSpace: nil
		)
		
		return UIColor(
			red:   CGFloat(bitmap[0]) / 255.0,
			green: CGFloat(bitmap[1]) / 255.0,
			blue:  CGFloat(bitmap[2]) / 255.0,
			alpha: CGFloat(bitmap[3]) / 255.0
		)
	}
}

extension UIColor {
	
	public func lighted(by percentage: Double = 0.3) -> UIColor {
		precondition(0.0...1.0 ~= percentage)
		return adjustBrightness(by: percentage)
	}
	
	public func darked(by percentage: Double = 0.3) -> UIColor {
		precondition(0.0...1.0 ~= percentage)
		return adjustBrightness(by: -percentage)
	}
	
	private func adjustBrightness(by percentage: Double = 0.3) -> UIColor {
		precondition(0.0...1.0 ~= percentage)
		
		var alpha: CGFloat = 0.0
		
		var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
		if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
			let newRed = min(max(red + percentage * red, 0.0), 1.0)
			let newGreen = min(max(green + percentage * green, 0.0), 1.0)
			let newBlue = min(max(blue + percentage * blue, 0.0), 1.0)
			return .init(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
		}
		
		var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
		if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
			let newBrightness = max(min(brightness + percentage * brightness, 1.0), 0.0)
			return .init(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
		}
		
		var white: CGFloat = 0.0
		if getWhite(&white, alpha: &alpha) {
			let newWhite = white + percentage * white
			return .init(white: newWhite, alpha: alpha)
		}
		
		preconditionFailure("Color is not in a compatible color space")
	}
}

extension UIColor {
	
	public var dimmed: UIColor {
		let (red, green, blue, alpha) = rgbaComponents
		let redCoefficient: CGFloat = 0.2126, greenCoefficient: CGFloat = 0.7152, blueCoefficient: CGFloat = 0.0722
		return .init(red: redCoefficient * red, green: greenCoefficient * green, blue: blueCoefficient * blue, alpha: alpha)
	}
}
