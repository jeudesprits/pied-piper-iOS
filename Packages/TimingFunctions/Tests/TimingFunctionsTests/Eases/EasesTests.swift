//
//  EasesTests.swift
//  
//
//  Created by Ruslan Lutfullin on 03/04/23.
//

import XCTest
import TimingFunctions

internal final class EasesTests: XCTestCase {
  
  internal func testQuadratic() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quadratic(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.11, 0.00, 0.50, 0.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quadratic(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.50, 1.00, 0.89, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quadratic(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.45, 0.00, 0.55, 1.00))
  }
  
  internal func testCubic() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Cubic(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.32, 0.00, 0.67, 0.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Cubic(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.33, 1.00, 0.68, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Cubic(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.65, 0.00, 0.35, 1.00))
  }
  
  internal func testQuartic() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quartic(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.50, 0.00, 0.75, 0.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quartic(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.25, 1.00, 0.50, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quartic(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.76, 0.00, 0.24, 1.00))
  }
  
  internal func testQuintic() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quintic(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.64, 0.00, 0.78, 0.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quintic(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.22, 1.00, 0.36, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Quintic(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.83, 0.00, 0.17, 1.00))
  }
  
  internal func testSine() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Sine(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.12, 0.00, 0.39, 0.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Sine(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.61, 1.00, 0.88, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Sine(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.37, 0.00, 0.63, 1.00))
  }
  
  internal func testExponential() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Exponential(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.70, 0.00, 0.84, 0.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Exponential(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.16, 1.00, 0.30, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Exponential(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.87, 0.00, 0.13, 1.00))
  }
  
  internal func testCircle() {
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Circle(mode: .in),    TimingFunctions.Eases.CubicBezier(controlPoints: 0.55, 0.00, 1.00, 0.45))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Circle(mode: .out),   TimingFunctions.Eases.CubicBezier(controlPoints: 0.00, 0.55, 0.45, 1.00))
    XCTAssertEaseTimingFunction(TimingFunctions.Eases.Circle(mode: .inout), TimingFunctions.Eases.CubicBezier(controlPoints: 0.85, 0.00, 0.15, 1.00))
  }
}

fileprivate func XCTAssertEaseTimingFunction( _ easeTimingFunction: any EaseTimingFunction, _ cubicBezierEaseTimingFunction: TimingFunctions.Eases.CubicBezier) {
  for t in stride(from: 0.0, through: 1.0, by: 0.05) {
    XCTAssertEqual(easeTimingFunction(t), cubicBezierEaseTimingFunction(t), accuracy: 0.1)
  }
}
