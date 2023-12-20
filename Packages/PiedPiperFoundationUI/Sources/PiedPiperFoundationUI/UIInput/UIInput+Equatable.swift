//
//  UIInput+Equatable.swift
//
//
//  Created by Ruslan Lutfullin on 27/05/23.
//

extension UIInput: Equatable {
    
    public static func == (lhs: UIInput, rhs: UIInput) -> Bool {
        guard lhs !== rhs else { return true }
        guard type(of: lhs) == type(of: rhs) else { return false }
        
        let lhsPointer = Unmanaged.passUnretained(lhs).toOpaque()
        let rhsPointer = Unmanaged.passUnretained(rhs).toOpaque()
        
        func visit(invalidatingPropertyOf type: (some InvalidatingProperty).Type, with propertyInfo: InvalidatingPropertyInfo) -> Bool {
            lhsPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type).pointee.value ==
            rhsPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type).pointee.value
        }
        
        for propertyInfo in lhs.typeInfo.invalidatingProperties {
            let type = propertyInfo.type
            if !visit(invalidatingPropertyOf: type, with: propertyInfo) { return false }
        }
        
        return true
    }
}
