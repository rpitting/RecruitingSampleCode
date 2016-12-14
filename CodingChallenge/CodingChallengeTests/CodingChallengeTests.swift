//
//  CodingChallengeTests.swift
//  CodingChallengeTests
//
//  Created by Reiner Pittinger on 14.12.16.
//  Copyright © 2016 clapp GmbH. All rights reserved.
//

import XCTest
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
        do {
           let testData = try Dictionary.from(filename: "TestData", bundle: testBundle)
        } catch {
            XCTFail("Could not load test data")

        }
        
        let model = NavigationModel(testData)
        XCTAssert(model.sections.count == 1)
        guard let firstSubection = model.sections.first else {
            XCTFail("No subsection found")
        }
        XCTAssert(firstSubection.children.count == 1)
        XCTAssert(firstSubection.children.first!.children.count == 2)
    }
    
}
