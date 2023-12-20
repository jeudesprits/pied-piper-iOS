//
//  Memoize.swift
//
//
//  Created by Ruslan Lutfullin on 7/2/21.
//

@inlinable
public func memoize<Input: Hashable, Output>(_ function: @escaping (Input) -> Output) -> (Input) -> Output {
	var storage = [Input: Output]()
	
    func memoized(_ input: Input) -> Output {
		if let cached = storage[input] {
			return cached
		} else {
			let result = function(input)
			storage[input] = result
			return result
		}
	}
    
    return memoized(_:)
}

@inlinable
public func memoize<Input1: Hashable, Input2: Hashable, Output>(_ function: @escaping (Input1, Input2) -> Output) -> (Input1, Input2) -> Output {
	var storage = [CompoundKey2<Input1, Input2>: Output]()
	
    func memoized(_ input1: Input1, _ input2: Input2) -> Output {
		if let cached = storage[CompoundKey2(input1, input2)] {
			return cached
		} else {
			let result = function(input1, input2)
			storage[CompoundKey2(input1, input2)] = result
			return result
		}
	}
    
    return memoized(_:_:)
}

@inlinable
public func memoize<Input1: Hashable, Input2: Hashable, Input3: Hashable, Output>(_ function: @escaping (Input1, Input2, Input3) -> Output) -> (Input1, Input2, Input3) -> Output {
	var storage = [CompoundKey3<Input1, Input2, Input3>: Output]()
    
    func memoized(_ input1: Input1, _ input2: Input2, _ input3: Input3) -> Output {
		if let cached = storage[CompoundKey3(input1, input2, input3)] {
			return cached
		} else {
			let result = function(input1, input2, input3)
			storage[CompoundKey3(input1, input2, input3)] = result
			return result
		}
	}
    
    return memoized(_:_:_:)
}

@inlinable
public func recursiveMemoize<Input: Hashable, Output>(_ function: @escaping ((Input) -> Output, Input) -> Output) -> (Input) -> Output {
	var storage = [Input: Output]()

    func memoized(_ input: Input) -> Output {
        if let cached = storage[input] {
            return cached
        } else {
            let result = function(memoized, input)
            storage[input] = result
            return result
        }
    }
    
    return memoized(_:)
}

@inlinable
public func recursiveMemoize<Input1: Hashable, Input2: Hashable, Output>(_ function: @escaping ((Input1, Input2) -> Output, Input1, Input2) -> Output) -> (Input1, Input2) -> Output {
	var storage = [CompoundKey2<Input1, Input2>: Output]()
    
    func memoized(_ input1: Input1, _ input2: Input2) -> Output {
        if let cached = storage[CompoundKey2(input1, input2)] {
            return cached
        } else {
            let result = function(memoized, input1, input2)
            storage[CompoundKey2(input1, input2)] = result
            return result
        }
    }

	return memoized(_:_:)
}

@inlinable
public func recursiveMemoize<Input1: Hashable, Input2: Hashable, Input3: Hashable, Output>(_ function: @escaping ((Input1, Input2, Input3) -> Output, Input1, Input2, Input3) -> Output) -> (Input1, Input2, Input3) -> Output {
	var storage = [CompoundKey3<Input1, Input2, Input3>: Output]()
    
    func memoized(_ input1: Input1, _ input2: Input2, _ input3: Input3) -> Output {
        if let cached = storage[CompoundKey3(input1, input2, input3)] {
            return cached
        } else {
            let result = function(memoized, input1, input2, input3)
            storage[CompoundKey3(input1, input2, input3)] = result
            return result
        }
    }
    
    return memoized(_:_:_:)
}

@usableFromInline
internal struct CompoundKey2<Key0: Hashable, Key1: Hashable>: Hashable {
    @usableFromInline
	internal let key0: Key0
    
    @usableFromInline
	internal let key1: Key1
	
    @inlinable
	internal init(_ key0: Key0, _ key1: Key1) {
		self.key0 = key0
		self.key1 = key1
	}
}

@usableFromInline
internal struct CompoundKey3<Key0: Hashable, Key1: Hashable, Key2: Hashable>: Hashable {
    @usableFromInline
    internal let key0: Key0
    
    @usableFromInline
	internal let key1: Key1
    
    @usableFromInline
	internal let key2: Key2
	
	@inlinable
	internal init(_ key0: Key0, _ key1: Key1, _ key2: Key2) {
		self.key0 = key0
		self.key1 = key1
		self.key2 = key2
	}
}
