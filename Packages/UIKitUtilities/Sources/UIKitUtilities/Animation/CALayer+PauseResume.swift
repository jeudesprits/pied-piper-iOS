//
//  CALayer+PauseResume.swift
//
//
//  Created by Ruslan Lutfullin on 14/04/23.
//

import UIKit

/// - note: [Core Animation Timing in Depth](https://qieck.com/2016/05/core_animation_timing/)
extension CALayer {
    
    /// Pauses animations in layer tree.
    /// - note: [Technical Q&A QA1673](https://developer.apple.com/library/ios/qa/qa1673/_index.html#//apple_ref/doc/uid/DTS40010053)
    public func pause() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    /// Resumes animations in layer tree.
    /// - note: [Technical Q&A QA1673](https://developer.apple.com/library/ios/qa/qa1673/_index.html#//apple_ref/doc/uid/DTS40010053)
    public func resume() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime;
        beginTime = timeSincePause;
    }
}
