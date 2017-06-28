//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func vardicPrint(_ strings: String...) {
    if strings.isEmpty {
        print("EMPTY")
    } else {
        for string in strings {
            print(string)
        }
    }
}

func optionalPrint(maybeStrings: String?...) {
    if maybeStrings.isEmpty {
        print("EMPTY")
    } else {
        for string in maybeStrings {
            if let string = string {
                print(string)
            } else {
                print("nil")
            }
            
        }
    }
}

//vardicPrint(strings: <#T##String...##String#>)
//var tuple : (String,String) = ("小明","sadf")
//tuple.0
//vardicPrint("Hello", "World", "!")
//vardicPrint()
optionalPrint(maybeStrings: "a", "sd")
optionalPrint(maybeStrings: <#T##String?...##String?#>)
//println()

//var nilString: String?
//optionalPrint("Goodbye", nil, "World", "!")

