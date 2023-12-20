//
//  CAFrameRateRange+Additions.swift
//
//
//  Created by Ruslan Lutfullin on 13/04/23.
//

import UIKit

extension CAFrameRateRange {
	
	public static var superLow: Self { .init(minimum: 8.0, maximum: 15.0, preferred: 0.0) }
	
	public static var veryLow: Self { .init(minimum: 15.0, maximum: 24.0, preferred: 0.0) }
	
	public static var low: Self { .init(minimum: 30.0, maximum: 48.0, preferred: 0.0) }
	
	public static var high: Self { .init(minimum: 80.0, maximum: 120.0, preferred: 120.0) }
}
