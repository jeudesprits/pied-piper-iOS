//
//  StepTimingFunctions.swift
//
//
//  Created by Ruslan Lutfullin on 07/04/23.
//

public protocol StepTimingFunction: TimingFunction {
    
    func callAsFunction(_ t: Double) -> Double
}

extension TimingFunctions {
    
    public enum Steps {
    }
}

extension TimingFunctions.Steps {
    
    public struct Smooth: StepTimingFunction {
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            t * t * (3.0 - 2.0 * t)
        }
        
        public init() {
        }
    }
}

extension TimingFunctions.Steps {
    
    public struct Smoother: StepTimingFunction {
        
        @inlinable
        public func callAsFunction(_ t: Double) -> Double {
            t * t * t * (t * (t * 6.0 - 15.0) + 10.0)
        }
        
        public init() {
        }
    }
}
