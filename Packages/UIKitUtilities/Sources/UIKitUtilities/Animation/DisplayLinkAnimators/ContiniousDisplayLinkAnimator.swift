//
//  ContiniousDisplayLinkAnimator.swift
//
//
//  Created by Ruslan Lutfullin on 16/04/23.
//

import UIKit

public final class ContiniousDisplayLinkAnimator: DisplayLink {
	
	private let action: () -> Void
	
	public func start() {
		DispatchQueue.main.async {
			self._start()
		}
	}
	
	public func stop() {
		_stop()
	}
	
	public func pause() {
		_pause()
	}
	
	@objc
	internal override func heartbit(_ displayLink: CADisplayLink) {
		action()
	}
	
	public init(preferredFrameRateRange: CAFrameRateRange = .high, onTick action: @escaping () -> Void) {
		self.action = action
		super.init(mode: .common, preferredFrameRateRange: preferredFrameRateRange)
	}
}
