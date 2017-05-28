//
//  String+NumeralsToNumberTest.swift
//  JapaneseNumeralsToNumberForSwift
//
//  Created by MURAKAMI on 2017/05/28.
//
//  Copyright (c) 2017 Takuto Wada, https://github.com/twada/japanese-numerals-to-number

import XCTest

class String_NumeralsToNumberTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumeralsToNumber() {
        var testString : String = "一"
        XCTAssertEqual(testString.numeralsToNumber(),"1")
        
        testString = "二"
        XCTAssertEqual(testString.numeralsToNumber(), "2")
        
        testString = "三〇"
        XCTAssertEqual(testString.numeralsToNumber(), "30")
        
        testString = "六八"
        XCTAssertEqual(testString.numeralsToNumber(), "68")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
