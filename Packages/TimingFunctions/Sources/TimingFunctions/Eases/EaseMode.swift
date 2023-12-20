//
//  EaseMode.swift
//
//
//  Created by Ruslan Lutfullin on 09/04/23.
//

public enum EaseMode {
    case `in`
    case out
    case `inout`
}

internal func easeOut(_ easeIn: @escaping (Double) -> Double) -> (Double) -> Double {
    { t in
        1.0 - easeIn(1.0 - t)
    }
}

internal func easeInOut(_ easeIn: @escaping (Double) -> Double) -> (Double) -> Double {
    { t in
        t < 0.5
        ? easeIn(t * 2.0 ) * 0.5
        : (1.0 - easeIn((1.0 - t) * 2.0)) * 0.5 + 0.5
    }
}
