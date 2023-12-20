//
//  UIFont+Additions.swift
//
//
//  Created by Ruslan Lutfullin on 3/2/21.
//

import UIKit

extension UIFont {
	
	// MARK: -
	
	public static func systemFont(forTextStyle style: TextStyle, weight: Weight? = nil, width: Width? = nil) -> UIFont {
		let preferredFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
		let size = preferredFontDescriptor.fontAttributes[.size] as! CGFloat
		if let width {
			return .systemFont(ofSize: size, weight: weight ?? .init(preferredFontDescriptor.weight), width: width)
		} else {
			return .systemFont(ofSize: size, weight: weight ?? .init(preferredFontDescriptor.weight))
		}
	}
	
	// MARK: -
	
	public static func monospacedSystemFont(forTextStyle style: TextStyle, weight: Weight? = nil) -> UIFont {
		let preferredDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
		let size = preferredDescriptor.fontAttributes[.size] as! CGFloat
		return .monospacedSystemFont(ofSize: size, weight: weight ?? .init(preferredDescriptor.weight))
	}
	
	// MARK: -
	
	public static func monospacedDigitSystemFont(forTextStyle style: TextStyle, weight: Weight? = nil) -> UIFont {
		let preferredDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
		let size = preferredDescriptor.fontAttributes[.size] as! CGFloat
		return .monospacedDigitSystemFont(ofSize: size, weight: weight ?? .init(preferredDescriptor.weight))
	}
	
	// MARK: -
	
	public static func roundedSystemFont(ofSize fontSize: CGFloat, weight: Weight) -> UIFont {
		guard let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor
			.withDesign(.rounded)
		else { preconditionFailure() }
		return .init(descriptor: descriptor, size: 0.0)
	}
	
	public static func roundedSystemFont(forTextStyle style: TextStyle, weight: Weight? = nil) -> UIFont {
		guard let preferredDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
			.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
			.withDesign(.rounded)
		else { preconditionFailure() }
		return .init(descriptor: preferredDescriptor, size: 0.0)
	}
	
	// MARK: -
	
	public static func serifSystemFont(ofSize fontSize: CGFloat, weight: Weight) -> UIFont {
		guard let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor
			.withDesign(.serif)
		else { preconditionFailure() }
		return .init(descriptor: descriptor, size: 0.0)
	}
	
	public static func serifSystemFont(forTextStyle style: TextStyle, weight: Weight? = nil) -> UIFont {
		guard let preferredDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
			.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
			.withDesign(.serif)
		else { preconditionFailure() }
		return .init(descriptor: preferredDescriptor, size: 0.0)
	}
}

extension UIFont {
	
	public func bold() -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(
			fontDescriptor.symbolicTraits.union(.traitItalic)
		)!
		return .init(descriptor: descriptor, size: 0.0)
	}
	
	public func italic() -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(
			fontDescriptor.symbolicTraits.union(.traitItalic)
		)!
		return .init(descriptor: descriptor, size: 0.0)
	}
	
	public func leading(_ leading: Leading) -> UIFont {
		
		let descriptor = fontDescriptor.withSymbolicTraits(
			fontDescriptor.symbolicTraits.union(leading == .loose ? .traitLooseLeading : .traitTightLeading)
		)!
		return UIFont(descriptor: descriptor, size: 0)
	}
	
	public func smallCaps() -> UIFont {
		let descriptor = fontDescriptor.addingAttributes([
			.featureSettings: [
				[
					UIFontDescriptor.FeatureKey.type: kLowerCaseType,
					UIFontDescriptor.FeatureKey.selector: kLowerCaseSmallCapsSelector
				],
				[
					UIFontDescriptor.FeatureKey.type: kUpperCaseType,
					UIFontDescriptor.FeatureKey.selector: kUpperCaseSmallCapsSelector
				]
			]
		])
		return UIFont(descriptor: descriptor, size: 0)
	}
	
	public func lowercaseSmallCaps() -> UIFont {
		let descriptor = fontDescriptor.addingAttributes([
			.featureSettings: [
				[
					UIFontDescriptor.FeatureKey.type: kLowerCaseType,
					UIFontDescriptor.FeatureKey.selector: kLowerCaseSmallCapsSelector
				]
			]
		])
		return UIFont(descriptor: descriptor, size: 0)
	}
	
	public func uppercaseSmallCaps() -> UIFont {
		let descriptor = fontDescriptor.addingAttributes([
			.featureSettings: [
				[
					UIFontDescriptor.FeatureKey.type: kUpperCaseType,
					UIFontDescriptor.FeatureKey.selector: kUpperCaseSmallCapsSelector
				]
			]
		])
		return UIFont(descriptor: descriptor, size: 0)
	}
}

extension UIFont {
	
	public enum Leading {
		case loose
		case tight
	}
}

extension UIFontDescriptor {
	
	fileprivate var weight: CGFloat {
		let traits = object(forKey: .traits) as! [UIFontDescriptor.TraitKey: Any]
		return traits[.weight] as! CGFloat
	}
}
