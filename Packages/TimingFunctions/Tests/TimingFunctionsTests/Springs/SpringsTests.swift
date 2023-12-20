//
//  SpringsTests.swift
//  
//
//  Created by Ruslan Lutfullin on 07/04/23.
//

import XCTest
import TimingFunctions

internal final class SpringsTests: XCTestCase {
  
  internal func testUnderDamped() {
    for i in stride(from: 0.05, through: 0.95, by: 0.05) {
      for v in stride(from: 0.0, through: 10.0, by: 1.0) {
        let s1 = TimingFunctions.Springs.UnderDamped(spring: Spring(dampingRatio: i, frequencyResponse: i), initialVelocity: v)
        let s2 = DampedHarmonicSpring(dampingRatio: i, frequencyResponse: i)
        XCTAssertEqual(s1.amplitude, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
          XCTAssertEqual(s1(t), s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
        }
      }
    }
  }
  
  internal func testUnderDampedVector() {
    for i in stride(from: 0.05, through: 0.95, by: 0.05) {
      for v in stride(from: 0.0, through: 10.0, by: 1.0) {
        let s1 = TimingFunctions.SpringsVector.UnderDamped(spring: Spring(dampingRatio: i, frequencyResponse: i), initialVelocity: (v, v))
        let s2 = DampedHarmonicSpring(dampingRatio: i, frequencyResponse: i)
        XCTAssertEqual(s1.amplitude.0, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        XCTAssertEqual(s1.amplitude.1, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
          XCTAssertEqual(s1((t, t)).0, s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
          XCTAssertEqual(s1((t, t)).1, s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
        }
      }
    }
  }
  
  internal func testCriticallyDamped() {
    for i in stride(from: 0.05, through: 0.95, by: 0.05) {
      for v in stride(from: 0.0, through: 10.0, by: 1.0) {
        let s1 = TimingFunctions.Springs.CriticallyDamped(spring: Spring(dampingRatio: 1.0, frequencyResponse: i), initialVelocity: v)
        let s2 = DampedHarmonicSpring(dampingRatio: 1.0, frequencyResponse: i)
        XCTAssertEqual(s1.amplitude, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
          XCTAssertEqual(s1(t), s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
        }
      }
    }
  }
  
  internal func testCriticallyDampedVector() {
    for i in stride(from: 0.05, through: 0.95, by: 0.05) {
      for v in stride(from: 0.0, through: 10.0, by: 1.0) {
        let s1 = TimingFunctions.SpringsVector.CriticallyDamped(spring: Spring(dampingRatio: 1.0, frequencyResponse: i), initialVelocity: (v, v))
        let s2 = DampedHarmonicSpring(dampingRatio: 1.0, frequencyResponse: i)
        XCTAssertEqual(s1.amplitude.0, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        XCTAssertEqual(s1.amplitude.1, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
          XCTAssertEqual(s1((t, t)).0, s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
          XCTAssertEqual(s1((t, t)).1, s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
        }
      }
    }
  }
  
  internal func testOverDamped() {
    for i in stride(from: 0.05, through: 0.95, by: 0.05) {
      for v in stride(from: 0.0, through: 10.0, by: 1.0) {
        let s1 = TimingFunctions.Springs.OverDamped(spring: Spring(dampingRatio: 1.0 + i, frequencyResponse: i), initialVelocity: v)
        let s2 = DampedHarmonicSpring(dampingRatio: 1.0 + i, frequencyResponse: i)
        XCTAssertEqual(s1.amplitude, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
          XCTAssertEqual(s1(t), s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
        }
      }
    }
  }
  
  internal func testOverDampedVector() {
    for i in stride(from: 0.05, through: 0.95, by: 0.05) {
      for v in stride(from: 0.0, through: 10.0, by: 1.0) {
        let s1 = TimingFunctions.SpringsVector.OverDamped(spring: Spring(dampingRatio: 1.0 + i, frequencyResponse: i), initialVelocity: (v, v))
        let s2 = DampedHarmonicSpring(dampingRatio: 1.0 + i, frequencyResponse: i)
        XCTAssertEqual(s1.amplitude.0, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        XCTAssertEqual(s1.amplitude.1, s2.maximumDisplacementFromEquilibrium(initialVelocity: v), accuracy: 1e-7)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
          XCTAssertEqual(s1((t, t)).0, s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
          XCTAssertEqual(s1((t, t)).1, s2.position(at: t, initialVelocity: v), accuracy: 1e-7)
        }
      }
    }
  }
}
