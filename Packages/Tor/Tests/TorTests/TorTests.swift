//
//  TorTests.swift
//  
//
//  Created by Ruslan Lutfullin on 01/12/22.
//

import XCTest
import Tor

internal final class TorTests: XCTestCase {
    
    internal func testEncode() {
        XCTAssertEqual(Tor.encode("window:didAnimateFirstHalfOfRotationToInterfaceOrientation:4"),              "PBGyHPUyByVGBFvMzaBKLMcvE_j_mHMvMBHGoHdGMzK_vxzjKBzGMvMBHGU4")
        XCTAssertEqual(Tor.encode("window:didRotateFromInterfaceOrientation:"),                                 "PBGyHPUyBymHMvMzaKHFdGMzK_vxzjKBzGMvMBHGU")
        XCTAssertEqual(Tor.encode("window:didRotateFromInterfaceOrientation:oldSize:"),                         "PBGyHPUyBymHMvMzaKHFdGMzK_vxzjKBzGMvMBHGUHEynBSzU")
        XCTAssertEqual(Tor.encode("window:resizeFromOrientation:"),                                             "PBGyHPUKzLBSzaKHFjKBzGMvMBHGU")
        XCTAssertEqual(Tor.encode("window:setupWithInterfaceOrientation:"),                                     "PBGyHPULzMNIrBMAdGMzK_vxzjKBzGMvMBHGU")
        XCTAssertEqual(Tor.encode("window:statusBarWillChangeFromHeight:toHeight"),                             "PBGyHPULMvMNLWvKrBEEXAvG:zaKHFczB:AMUMHczB:AM")
        XCTAssertEqual(Tor.encode("window:willAnimateFirstHalfOfRotationToInterfaceOrientation:duration:"),     "PBGyHPUPBEEVGBFvMzaBKLMcvE_j_mHMvMBHGoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU")
        XCTAssertEqual(Tor.encode("window:willAnimateFromContentFrame:toContentFrame:"),                        "PBGyHPUPBEEVGBFvMzaKHFXHGMzGMaKvFzUMHXHGMzGMaKvFzU")
        XCTAssertEqual(Tor.encode("window:willAnimateRotationToInterfaceOrientation:duration:"),                "PBGyHPUPBEEVGBFvMzmHMvMBHGoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU")
        XCTAssertEqual(Tor.encode("_window:willAnimateRotationToInterfaceOrientation:duration:newSize:"),       "TPBGyHPUPBEEVGBFvMzmHMvMBHGoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGUGzPnBSzU")
        XCTAssertEqual(Tor.encode("_window:willAnimateSecondHalfOfRotationFromInterfaceOrientation:duration:"), "TPBGyHPUPBEEVGBFvMznzxHGycvE_j_mHMvMBHGaKHFdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU")
        XCTAssertEqual(Tor.encode("__window:willRotateToInterfaceOrientation:duration:"),                       "TTPBGyHPUPBEEmHMvMzoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU")
        XCTAssertEqual(Tor.encode("__window:willRotateToInterfaceOrientation:duration:newSize:"),               "TTPBGyHPUPBEEmHMvMzoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGUGzPnBSzU")
    }
    
    internal func testDecode() {
        XCTAssertEqual(Tor.decode("PBGyHPUyByVGBFvMzaBKLMcvE_j_mHMvMBHGoHdGMzK_vxzjKBzGMvMBHGU4"),              "window:didAnimateFirstHalfOfRotationToInterfaceOrientation:4")
        XCTAssertEqual(Tor.decode("PBGyHPUyBymHMvMzaKHFdGMzK_vxzjKBzGMvMBHGU"),                                 "window:didRotateFromInterfaceOrientation:")
        XCTAssertEqual(Tor.decode("PBGyHPUyBymHMvMzaKHFdGMzK_vxzjKBzGMvMBHGUHEynBSzU"),                         "window:didRotateFromInterfaceOrientation:oldSize:")
        XCTAssertEqual(Tor.decode("PBGyHPUKzLBSzaKHFjKBzGMvMBHGU"),                                             "window:resizeFromOrientation:")
        XCTAssertEqual(Tor.decode("PBGyHPULzMNIrBMAdGMzK_vxzjKBzGMvMBHGU"),                                     "window:setupWithInterfaceOrientation:")
        XCTAssertEqual(Tor.decode("PBGyHPULMvMNLWvKrBEEXAvG:zaKHFczB:AMUMHczB:AM"),                             "window:statusBarWillChangeFromHeight:toHeight")
        XCTAssertEqual(Tor.decode("PBGyHPUPBEEVGBFvMzaBKLMcvE_j_mHMvMBHGoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU"),     "window:willAnimateFirstHalfOfRotationToInterfaceOrientation:duration:")
        XCTAssertEqual(Tor.decode("PBGyHPUPBEEVGBFvMzaKHFXHGMzGMaKvFzUMHXHGMzGMaKvFzU"),                        "window:willAnimateFromContentFrame:toContentFrame:")
        XCTAssertEqual(Tor.decode("PBGyHPUPBEEVGBFvMzmHMvMBHGoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU"),                "window:willAnimateRotationToInterfaceOrientation:duration:")
        XCTAssertEqual(Tor.decode("TPBGyHPUPBEEVGBFvMzmHMvMBHGoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGUGzPnBSzU"),       "_window:willAnimateRotationToInterfaceOrientation:duration:newSize:")
        XCTAssertEqual(Tor.decode("TPBGyHPUPBEEVGBFvMznzxHGycvE_j_mHMvMBHGaKHFdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU"), "_window:willAnimateSecondHalfOfRotationFromInterfaceOrientation:duration:")
        XCTAssertEqual(Tor.decode("TTPBGyHPUPBEEmHMvMzoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGU"),                       "__window:willRotateToInterfaceOrientation:duration:")
        XCTAssertEqual(Tor.decode("TTPBGyHPUPBEEmHMvMzoHdGMzK_vxzjKBzGMvMBHGUyNKvMBHGUGzPnBSzU"),               "__window:willRotateToInterfaceOrientation:duration:newSize:")
    }
}
