//
//  CodingChallengeTests.swift
//  CodingChallengeTests
//
//  Created by Reiner Pittinger on 14.12.16.
//  Copyright © 2016 clapp GmbH. All rights reserved.
//

import XCTest
@testable import JSONUtilities
@testable import CodingChallenge

class CodingChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSampleData() {
        let testBundle = Bundle(for: type(of: self))
        
        var rootEntries: [NavigationEntry] = []
        do {
            let testData: JSONDictionary = try Dictionary<String, Any>.from(filename: "TestData", bundle: testBundle)
            rootEntries = try testData.json(atKeyPath: "navigationEntries")
        } catch {
            XCTFail("Could not load or parse test data")
            return
        }
        
        XCTAssert(rootEntries.count == 1)
        guard let navigationRoot = rootEntries.first else {
            XCTFail("Could not load test data or parse test data")
            return
        }
        
        guard let firstNode = navigationRoot.nodes.first else {
            XCTFail("No subsection found")
            return
        }
        XCTAssert(firstNode.label == "Alter")
        XCTAssert(firstNode.nodes.count == 1)
        XCTAssert(firstNode.nodes.count == firstNode.children.count)
        
        guard let leafSection = firstNode.nodes.first else {
            XCTFail()
            return
        }
        
        XCTAssert(leafSection.label == "Baby & Kleinkind")
        XCTAssert(leafSection.children.count == 2)
        XCTAssert(leafSection.links.count == 2)
    }
    
}
