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
        
        testString = "五十"
        XCTAssertEqual(testString.numeralsToNumber(), "50")
        
        testString = "百"
        XCTAssertEqual(testString.numeralsToNumber(), "100")
        
        testString = "百五十"
        XCTAssertEqual(testString.numeralsToNumber(), "150")
        
        testString = "一九九七年六月六日"
        XCTAssertEqual(testString.numeralsToNumber(), "1997年6月6日")
        
        testString = "千九百九十九"
        XCTAssertEqual(testString.numeralsToNumber(), "1999")
        
        testString = ""
        XCTAssertEqual(testString.numeralsToNumber(), "")
        
        testString = "テスト"
        XCTAssertEqual(testString.numeralsToNumber(), "テスト")

    }
    
    func testConvertCharToStrExp() {
        
    }
    
    func testExpStr() {
        XCTAssertEqual("".expStr("1", isOnlyZero:false ),"10")
        XCTAssertEqual("".expStr("1", isOnlyZero:true ),"0")
        XCTAssertEqual("".expStr("2", isOnlyZero:false ),"100")
        XCTAssertEqual("".expStr("2", isOnlyZero:true ),"00")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
