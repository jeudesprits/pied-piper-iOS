//
//  CubicBezierTests.swift
//  
//
//  Created by Ruslan Lutfullin on 05/04/23.
//

import XCTest
import CwlPreconditionTesting
import TimingFunctions

internal final class CubicBezierTests: XCTestCase {
  
  internal func testCreation() {
    let exception1 = catchBadInstruction {
      _ = TimingFunctions.Eases.CubicBezier(controlPoints: 0.0, 0.0, 1.0, 1.0)
    }
    XCTAssertNil(exception1)
    let exception2 = catchBadInstruction {
      _ = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, 0.5, -5.0, 0.5)
    }
    XCTAssertNotNil(exception2)
    let exception3 = catchBadInstruction {
      _ = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, 0.5, +5.0, 0.5)
    }
    XCTAssertNotNil(exception3)
    let exception4 = catchBadInstruction {
      _ = TimingFunctions.Eases.CubicBezier(controlPoints: -2.0, 0.5, 0.5, 0.5)
    }
    XCTAssertNotNil(exception4)
    let exception5 = catchBadInstruction {
      _ = TimingFunctions.Eases.CubicBezier(controlPoints: +2.0, 0.5, 0.5, 0.5)
    }
    XCTAssertNotNil(exception5)
  }
  
  internal func testBasic() {
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.25, 0.0, 0.75, 1.0)
      XCTAssertEqual(bezier(0.00), 0.00000, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.05), 0.01136, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.10), 0.03978, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.15), 0.07978, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.20), 0.12803, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.25), 0.18235, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.30), 0.24115, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.35), 0.30323, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.40), 0.36761, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.45), 0.43345, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.50), 0.50000, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.60), 0.63238, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.65), 0.69676, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.70), 0.75884, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.75), 0.81764, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.80), 0.87196, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.85), 0.92021, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.90), 0.96021, accuracy: 0.00001)
      XCTAssertEqual(bezier(0.95), 0.98863, accuracy: 0.00001)
      XCTAssertEqual(bezier(1.00), 1.00000, accuracy: 0.00001)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, 1.0, 0.5, 1.0)
      XCTAssertEqual(bezier(0.5), 0.875)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, 2.0, 0.5, 2.0)
      XCTAssertEqual(bezier(0.5), 1.625)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, -1.0, 0.5, -1.0)
      XCTAssertEqual(bezier(0.5), -0.625)
    }
  }
  
  internal func testUnclampedYValues() {
    let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, -1.0, 0.5, 2.0)
    XCTAssertEqual(bezier(0.00), +0.00000, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.05), -0.08954, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.10), -0.15613, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.15), -0.19641, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.20), -0.20651, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.25), -0.18232, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.30), -0.11992, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.35), -0.01672, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.40), +0.12660, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.45), +0.30349, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.50), +0.50000, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.55), +0.69651, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.60), +0.87340, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.65), +1.01672, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.70), +1.11992, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.75), +1.18232, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.80), +1.20651, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.85), +1.19641, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.90), +1.15613, accuracy: 0.00001)
    XCTAssertEqual(bezier(0.95), +1.08954, accuracy: 0.00001)
    XCTAssertEqual(bezier(1.00), +1.00000, accuracy: 0.00001)
  }
  
  internal func testInputOutOfRange() {
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, 1.0, 0.5, 1.0)
      XCTAssertEqual(bezier(-1.0), -2.0)
      XCTAssertEqual(bezier(+2.0), +1.0)
      XCTAssertEqual(bezier(+0.0), +0.0)
      XCTAssertEqual(bezier(+1.0), +1.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.0, 0.0, 1.0, 1.0)
      XCTAssertEqual(bezier(-1.0), -1.0)
      XCTAssertEqual(bezier(+2.0), +2.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.0, 1.0, 1.0, 0.0)
      XCTAssertEqual(bezier(-1.0), +0.0)
      XCTAssertEqual(bezier(+2.0), +1.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.5, 0.0, 1.0, 0.5)
      XCTAssertEqual(bezier(-1.0), +0.0)
      XCTAssertEqual(bezier(+2.0), +1.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.1, 0.2, 0.8, 0.8)
      XCTAssertEqual(bezier(-1.0), -2.0)
      XCTAssertEqual(bezier(+2.0), +2.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.0, 0.0, 0.5, 1.0)
      XCTAssertEqual(bezier(-1.0), -2.0)
      XCTAssertEqual(bezier(+2.0), +1.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 1.0, 0.5, 1.0, 1.0)
      XCTAssertEqual(bezier(-1.0), -0.5)
      XCTAssertEqual(bezier(+2.0), +1.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 0.0, 0.0, 0.0, 0.0)
      XCTAssertEqual(bezier(-1.0), -1.0)
      XCTAssertEqual(bezier(+2.0), +2.0)
    }
    
    do {
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: 1.0, 1.0, 1.0, 1.0)
      XCTAssertEqual(bezier(-1.0), -1.0)
      XCTAssertEqual(bezier(+2.0), +2.0)
    }
  }
  
  internal func testLinearity() {
    let bezier1 = TimingFunctions.Eases.CubicBezier(controlPoints: 0.0, 0.0, 1.0, 1.0)
    let bezier2 = TimingFunctions.Eases.CubicBezier(controlPoints: 1.0, 1.0, 0.0, 0.0)
    for i in 0...99 {
      let t = Double(i) / 100.0
      XCTAssertEqual(bezier1(t), bezier2(t), accuracy: 0.000001)
      XCTAssertEqual(bezier1(t), t, accuracy: 0.000001)
    }
  }
  
  internal func testAtExtremes() {
    for _ in 0...99 {
      let a = Double.random(in: 0.0..<1.0)
      let b = 2.0 * Double.random(in: 0.0..<1.0) - 0.5
      let c = Double.random(in: 0.0..<1.0)
      let d = 2.0 * Double.random(in: 0.0..<1.0) - 0.5
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: a, b, c, d)
      XCTAssertEqual(bezier(0.0), 0.0, accuracy: 0.000001)
      XCTAssertEqual(bezier(1.0), 1.0, accuracy: 0.000001)
    }
  }
  
  internal func testProjected() {
    for i in 0...99 {
      let t = Double(i) / 100.0
      let a = Double.random(in: 0.0..<1.0)
      let b = Double.random(in: 0.0..<1.0)
      let c = Double.random(in: 0.0..<1.0)
      let d = Double.random(in: 0.0..<1.0)
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: a, b, c, d)
      let projectedBezier = TimingFunctions.Eases.CubicBezier(controlPoints: b, a, d, c)
      XCTAssertEqual(t, projectedBezier(bezier(t)), accuracy: 0.00001)
    }
  }
  
  internal func testEquals() {
    for i in 0...99 {
      let t = Double(i) / 100.0
      let a = Double.random(in: 0.0..<1.0)
      let b = 2.0 * Double.random(in: 0.0..<1.0) - 0.5
      let c = Double.random(in: 0.0..<1.0)
      let d = 2.0 * Double.random(in: 0.0..<1.0) - 0.5
      let bezier1 = TimingFunctions.Eases.CubicBezier(controlPoints: a, b, c, d)
      let bezier2 = TimingFunctions.Eases.CubicBezier(controlPoints: a, b, c, d)
      XCTAssertEqual(bezier1(t), bezier2(t))
    }
  }

  internal func testSymetric() {
    for i in 0...99 {
      let t = Double(i) / 100.0
      let a = Double.random(in: 0.0..<1.0)
      let b = 2.0 * Double.random(in: 0.0..<1.0) - 0.5
      let c = 1 - a
      let d = 1 - b
      let bezier = TimingFunctions.Eases.CubicBezier(controlPoints: a, b, c, d)
      XCTAssertEqual(bezier(0.5), 0.5, accuracy: 0.000001)
      XCTAssertEqual(bezier(t), 1.0 - bezier(1.0 - t), accuracy: 0.000001)
    }
  }
}
