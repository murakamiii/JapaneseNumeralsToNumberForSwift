//
//  String+NumeralsToNumber.swift
//  JapaneseNumeralsToNumberForSwift
//
//  Created by MURAKAMI on 2017/05/25.
//
//  Copyright (c) 2017 Takuto Wada, https://github.com/twada/japanese-numerals-to-number

import Foundation

extension String {
    var japaneseNumericalChars : [String : String] {
        return  [
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
    }
    
    var japaneseChars : CharacterSet {
        return CharacterSet(charactersIn: japaneseNumericalChars.keys.joined())
    }
    
    private func convertCharToStr1To9(_ char : Character) -> String {
        return japaneseNumericalChars[char.description]!
    }
    
    var japaneseNumericalExpChars : [String : String] {
        return  [
            "十": "1",
            "百": "2",
            "千": "3",
            "万": "4",
            "億": "8",
        ]
    }
    
    var japaneseExpChars : CharacterSet {
        return CharacterSet(charactersIn: japaneseNumericalExpChars.keys.joined())
    }
    
    private func convertExpStrToNumStr(_ str : String) -> String {
        return japaneseNumericalChars[str]!
    }
    
    enum Chartype {
        case numerical
        case exp
        case normal
        
        init(_ number : Int) {
            switch number {
            case 0,1:
                self = .numerical
            default:
                self = .normal
            }
        }
    }
    
    func numeralsToNumber() -> String {
        
        var splitedStr : [String] = []
        var currentCharType : Chartype = Chartype.normal
        
        // 文字列を漢数字文字列とそれ以外の文字列に分解する
        // 10の乗数を含んでいるかどうかは変換時に判断する
        for (index,char) in self.characters.enumerated() {
            if index == 0 {
                currentCharType = Chartype(self.checkType(char.description))
                splitedStr.append(char.description)
                continue
            }
            let newCharType : Chartype = Chartype(self.checkType(char.description))
            
            if newCharType == currentCharType {
                // splitedStrの最後の値に１文字追加する
                let lastStr : String! = splitedStr.popLast()
                splitedStr.append(lastStr + char.description)
            } else {
                currentCharType = newCharType
                splitedStr.append(char.description)
            }
        }
        
        let convertStr : String = splitedStr.reduce("", {
            let StrSet : CharacterSet = CharacterSet(charactersIn: $1)
            switch $1 {
            case $1 where !japaneseExpChars.intersection(StrSet).isEmpty:
                return $0 + convertNumerialStringToNumberWithString($1)
            case $1 where !japaneseChars.intersection(StrSet).isEmpty:
                let convStr : String = $1.characters.reduce("", {
                   return $0 + convertCharToStr1To9($1)
                })
                return $0 + convStr
            default:
                return $0 + $1
            }
        })
        
        return convertStr
    }
    
    func checkType(_ str : String) -> Int {
        
        switch str {
        case str where str.rangeOfCharacter(from: japaneseChars) != nil:
            return 0
        case str where str.rangeOfCharacter(from: japaneseExpChars) != nil:
            return 1
        default:
            return 2
        }
    }
    
    // 10の乗数混じりの漢数字文字列を変換する
    func convertNumerialStringToNumberWithString(_ string : String) -> String {
        
        let convStr : String = string.characters.reversed().reduce("", {
            if $0.0.isEmpty {
                if $0.1.description.rangeOfCharacter(from: japaneseExpChars) != nil {
                    return expStr(japaneseNumericalExpChars[$0.1.description]!, isOnlyZero: false)
                } else {
                    return convertCharToStr1To9($0.1)
                }
            }
            
            if $0.1.description.rangeOfCharacter(from: japaneseExpChars) != nil {
                return String(Int($0.0)! + Int(expStr(japaneseNumericalExpChars[$0.1.description]!, isOnlyZero: false))!)
            } else {
                return convertCharToStr1To9($0.1) + $0.0.substring(from: $0.0.index(after: $0.0.startIndex))
            }
        })
        
        return convStr
    }
    
    func expStr(_ numberStr : String, isOnlyZero : Bool) -> String {
        var str : String = pow(Decimal(10), Int(numberStr)!).description

        if isOnlyZero {
            str = str.substring(from: str.index(after: str.startIndex))
        }
        return str
    }

}
