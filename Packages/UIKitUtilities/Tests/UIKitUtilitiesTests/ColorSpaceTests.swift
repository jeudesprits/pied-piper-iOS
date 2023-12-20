//
//  ColorSpaceTests.swift
//
//
//  Created by Ruslan Lutfullin on 01/12/22.
//

import XCTest
import SwiftUtilities
import simd
import UIKit
import UIKitUtilities

///
internal final class ColorSpaceTests: XCTestCase {
	
	internal func testSRGBLinear() {
		testColorSpace(.sRGBLinear, with: [
			(from: SIMD4(1.0, 0.0, 0.0, 0.0), to: SIMD4(0.41239079926595934, 0.21263900587151027, 0.01933081871559182, 0.0)),
			(from: SIMD4(0.0, 1.0, 0.0, 0.3), to: SIMD4(0.35758433938387800, 0.71516867876775600, 0.11919477979462598, 0.3)),
			(from: SIMD4(0.0, 0.0, 1.0, 0.5), to: SIMD4(0.18048078840183430, 0.07219231536073371, 0.95053215224966070, 0.5)),
			(from: SIMD4(1.0, 1.0, 1.0, 0.7), to: SIMD4(0.95045592705167170, 1.00000000000000000, 1.08905775075987840, 0.7)),
			(from: SIMD4(0.3, 0.5, 0.7, 1.0), to: SIMD4(0.42884596135301080, 0.47191066189784470, 0.73076914208675300, 1.0)),
		])
	}
	
	internal func testSRGB() {
		testColorSpace(.sRGB, with: [
			(from: SIMD4(1.0, 0.0, 0.0, 0.0), to: SIMD4(0.41239079926595934, 0.21263900587151027, 0.01933081871559182, 0.0)),
			(from: SIMD4(0.0, 1.0, 0.0, 0.3), to: SIMD4(0.35758433938387800, 0.71516867876775600, 0.11919477979462598, 0.3)),
			(from: SIMD4(0.0, 0.0, 1.0, 0.5), to: SIMD4(0.18048078840183430, 0.07219231536073371, 0.95053215224966070, 0.5)),
			(from: SIMD4(1.0, 1.0, 1.0, 0.7), to: SIMD4(0.95045592705167170, 1.00000000000000000, 1.08905775075987840, 0.7)),
			(from: SIMD4(0.3, 0.5, 0.7, 1.0), to: SIMD4(0.18759413324480811, 0.20099029915863230, 0.45275574544706700, 1.0)),
		])
	}
	
	internal func testDisplayP3Linear() {
		testColorSpace(.displayP3Linear, with: [
			(from: SIMD4(1.0, 0.0, 0.0, 0.0), to: SIMD4(0.48657094864821620, 0.22897456406974880, 0.00000000000000000, 0.0)),
			(from: SIMD4(0.0, 1.0, 0.0, 0.3), to: SIMD4(0.26566769316909306, 0.69173852183650640, 0.04511338185890264, 0.3)),
			(from: SIMD4(0.0, 0.0, 1.0, 0.5), to: SIMD4(0.19821728523436250, 0.07928691409374500, 1.04394436890097600, 0.5)),
			(from: SIMD4(1.0, 1.0, 1.0, 0.7), to: SIMD4(0.95045592705167170, 1.00000000000000020, 1.08905775075987870, 0.7)),
			(from: SIMD4(0.3, 0.5, 0.7, 1.0), to: SIMD4(0.41755723084306520, 0.47006247000479934, 0.75331774916013450, 1.0)),
		])
	}
	
	internal func testDisplayP3() {
		testColorSpace(.displayP3, with: [
			(from: SIMD4(1.0, 0.0, 0.0, 0.0), to: SIMD4(0.48657094864821620, 0.22897456406974880, 0.00000000000000000, 0.0)),
			(from: SIMD4(0.0, 1.0, 0.0, 0.3), to: SIMD4(0.26566769316909306, 0.69173852183650640, 0.04511338185890264, 0.3)),
			(from: SIMD4(0.0, 0.0, 1.0, 0.5), to: SIMD4(0.19821728523436250, 0.07928691409374500, 1.04394436890097600, 0.5)),
			(from: SIMD4(1.0, 1.0, 1.0, 0.7), to: SIMD4(0.95045592705167170, 1.00000000000000020, 1.08905775075987870, 0.7)),
			(from: SIMD4(0.3, 0.5, 0.7, 1.0), to: SIMD4(0.18129881120563907, 0.20034997889683379, 0.47733110020568190, 1.0)),
		])
	}
	
	internal func testOklab() {
		testColorSpace(.oklab, with: [
			(from: SIMD4(1.0, 0.0, 0.0, 0.0), to: SIMD4( 0.95045595258265750,  1.000000018175188500,  1.08905800012483600, 0.0)),
			(from: SIMD4(0.0, 1.0, 0.0, 0.3), to: SIMD4( 0.07683783990721535, -0.003783162490405804, -0.00539613281735496, 0.3)),
			(from: SIMD4(0.0, 0.0, 1.0, 0.5), to: SIMD4(-0.5936726586507541,   0.153776410460186670, -3.41907276072501200, 0.5)),
			(from: SIMD4(1.0, 1.0, 1.0, 0.7), to: SIMD4( 4.80538862961958300,  0.471290153588279100, -0.64925924821560620, 0.7)),
			(from: SIMD4(0.3, 0.5, 0.7, 1.0), to: SIMD4( 0.25426143500334190,  0.017718601785751638, -0.45776429399356460, 1.0)),
		])
	}
}

extension ColorSpaceTests {
	
	internal func testColorSpace<ColorSpaceType: ColorSpace>(
		_ colorSpace: ColorSpaceType,
		with pairs: [(from: ColorSpaceType.Components, to: ColorSpaceType.Components)]
	) where ColorSpaceType.Components == SIMD4<Double>,
			ColorSpaceType.ConnectionColorSpace_ == ConnectionColorSpaces.XYZ
	{
		for pair in pairs {
			XCTAssertEqual(colorSpace.toConnectionColorSpace(pair.from), pair.to, accuracy: 0.0001)
			XCTAssertEqual(colorSpace.fromConnectionColorSpace(pair.to), pair.from, accuracy: 0.0001)
		}
	}
}

fileprivate func XCTAssertEqual(
	_ expression1: @autoclosure () throws -> SIMD4<Double>,
	_ expression2: @autoclosure () throws -> SIMD4<Double>,
	accuracy: Double,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line
) {
	XCTAssertEqual(try expression1().x, try expression2().x, accuracy: accuracy, message(), file: file, line: line)
	XCTAssertEqual(try expression1().y, try expression2().y, accuracy: accuracy, message(), file: file, line: line)
	XCTAssertEqual(try expression1().z, try expression2().z, accuracy: accuracy, message(), file: file, line: line)
	XCTAssertEqual(try expression1().w, try expression2().w, accuracy: accuracy, message(), file: file, line: line)
}
