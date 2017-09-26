//
//  String+NumeralsToNumber.swift
//  JapaneseNumeralsToNumberForSwift
//
//  Created by MURAKAMI on 2017/05/25.
//
//  Copyright (c) 2017 Takuto Wada, https://github.com/twada/japanese-numerals-to-number

import Foundation

extension String {
    var japaneseNumericalChars: [String: String] {
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
    
    var japaneseChars: CharacterSet {
        return CharacterSet(charactersIn: japaneseNumericalChars.keys.joined())
    }
    
    private func convertCharToStr1To9(_ char: Character) -> String {
        return japaneseNumericalChars[char.description, default: "0"]
    }
    
    var japaneseNumericalExpChars: [String : String] {
        return  [
            "十": "1",
            "百": "2",
            "千": "3",
            "万": "4",
            "億": "8",
        ]
    }
    
    var japaneseExpChars: CharacterSet {
        return CharacterSet(charactersIn: japaneseNumericalExpChars.keys.joined())
    }
    
    private func convertExpStrToNumStr(_ str: String) -> String {
        return japaneseNumericalChars[str, default: "1"]
    }
    
    enum Chartype {
        case numerical, exp, normal
    }
    
    func checkType(_ str: String) -> Chartype {
        switch str {
        case str where str.rangeOfCharacter(from: japaneseChars) != nil:
            return Chartype.numerical
        case str where str.rangeOfCharacter(from: japaneseExpChars) != nil:
            return Chartype.numerical
        default:
            return Chartype.normal
        }
    }
}

extension String {
    func numeralsToNumber() -> String {
        
        var splitedStr: [String] = []
        
        // 文字列を漢数字文字列とそれ以外の文字列に分解する
        // 10の乗数を含んでいるかどうかは変換時に判断する
        var currentCharType: Chartype = Chartype.normal
        for (index,char) in self.characters.enumerated() {
            if index == 0 {
                currentCharType = checkType(char.description)
                splitedStr.append(char.description)
                continue
            }
            let newCharType: Chartype = checkType(char.description)
            
            if newCharType == currentCharType {
                // splitedStrの最後の値に１文字追加する
                let lastStr: String! = splitedStr.popLast()
                splitedStr.append(lastStr + char.description)
            } else {
                currentCharType = newCharType
                splitedStr.append(char.description)
            }
        }
        
        let convertStr: String = splitedStr.reduce("", {
            let StrSet: CharacterSet = CharacterSet(charactersIn: $1)
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
    
    // 10の乗数混じりの漢数字文字列を変換する
    func convertNumerialStringToNumberWithString(_ string: String) -> String {
        
        let convStr: String = string.characters.reversed().reduce("", {
            if $0.isEmpty {
                if $1.description.rangeOfCharacter(from: japaneseExpChars) != nil {
                    return expStr(japaneseNumericalExpChars[$1.description]!, isOnlyZero: false)
                } else {
                    return convertCharToStr1To9($1)
                }
            }
            
            if $1.description.rangeOfCharacter(from: japaneseExpChars) != nil {
                return String(Int($0)! + Int(expStr(japaneseNumericalExpChars[$1.description]!, isOnlyZero: false))!)
            } else {
                return convertCharToStr1To9($1) + $0.suffix($0.characters.count - 1)
            }
        })
        
        return convStr
    }
    
    func expStr(_ numberStr: String, isOnlyZero : Bool) -> String {
        var str: String = pow(Decimal(10), Int(numberStr)!).description

        if isOnlyZero {
            str = String(str.suffix(str.characters.count - 1))
        }
        return str
    }

}
