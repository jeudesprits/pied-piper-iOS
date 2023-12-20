import XCTest
import osUtilities

internal final class OSAllocatedRecursiveLockTests: XCTestCase {
	
	internal func testWithLockUnchecked() {
		let lock = OSAllocatedRecursiveLock(initialState: 0)
		
		let dispatchBlockCount = 16
		let iterationCountPerBlock = 100_000
		let queues: [DispatchQueue] = [.global(qos: .utility), .global(), .global(qos: .userInteractive)]
		let group = DispatchGroup()
		for i in 0..<dispatchBlockCount {
			group.enter()
			let queue = queues[i % queues.count]
			queue.async {
				for _ in 0..<iterationCountPerBlock {
					lock.withLockUnchecked {
						$0 += 2
						lock.withLockUnchecked {
							$0 -= 1
						}
					}
				}
				group.leave()
			}
		}
		_ = group.wait(timeout: .distantFuture)
		
		XCTAssertEqual(lock.withLockUnchecked { $0 }, dispatchBlockCount * iterationCountPerBlock)
	}
	
	internal func testWithLockIfAvailableUnchecked() {
		let lock = OSAllocatedRecursiveLock(initialState: 0)
		
		lock.withLockIfAvailableUnchecked {
			$0 += 2
			XCTAssertEqual(lock.withLockIfAvailableUnchecked { $0 += 2; $0 -= 1; return $0 }, 3)
			$0 -= 1
		}
		
		XCTAssertEqual(lock.withLockIfAvailableUnchecked { $0 }, 2)
	}
}
