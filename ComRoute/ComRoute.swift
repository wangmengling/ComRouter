//
//  ComRoute.swift
//  ComRoute
//
//  Created by jackWang on 2017/6/25.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import Foundation

let comRoute = ComRoute()
class ComRoute: NSObject {
    
    class var shareInstance: ComRoute {
        return comRoute;
    }
    
    func call(_ module:String, _ className:String ,_ funcName:String) -> Void {
        let moduleOfClass = module + "." + className
        let classObject = callClassName(moduleOfClass)
        guard let classObjectE = classObject else {
            return
        }
        callFunc(classObjectE, funcName)
        return ;
    }
    
    func findModule() -> Void {
        
    }
    
    func callClassName(_ className:String) -> NSObject? {
        let classType = NSClassFromString(className) as? NSObject.Type
        if let type = classType {
            let classInit = type.init()
            return classInit
        }
        return nil
    }
    
    func callFunc(_ classObject:NSObject, _ funcName:String) -> Void {
        let selectorAction:Selector = NSSelectorFromString(funcName)
        if classObject.responds(to: selectorAction) {
            classObject.perform(selectorAction)
        }
    }
}
