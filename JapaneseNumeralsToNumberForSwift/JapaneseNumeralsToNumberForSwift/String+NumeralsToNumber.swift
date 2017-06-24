//
//  String+NumeralsToNumber.swift
//  JapaneseNumeralsToNumberForSwift
//
//  Created by MURAKAMI on 2017/05/25.
//
//  Copyright (c) 2017 Takuto Wada, https://github.com/twada/japanese-numerals-to-number

import Foundation

extension String {
    func numeralsToNumber() -> String {
        enum Chartype {
            case numerical
            case exp
            case normal
            
            init(_ number : Int) {
                switch number {
                case 0,1:
                    self = .numerical
//                case 1:
//                    self = .exp
                default:
                    self = .normal
                }
            }
        }
        
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

        let japaneseNumericalExpChars : [String : String] = [
            "十": "1",
            "百": "2",
            "千": "3",
            "万": "4",
            "億": "8",
            ]
        let japaneseExpChars : Set = Set(japaneseNumericalExpChars.keys)
        
        var splitedStr : [String] = []
        var currentCharType : Chartype = Chartype.normal
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
            let StrSet : Set = Set($1.characters.map { $0.description })
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
        
        let japaneseNumericalExpChars : [String : String] = [
            "十": "1",
            "百": "2",
            "千": "3",
            "万": "4",
            "億": "8",
            ]
        let japaneseExpChars : Set = Set(japaneseNumericalExpChars.keys)
        
        switch str {
        case str where japaneseChars.contains(str):
            return 0
        case str where japaneseExpChars.contains(str):
            return 1
        default:
            return 2
        }
    }
    
    private func convertCharToStr1To9(_ char : Character) -> String {
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
        
        return japaneseNumericalChars[char.description]!
    }
    
    // 10の乗数混じりの漢数字を変換する
    func convertNumerialStringToNumberWithString(_ string : String) -> String {
        
        let japaneseNumericalExpChars : [String : String] = [
            "十": "1",
            "百": "2",
            "千": "3",
            "万": "4",
            "億": "8",
            ]
        let japaneseExpChars : Set = Set(japaneseNumericalExpChars.keys)
        
        let convStr : String = string.characters.reversed().reduce("", {
            if $0.0.isEmpty {
                if japaneseExpChars.contains($0.1.description) {
                    return expStr(japaneseNumericalExpChars[$0.1.description]!, isOnlyZero: false)
                } else {
                    return convertCharToStr1To9($0.1)
                }
            }
            
            if japaneseExpChars.contains($0.1.description) {
                return String(Int($0.0)! + Int(expStr(japaneseNumericalExpChars[$0.1.description]!, isOnlyZero: false))!)
            } else {
                return convertCharToStr1To9($0.1) + $0.0.substring(from: $0.0.index(after: $0.0.startIndex))
            }
        })
        
        return convStr
    }
    
    func convertCharToStrExp(_ string : String, charStr : String) -> String {
        let japaneseExpChars : [String : String] = [
            "十": "1",
            "百": "2",
            "千": "3",
            "万": "4",
            "億": "8",
            ]
        
        if string.isEmpty {
            return expStr(japaneseExpChars[charStr]!, isOnlyZero: false)
        }
        
        // stringは空チェック済みなので強制アンラップ
        let lastStr : String! = string.characters.last?.description

        if let _ : Int = Int (lastStr) {
            if string.characters.count > 1 {
                let beforeLastStr : String = string.substring(with:
                    string.index(string.endIndex, offsetBy: -2)
                    ..< string.index(before: string.endIndex))
                if beforeLastStr == "0" {
                    let expedStr : String = lastStr + expStr(japaneseExpChars[charStr]!, isOnlyZero: true)
                    return string.substring(to: string.index(string.endIndex, offsetBy: -1 * (expedStr.characters.count + 1))) + expedStr
                }
            }
            return string + expStr(japaneseExpChars[charStr]!, isOnlyZero: true)
        } else {
            return string + expStr(japaneseExpChars[charStr]!, isOnlyZero: false)
        }
    }
    
    func expStr(_ numberStr : String, isOnlyZero : Bool) -> String {
        var str : String = pow(Decimal(10), Int(numberStr)!).description

        if isOnlyZero {
            str = str.substring(from: str.index(after: str.startIndex))
        }
        return str
    }

}
