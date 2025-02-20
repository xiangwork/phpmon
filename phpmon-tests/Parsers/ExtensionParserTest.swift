//
//  ExtensionParserTest.swift
//  phpmon-tests
//
//  Created by Nico Verbruggen on 13/02/2021.
//  Copyright © 2021 Nico Verbruggen. All rights reserved.
//

import XCTest

class ExtensionParserTest: XCTestCase {
    
    static var phpIniFileUrl: URL {
        return Bundle(for: Self.self).url(forResource: "php", withExtension: "ini")!
    }

    func testCanLoadExtension() throws {
        let extensions = PhpExtension.load(from: Self.phpIniFileUrl)
        
        XCTAssertGreaterThan(extensions.count, 0)
    }
    
    func testExtensionNameIsCorrect() throws {
        let extensions = PhpExtension.load(from: Self.phpIniFileUrl)
        
        let extensionNames = extensions.map { (ext) -> String in
            return ext.name
        }
        
        // These 6 should be found
        XCTAssertTrue(extensionNames.contains("xdebug"))
        XCTAssertTrue(extensionNames.contains("imagick"))
        XCTAssertTrue(extensionNames.contains("sodium-next"))
        XCTAssertTrue(extensionNames.contains("opcache"))
        XCTAssertTrue(extensionNames.contains("yaml"))
        XCTAssertTrue(extensionNames.contains("custom"))
        
        XCTAssertFalse(extensionNames.contains("fake"))
        XCTAssertFalse(extensionNames.contains("nice"))
    }
    
    func testExtensionStatusIsCorrect() throws {
        let extensions = PhpExtension.load(from: Self.phpIniFileUrl)
        
        // xdebug should be enabled
        XCTAssertEqual(extensions[0].enabled, true)
        
        // imagick should be disabled
        XCTAssertEqual(extensions[1].enabled, false)
    }
    
    func testToggleWorksAsExpected() throws {
        let destination = Utility.copyToTemporaryFile(resourceName: "php", fileExtension: "ini")!
        let extensions = PhpExtension.load(from: destination)
        XCTAssertEqual(extensions.count, 6)
        
        // Try to disable xdebug (should be detected first)!
        let xdebug = extensions.first!
        XCTAssertTrue(xdebug.name == "xdebug")
        XCTAssertEqual(xdebug.enabled, true)
        xdebug.toggle()
        XCTAssertEqual(xdebug.enabled, false)
        
        // Check if the file contains the appropriate data
        let file = try! String(contentsOf: destination, encoding: .utf8)
        XCTAssertTrue(file.contains("; zend_extension=\"xdebug.so\""))
        
        // Make sure if we load the data again, it's disabled
        XCTAssertEqual(PhpExtension.load(from: destination).first!.enabled, false)
    }

}
