//
//  UIView+Constraints.swift
//
//
//  Created by Ruslan Lutfullin on 12/29/21.
//

import UIKit
import FoundationUtilities
import Tor

extension UIView {
	
	internal static let updateConstraintsSwizzleInitialize: Void = {
		replaceMethod(
			of: UIView.self,
            from: NSSelectorFromString(Tor.decode("TGzzyLYHNwEzpIyvMzXHGLMKvBGMLkvLL")),
			to: #selector(getter: UIView.needsDoubleUpdateConstraints)
		)
		
		replaceMethod(
			of: UIView.self,
			from: NSSelectorFromString("_prepareForFirstIntrinsicContentSizeCalculation"),
			to: #selector(UIView.prepareForFirstIntrinsicContentSizeCalculation)
		)
		
		replaceMethod(
			of: UIView.self,
			from: NSSelectorFromString("_prepareForSecondIntrinsicContentSizeCalculationWithLayoutEngineBounds:"),
			to: #selector(UIView.prepareForSecondIntrinsicContentSizeCalculation(withLayoutEngineBounds:))
		)
	}()
	
	@objc
	open var needsDoubleUpdateConstraints: Bool {
		self.needsDoubleUpdateConstraints
	}
	
	@objc
	open func prepareForFirstIntrinsicContentSizeCalculation() {
		self.prepareForFirstIntrinsicContentSizeCalculation()
	}
	
	@objc
	open func prepareForSecondIntrinsicContentSizeCalculation(withLayoutEngineBounds bounds: CGRect) {
		self.prepareForSecondIntrinsicContentSizeCalculation(withLayoutEngineBounds: bounds)
	}
	
	//	private var layoutEngine: NSObject? {
	//		typealias Method = @convention(c) (NSObject, Selector) -> NSObject?
	//		let selector = NSSelectorFromString("_layoutEngine") //decode("TEvRHNMZG:BGz"))
	//		let methodIMP = method(for: selector)
	//		let method = unsafeBitCast(methodIMP, to: Method.self)
	//		return method(self, selector)
	//	}
	
	//	public final var layoutBounds: CGRect {
	//		guard let layoutEngine else { return .zero }
	//		typealias Method = @convention(c) (NSObject, Selector, NSObject) -> CGRect
	//		let selector = NSSelectorFromString("_nsis_compatibleBoundsInEngine:") //decode("TGLBLTxHFIvMBwEzWHNGyLdGZG:BGzU"))
	//		let methodIMP = class_getMethodImplementation(type(of: self).self, selector) //method(for: selector)
	//		let method = unsafeBitCast(methodIMP, to: Method.self)
	//		return method(self, selector, layoutEngine)
	//	}
	
	//	public final var layoutRect: CGRect {
	//		guard let layoutEngine else { return .zero }
	//		typealias Method = @convention(c) (NSObject, Selector, NSObject) -> CGRect
	//		let selector = NSSelectorFromString(decode("TGLBLTEvRHNMmzxMaKHFcHLMBG:qBzPdGZG:BGzU"))
	//		let methodIMP = method(for: selector)
	//		let method = unsafeBitCast(methodIMP, to: Method.self)
	//		return method(self, selector, layoutEngine)
	//	}
}

extension UIView {
	
	@propertyWrapper
	public struct ConstraintInvalidating {
		
		private var value: NSLayoutConstraint?
		
		public var wrappedValue: NSLayoutConstraint? {
			get { value }
			set {
				value?.isActive = false
				value = newValue
				value?.isActive = true
			}
		}
		
		public init(wrappedValue: NSLayoutConstraint?) {
			self.wrappedValue = wrappedValue
		}
	}
}
