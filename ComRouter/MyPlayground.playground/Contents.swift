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

//let dataQueue = DispatchQueue(label: "data", attributes: .concurrent)
//let wirte = DispatchWorkItem(flags: .barrier) {
//    dispatchPrecondition(condition: .onQueueAsBarrier(dataQueue))
//    // write data
//    print("asdf")
//}
//dataQueue.async(execute: wirte)

//let group = DispatchGroup()
//let item1 = DispatchWorkItem {
//    print("1")
//}
//let item2 = DispatchWorkItem {
//    print("2")
//}
//let item3 = DispatchWorkItem {
//    print("3")
//}
//
//DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(group: group, execute: item3)
//DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(group: group, execute: item1)
//DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(group: group, execute: item2)


//let mainItem = DispatchWorkItem {
//    print("main")
//}
//DispatchQueue.main.async(group: group, execute: mainItem)

let queue = OperationQueue()
let block1 = BlockOperation {
    print("block1")
}
let block2 = BlockOperation {
    sleep(5)
    print("block2")
}
let block3 = BlockOperation {
    print("block3")
}
block2.addDependency(block1)
block3.addDependency(block2)
queue.addOperations([block1,block2,block3], waitUntilFinished: true)

//vardicPrint(strings: <#T##String...##String#>)
//var tuple : (String,String) = ("小明","sadf")
//tuple.0
//vardicPrint("Hello", "World", "!")
//vardicPrint()
//optionalPrint(maybeStrings: "a", "sd")
//optionalPrint(maybeStrings: <#T##String?...##String?#>)
//println()

//var nilString: String?
//optionalPrint("Goodbye", nil, "World", "!")

