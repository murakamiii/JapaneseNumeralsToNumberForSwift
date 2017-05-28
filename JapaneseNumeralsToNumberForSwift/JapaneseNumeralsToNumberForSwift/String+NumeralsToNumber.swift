//
//  String+NumeralsToNumber.swift
//  JapaneseNumeralsToNumberForSwift
//
//  Created by MURAKAMI on 2017/05/25.
//
//

import Foundation

extension String {
    
    func numeralsToNumber() -> String {
        let japaneseNumericalChars : [String : String] = [
            "〇": "0",
            "一": "1",
            "二": "2",
            "三": "3",
            "四": "4",
            "五": "5",
            "六": "6",
            "七": "7",
            "八": "8",
            "九": "9",
        ]
        let japaneseChars : Set = Set(japaneseNumericalChars.keys)
        
        let strArr : [String] = self.characters.map{
            japaneseChars.contains($0.description) ? japaneseNumericalChars[$0.description]!
                                                   : $0.description
        }
        return strArr.joined()
    }
}

