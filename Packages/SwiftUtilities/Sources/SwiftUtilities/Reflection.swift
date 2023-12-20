//
//  Reflection.swift
//
//
//  Created by Ruslan Lutfullin on 26/12/22.
//

import SwiftOverlayShims

@discardableResult
public func _forEachField(
    of type: Any.Type,
    options: _EachFieldOptions = [],
    body: (_ name: UnsafePointer<CChar>, _ offset: Int, _ type: Any.Type) -> Bool
) -> Bool {
    if _isClassType(type) != options.contains(.classType) {
        return false
    }
    
    let childCount = _getRecursiveChildCount(type)
    for index in 0..<childCount {
        let offset = _getChildOffset(type, index: index)
        
        var field = _FieldReflectionMetadata()
        let childType = _getChildMetadata(type, index: index, fieldMetadata: &field)
        defer { field.freeFunc?(field.name) }
        
        if let name = field.name {
            if !body(name, offset, childType) {
                return false
            }
        } else {
            if !body("", offset, childType) {
                return false
            }
        }
    }
    
    return true
}

@discardableResult
public func _forEachFieldWithKind(
    of type: Any.Type,
    options: _EachFieldOptions = [],
    body: (_ name: UnsafePointer<CChar>, _ offset: Int, _ type: Any.Type, _ kind: _MetadataKind) -> Bool
) -> Bool {
    if _isClassType(type) != options.contains(.classType) {
        return false
    }
    
    let childCount = _getRecursiveChildCount(type)
    for index in 0..<childCount {
        let offset = _getChildOffset(type, index: index)
        
        var field = _FieldReflectionMetadata()
        let childType = _getChildMetadata(type, index: index, fieldMetadata: &field)
        defer { field.freeFunc?(field.name) }
        let kind = _MetadataKind(of: childType)
        
        if let name = field.name {
            if !body(name, offset, childType, kind) {
                return false
            }
        } else {
            if !body("", offset, childType, kind) {
                return false
            }
        }
    }
    
    return true
}


// With "flags":
// runtimePrivate = 0x100
// nonHeap = 0x200
// nonType = 0x400
public enum _MetadataKind: UInt {
    
    case `class` = 0x0
    
    case `struct` = 0x200 // 0 | nonHeap
    
    case `enum` = 0x201 // 1 | nonHeap
    
    case optional = 0x202 // 2 | nonHeap
    
    case foreignClass = 0x203 // 3 | nonHeap
    
    case opaque = 0x300 // 0 | runtimePrivate | nonHeap
    
    case tuple = 0x301 // 1 | runtimePrivate | nonHeap
    
    case function = 0x302 // 2 | runtimePrivate | nonHeap
    
    case existential = 0x303 // 3 | runtimePrivate | nonHeap
    
    case metatype = 0x304 // 4 | runtimePrivate | nonHeap
    
    case objcClassWrapper = 0x305 // 5 | runtimePrivate | nonHeap
    
    case existentialMetatype = 0x306 // 6 | runtimePrivate | nonHeap
    
    case heapLocalVariable = 0x400 // 0 | nonType
    
    case heapGenericLocalVariable = 0x500 // 0 | nonType | runtimePrivate
    
    case errorObject = 0x501 // 1 | nonType | runtimePrivate
    
    case unknown = 0xffff
    
    public init(of type: Any.Type) {
        let value = _metadataKind(type)
        self = if let result = _MetadataKind(rawValue: value) {
            result
        } else {
            .unknown
        }
    }
}

public struct _EachFieldOptions: OptionSet {
	
	public let rawValue: UInt32
	
	public init(rawValue: UInt32) {
		self.rawValue = rawValue
	}
	
	/// Require the top-level type to be a class.
	///
	/// If this is not set, the top-level type is required to be a struct or
	/// tuple.
	public static var classType: Self { .init(rawValue: 1 << 0) }
	
	/// Ignore fields that can't be introspected.
	///
	/// If not set, the presence of things that can't be introspected causes
	/// the function to immediately return `false`.
	public static var ignoreUnknown: Self { .init(rawValue: 1 << 1) }
}

@_silgen_name("swift_isClassType")
public func _isClassType(_: Any.Type) -> Bool

@_silgen_name("swift_getMetadataKind")
public func _metadataKind(_: Any.Type) -> UInt

@_silgen_name("swift_reflectionMirror_recursiveCount")
public func _getRecursiveChildCount(_: Any.Type) -> Int

@_silgen_name("swift_reflectionMirror_recursiveChildOffset")
public func _getChildOffset(_: Any.Type, index: Int) -> Int

@_silgen_name("swift_reflectionMirror_recursiveChildMetadata")
public func _getChildMetadata(_: Any.Type, index: Int, fieldMetadata: UnsafeMutablePointer<_FieldReflectionMetadata>) -> Any.Type
