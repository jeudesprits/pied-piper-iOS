//
//  EaseTimingFunctions.swift
//
//
//  Created by Ruslan Lutfullin on 07/04/23.
//

import SwiftUtilities
import Darwin

public protocol EaseTimingFunction: TimingFunction {
    
    func callAsFunction(_ t: Double) -> Double
}

extension TimingFunctions {
    
    public enum Eases {
    }
}

extension TimingFunctions.Eases {
    
    public struct Linear: EaseTimingFunction {
        
        @_transparent
        public func callAsFunction(_ t: Double) -> Double {
            t
        }
        
        public init() {
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Quadratic: EaseTimingFunction {
        
        public let mode: EaseMode
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode) {
            self.mode = mode
            
            let coreFunction: (Double) -> Double = { t in t * t }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Cubic: EaseTimingFunction {
        
        public let mode: EaseMode
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode) {
            self.mode = mode
            
            let coreFunction: (Double) -> Double = { t in t * t * t }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Quartic: EaseTimingFunction {
        
        public let mode: EaseMode
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode) {
            self.mode = mode
            
            let coreFunction: (Double) -> Double = { t in t * t * t * t }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Quintic: EaseTimingFunction {
        
        public let mode: EaseMode
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode) {
            self.mode = mode
            
            let coreFunction: (Double) -> Double = { t in t * t * t * t * t }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Sine: EaseTimingFunction {
        
        public let mode: EaseMode
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode) {
            self.mode = mode
            
            let coreFunction: (Double) -> Double = { t in 1.0 - sin((1.0 - t) * .pi / 2.0) }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Exponential: EaseTimingFunction {
        
        public let mode: EaseMode
        
        public let exponent: Double
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode, exponent: Double = 7.0) {
            self.mode = mode
            self.exponent = exponent
            
            let coreFunction: (Double) -> Double =
                if exponent == 0.0 {
                    { t in t }
                } else {
                    { t in (exp(exponent * t) - 1.0) / (exp(exponent) - 1.0) }
                }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Circle: EaseTimingFunction {
        
        public let mode: EaseMode
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode) {
            self.mode = mode
            
            let coreFunction: (Double) -> Double = { t in 1.0 - sqrt(1.0 - t * t) }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Back: EaseTimingFunction {
        
        public let mode: EaseMode
        
        public let amplitude: Double
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode, amplitude: Double = 1.70158) {
            self.mode = mode
            assert(amplitude >= 0.0)
            self.amplitude = amplitude
            
            let coreFunction: (Double) -> Double  = { t in t * t * t - t * amplitude * sin(t * .pi) }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Elastic: EaseTimingFunction {
        
        public let mode: EaseMode
        
        public let oscillations: Int
        
        public let springiness: Double
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode, oscillations: Int = 1, springiness: Double = 0.3) {
            self.mode = mode
            assert(oscillations >= 0)
            self.oscillations = oscillations
            assert(springiness >= 0.0)
            self.springiness = springiness
            
            let oscillations = Double(oscillations)
            let coreFunction: (Double) -> Double = { t in
                let expo: Double
                if springiness.isApproximatelyEqual(to: 0.0) {
                    expo = t
                } else {
                    expo = (exp(springiness * t) - 1.0) / (exp(springiness) - 1.0)
                }
                return expo * (sin((.pi * 2.0 * oscillations + .pi / 2.0) * t))
            }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct Bounce: EaseTimingFunction {
        
        public let mode: EaseMode
        
        public let bounces: Int
        
        public let bounciness: Double
        
        @usableFromInline
        internal let function: (Double) -> Double
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            function(t)
        }
        
        public init(mode: EaseMode, bounces: Int = 3, bounciness: Double = 2.0) {
            self.mode = mode
            assert(bounces >= 0)
            self.bounces = bounces
            self.bounciness = bounciness
            
            let _bounces = Double(bounces)
            let _bounciness: Double
            // Clamp the bounciness so we dont hit a divide by zero
            if bounciness < 1.0 || bounciness.isApproximatelyEqual(to: 1.0) {
                // Make it just over one.  In practice, this will look like 1.0 but avoid divide by zeros
                _bounciness = 1.001
            } else {
                _bounciness = bounciness
            }
            let _pow = pow(_bounciness, _bounces)
            let oneMinusBounciness = 1.0 - _bounciness
            
            // Our bounces grow in the x axis exponentially.  we define the first bounce as having a 'unit' width of 1.0 and compute
            // the total number of 'units' using a geometric series.
            // We then compute which 'unit' the current time is in
            let sumOfUnits = (1.0 - _pow) / oneMinusBounciness + _pow / 2.0 // geometric series with only half the last sum
            
            let coreFunction: (Double) -> Double = { t in
                // 'unit' space calculations
                let unitAtT = t * sumOfUnits
                
                // 'bounce' space calculations.
                // Now that we know which 'unit' the current time is in, we can determine which bounce we're in by solving the geometric equation:
                // unitAtT = (1 - bounciness^bounce) / (1 - bounciness), for bounce
                let bounceAtT = log(-unitAtT * (1.0 - _bounciness) + 1.0) / log(_bounciness)
                let start = bounceAtT.rounded(.down)
                let end = start + 1.0
                
                // 'time' space calculations.
                // We then project the start and end of the bounce into 'time' space
                let startTime = (1.0 - pow(_bounciness, start)) / (oneMinusBounciness * sumOfUnits)
                let endTime = (1.0 - pow(_bounciness, end)) / (oneMinusBounciness * sumOfUnits)
                
                // Curve fitting for bounce
                let midTime = (startTime + endTime) / 2.0
                let timeRelativeToPeak = t - midTime
                let radius = midTime - startTime
                let amplitude = pow(1.0 / bounciness, _bounces - start)
                
                // Evaluate a quadratic that hits (startTime,0), (endTime, 0), and peaks at amplitude
                return (-amplitude / (radius * radius)) * (timeRelativeToPeak - radius) * (timeRelativeToPeak + radius)
            }
            
            switch mode {
            case .in:
                function = coreFunction
            case .out:
                function = easeOut(coreFunction)
            case .inout:
                function = easeInOut(coreFunction)
            }
        }
    }
}

extension TimingFunctions.Eases {
    
    public struct CubicBezier: EaseTimingFunction {
        
        private let ax, bx, cx: Double
        
        private let ay, by, cy: Double
        
        private let gradient: (start: Double, end: Double)
        
        private let splineSamples: [Double]
        
        private let epsilon: Double
        
        public func callAsFunction(_ t: Double) -> Double {
            solve(t)
        }
        
        public init(controlPoints x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, epsilon: Double = 1.0e-4) {
            assert(0.0...1.0 ~= x1 && 0.0...1.0 ~= x2)
            
            cx = 3.0 * x1
            bx = 3.0 * (x2 - x1) - cx
            ax = 1.0 - cx - bx
            
            cy = 3.0 * y1
            by = 3.0 * (y2 - y1) - cy
            ay = 1.0 - cy - by
            
            gradient = Self.makeGradient(controlPoints: x1, y1, x2, y2)
            
            splineSamples = Self.makeSplineSamples(coefficients: ax, bx, cx)
            
            self.epsilon = epsilon
        }
    }
}

extension TimingFunctions.Eases.CubicBezier {
    
    //  private func slope(_ x: Double) -> Double {
    //    let t = solveX(x)
    //    let dx = sampleDerivativeX(t)
    //    let dy = sampleDerivativeY(t)
    //    if dx == 0, dy == 0 {
    //      return 0.0
    //    }
    //    return dy / dx
    //  }
}

extension TimingFunctions.Eases.CubicBezier {
    
    private func solve(_ x: Double) -> Double {
        if x < 0.0 {
            return 0.0 + gradient.start * x
        }
        if x > 1.0 {
            return 1.0 + gradient.end * (x - 1.0)
        }
        return sampleY(solveX(x))
    }
    
    private func solveX(_ x: Double) -> Double {
        assert(0.0 <= x && x <= 1.0)
        
        var t0 = 0.0
        var t1 = 0.0
        var t2 = x
        var x2 = 0.0
        var d2 = 0.0
        
        let delta_t = 1.0 / Double(Constants.splineSamples - 1)
        
        for i in 1..<Constants.splineSamples {
            if x <= splineSamples[i] {
                t1 = delta_t * Double(i)
                t0 = t1 - delta_t
                t2 = t0 + (t1 - t0) * (x - splineSamples[i - 1]) / (splineSamples[i] - splineSamples[i - 1])
                break
            }
        }
        
        let newtonEpsilon = min(Constants.defaultEpsilon, epsilon)
        
        for _ in 0..<Constants.maxNewtonIterations {
            x2 = sampleX(t2) - x
            if abs(x2) < newtonEpsilon {
                return t2
            }
            d2 = sampleDerivativeX(t2)
            if abs(d2) < Constants.defaultEpsilon {
                break
            }
            t2 -= x2 / d2
        }
        
        if abs(x2) < epsilon {
            return t2
        }
        
        while t0 < t1 {
            x2 = sampleX(t2)
            if abs(x2 - x) < epsilon {
                return t2
            }
            if x > x2 {
                t0 = t2
            } else {
                t1 = t2
            }
            t2 = (t1 + t0) * 0.5
        }
        
        return t2
    }
}

extension TimingFunctions.Eases.CubicBezier {
    
    private func sampleX(_ t: Double) -> Double {
        Self.sampleX(t, coefficients: ax, bx, cx)
    }
    
    private static func sampleX(_ t: Double, coefficients ax: Double, _ bx: Double, _ cx: Double) -> Double {
        ((ax * t + bx) * t + cx) * t
    }
    
    private func sampleY(_ t: Double) -> Double {
        Self.sampleY(t, coefficients: ay, by, cy)
    }
    
    private static func sampleY(_ t: Double, coefficients ay: Double, _ by: Double, _ cy: Double) -> Double {
        ((ay * t + by) * t + cy) * t
    }
    
    private func sampleDerivativeX(_ t: Double) -> Double {
        (3.0 * ax * t + 2.0 * bx) * t + cx
    }
    
    //  private func sampleDerivativeY(_ t: Double) -> Double {
    //    return (3.0 * ay * t + 2.0 * by) * t + cy
    //  }
}

extension TimingFunctions.Eases.CubicBezier {
    
    private static func makeGradient(controlPoints x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> (start: Double, end: Double) {
        let start: Double
        if x1 > 0.0 {
            start = y1 / x1
        } else if y1 == 0.0, x2 > 0.0 {
            start = y2 / x2
        } else if y1 == 0.0, y2 == 0.0 {
            start = 1.0
        } else {
            start = 0.0
        }
        
        let end: Double
        if x2 < 1.0 {
            end = (y2 - 1.0) / (x2 - 1.0)
        } else if y2 == 1.0, x1 < 1.0 {
            end = (y1 - 1.0) / (x1 - 1.0)
        } else if y2 == 1.0, y1 == 1.0 {
            end = 1.0
        } else {
            end = 0.0
        }
        
        return (start, end)
    }
    
    private static func makeSplineSamples(coefficients ax: Double, _ bx: Double, _ cx: Double) -> [Double] {
        var splineSamples = [Double]()
        splineSamples.reserveCapacity(Constants.splineSamples)
        let delta_t = 1.0 / Double(Constants.splineSamples - 1)
        for i in 0..<Constants.splineSamples {
            splineSamples.append(sampleX(Double(i) * delta_t, coefficients: ax, bx, cx))
        }
        return splineSamples
    }
}

extension TimingFunctions.Eases.CubicBezier {
    
    private enum Constants {
        
        internal static let defaultEpsilon = 1.0e-7
        
        internal static let splineSamples = 11
        
        internal static let maxNewtonIterations = 4
    }
}
