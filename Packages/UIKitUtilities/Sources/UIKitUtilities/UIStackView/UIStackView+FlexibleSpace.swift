//
//  UIStackView+FlexibleSpace.swift
//
//
//  Created by Ruslan Lutfullin on 18/07/23.
//

import UIKit

extension UIStackView {
	
	public func setFlexibleSpace(after arrangedSubview: UIView? = nil) {
		if let arrangedSubview {
			guard let index = arrangedSubviews.firstIndex(where: { $0 === arrangedSubview }) else { return }
			let flexibleSpacerView = FlexibleSpacerView(frame: .zero)
			let indexAfter = arrangedSubviews.index(after: index)
			if indexAfter != arrangedSubviews.endIndex {
				insertArrangedSubview(flexibleSpacerView, at: indexAfter)
			} else {
				addArrangedSubview(flexibleSpacerView)
			}
		} else {
			let flexibleSpacerView = FlexibleSpacerView(frame: .zero)
			addArrangedSubview(flexibleSpacerView)
		}
	}
	
	public func flexibleSpace(after arrangedSubview: UIView? = nil) -> UIView? {
		if let arrangedSubview {
			guard let index = arrangedSubviews.firstIndex(where: { $0 === arrangedSubview }) else { return nil }
			let indexAfter = arrangedSubviews.index(after: index)
			if indexAfter != arrangedSubviews.endIndex {
				let arrangedSubview = arrangedSubviews[indexAfter]
				return arrangedSubview is FlexibleSpacerView ? arrangedSubview : nil
			} else {
				return nil
			}
		} else {
			return arrangedSubviews.first(where: { $0 is FlexibleSpacerView })
		}
	}
}

fileprivate final class FlexibleSpacerView: UIView {
	
	internal override init(frame: CGRect) {
		super.init(frame: frame)
		isUserInteractionEnabled = false
		setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
		setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
	}
	
	internal required init?(coder: NSCoder) {
		fatalError()
	}
}
