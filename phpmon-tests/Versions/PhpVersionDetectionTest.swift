//
//  PhpVersionDetectionTest.swift
//  phpmon-tests
//
//  Created by Nico Verbruggen on 01/04/2021.
//  Copyright © 2021 Nico Verbruggen. All rights reserved.
//

import XCTest

class PhpVersionDetectionTest: XCTestCase {

    func testCanDetectValidPhpVersions() throws {
        let outcome = PhpEnv.shared.extractPhpVersions(from: [
            "", // empty lines should be omitted
            "php@8.0",
            "php@8.0", // should only be detected once
            "meta-php@8.0", // should be omitted, invalid
            "php@8.0-coolio", // should be omitted, invalid
            "php@7.0",
            "",
            "unrelatedphp@1.0", // should be omitted, invalid
            "php@5.6",
            "php@5.4" // should be omitted, not supported
        ], checkBinaries: false, generateHelpers: false)
        
        XCTAssertEqual(outcome, ["8.0", "7.0"])
    }
}
