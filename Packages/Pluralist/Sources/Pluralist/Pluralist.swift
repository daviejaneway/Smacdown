// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@objc public enum PluralRule : Int {
    case asian = 0
    case english = 1
    case french = 2
    case latvian = 3
    case scottishGaelic = 4
    case romanian = 5
    case lithuanian = 6
    case russian = 7
    case czech = 8
    case polish = 9
    case slovenian = 10
    case irishGaelic = 11
    case arabic = 12
    case maltese = 13
    case macedonian = 14
    case icelandic = 15
    case breton = 16
    
    case asianExtended = 100
    case frenchExtended = 102
    case russianExtended = 107
    
    case none = 999999
}

@objc @objcMembers public class Pluralist : NSObject {
    @objc public static let kPluralFormRule = NSLocalizedString(
        "JJ_PLURAL_FORM_RULE",
        comment: "Set the string 'JJ_PLURAL_FORM_RULE' to the appropriate rule in each of the Localizable.strings"
    )
    
    private static func indexOfPluralForm(forNumber n: UInt, andRule rule: PluralRule) -> (UInt, UInt) {
        switch rule {
            case .asian:
                return (0, 1)
                
            case .english:
                return (n != 1 ? 1 : 0, 2)
                
            case .french:
                return (n > 1 ? 1 : 0, 2)
                
            case .latvian:
                return ((n % 10==1 && n % 100 != 11) ? 1 : (n != 0 ? 2 : 0), 3)
                
            case .scottishGaelic:
                let index: UInt = (n==1 || n==11) ? 0 : (n==2 || n==12 ? 1 : (n>0 && n<20 ? 2 : 3))
                
                return (index, 4)
                
            case .romanian:
                let index: UInt = n==1 ? 0 : ((n==0||(n%100>0&&n%100<20)) ? 1 : 2)
                
                return (index, 3)
                
            case .lithuanian:
                let index: UInt = (n%10 == 1 && n % 100 != 11) ? 0 : (n%10 >= 2 && (n%100 < 10 || n%100 >= 20) ? 2 : 1)
                
                return (index, 3)
                
            case .russian:
                let index: UInt = (n%10 == 1 && n%100 != 11) ? 0 : (n%10>=2&&n%10<=4&&(n%100<10||n%100>=20) ? 1 : 2)
                
                return (index, 3)
                
            case .czech:
                return (n==1 ? 0 : (n>=2&&n<=4 ? 1 : 2), 3)
                
            case .polish:
                let index: UInt = n==1 ? 0 : (n%10>=2&&n%10<=4&&(n%100<10||n%100>=20) ? 1 : 2)
                
                return (index, 3)
                
            case .slovenian:
                let index: UInt = n%100==1 ? 0 : (n%100==2 ? 1 : (n%100==3||n%100==4 ? 2 : 3))
                
                return (index, 4)
                
            case .irishGaelic:
                let index: UInt = n==1 ? 0 : (n==2 ? 1 : (n>=3&&n<=6 ? 2 : (n>=7&&n<=10 ? 3 : 4)))
                
                return (index, 5)
                
            case .arabic:
                let index: UInt = n==0 ? 5 : (n==1 ? 0 : (n==2 ? 1 : (n%100>=3&&n%100<=10 ? 2 : (n%100>=11&&n%100<=99 ? 3 : 4))))
                
                return (index, 6)
                
            case .maltese:
                let index: UInt = n==1 ? 0 : (n==0||(n%100>0&&n%100<=10) ? 1 : (n%100>10&&n%100<20 ? 2 : 3))
                
                return (index, 4)
                
            case .macedonian:
                return (n%10==1 ? 0 : (n%10==2 ? 1 : 2), 3)
                
            case .icelandic:
                return ((n%10 == 1 && n%100 != 11) ? 0 : 1, 2)
                
            case .breton:
                let cond1: Bool = (n%10 == 1 && n%100 != 11 && n%100 != 71 && n%100 != 91)
                let cond2: Bool = (n%10 == 2 && n%100 != 12 && n%100 != 72 && n%100 != 92)
                let cond3: Bool = (n%10 == 3 || n%10 == 4 || n%10 == 9) && n%100 != 13 && n%100 != 14 && n%100 != 19 && n%100 != 73 && n%100 != 74 && n%100 != 79 && n%100 != 93 && n%100 != 94 && n%100 != 99
                let mil: UInt = n%1000000 == 0 && n != 0 ? 3 : 4
                let index: UInt = cond1 ? 0 : cond2 ? 1 : cond3 ? 2 : mil
                
                return (index, 6)
                
            case .asianExtended:
                return (n==1 ? 0 : (n==2 ? 1 : 2), 3)
                
            case .frenchExtended:
                return (n==0 ? 0 : (n==1 ? 1 : 2), 3)
                
            case .russianExtended:
                let index: UInt = n==1 ? 0 : (n%10 == 1 && n%100 != 11 ? 1 : (n%10>=2&&n%10<=4&&(n%100<10||n%100>=20) ? 2 : 3))
                
                return (index, 4)
                
            case .none:
                print("No rule is specified")
                return (0, 0)
        }
    }
    
    @objc public static func pluralize(
        number: UInt,
        withForms forms: String,
        separator: String,
        andRule rule: PluralRule,
        shouldLocalizeNumerals: Bool
    ) -> String {
        let (idx, expectedForms) = indexOfPluralForm(forNumber: number, andRule: rule)
        
        guard expectedForms > 0 else {
            return "ERR"
        }
        
        let pluralForms = forms.split(separator: separator).map(String.init)
        let numberOfForms = pluralForms.count
        
        guard numberOfForms == expectedForms else {
            return "ERR"
        }
        
        guard idx < numberOfForms else {
            return "ERR"
        }
        
        let numberString: String
        if shouldLocalizeNumerals {
            let formatter = NumberFormatter()
            
            guard let fmt = formatter.string(from: number as NSNumber) else {
                return "ERR"
            }
            
            numberString = fmt
        } else {
            numberString = (number as NSNumber).stringValue
        }
        
        let pluralForm = pluralForms[Int(idx)]
        
        return String(format: pluralForm, numberString)
    }
}
