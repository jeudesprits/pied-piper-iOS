//
//  DisplayLink.swift
//
//
//  Created by Ruslan Lutfullin on 16/04/23.
//

import UIKit

///
public class DisplayLink {
	
	private var rawDisplayLink: CADisplayLink!
	
	public final let mode: RunLoop.Mode
	
	public final var preferredFrameRateRange: CAFrameRateRange {
		didSet {
			rawDisplayLink.preferredFrameRateRange = preferredFrameRateRange
		}
	}
	
	public internal(set) final var state: UIViewAnimatingState = .inactive
	
	public final var isRunning: Bool {
		state == .active
	}
	
	public final var isPaused: Bool {
		rawDisplayLink?.isPaused ?? false
	}
	
	internal func _start() {
		switch state {
		case .inactive:
			rawDisplayLink = .init(target: self, selector: #selector(heartbit(_:)))
			rawDisplayLink.preferredFrameRateRange = preferredFrameRateRange
			rawDisplayLink.add(to: .main, forMode: mode)
			state = .active
			
		case .active where isPaused:
			rawDisplayLink.isPaused = false
			
		default:
			assertionFailure()
		}
	}
	
	internal func _stop() {
		assert(state != .stopped)
		state = .stopped
		rawDisplayLink?.invalidate()
		rawDisplayLink = nil
	}
	
	internal func _pause() {
		assert(state == .active)
		rawDisplayLink.isPaused = true
	}
	
	@objc
	internal func heartbit(_ displayLink: CADisplayLink) {
	}
	
	internal init(mode: RunLoop.Mode, preferredFrameRateRange: CAFrameRateRange) {
		self.mode = mode
		self.preferredFrameRateRange = preferredFrameRateRange
	}
	
	deinit {
		self.rawDisplayLink?.invalidate()
	}
}
