//
//  UIInput+CustomDebugStringConvertible.swift
//
//
//  Created by Ruslan Lutfullin on 08/08/23.
//

extension UIInput: CustomDebugStringConvertible {
    
    public final var debugDescription: String {
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()
        
        var debugDescription = "\(String(describing: Self.self))("
        
        func visit(invalidatingPropertyOf type: (some InvalidatingProperty).Type, with propertyInfo: InvalidatingPropertyInfo) {
            let property = selfPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            debugDescription += "\(property.pointee.value), "
        }
        
        for propertyInfo in typeInfo.invalidatingProperties {
            let type = propertyInfo.type
            debugDescription += "\(propertyInfo.name.dropFirst()): "
            visit(invalidatingPropertyOf: type, with: propertyInfo)
        }
        
        debugDescription.removeSubrange(debugDescription.index(debugDescription.endIndex, offsetBy: -2)..<debugDescription.endIndex)
        debugDescription += ")"
        
        return debugDescription
    }
}
