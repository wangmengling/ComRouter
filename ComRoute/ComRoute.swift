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
    
    var modleName: String?
    
    
}

extension ComRoute {
    
    func call(className: String, _ funcName: String) -> Void {
        self.call(className: className, funcName, nil)
    }
    
    func call(className: String, _ funcName: String, _ params: Dictionary<String, Any>?) -> Void {
        guard let moduleName: String = self.modleName else { return ; }
        self.call(moduleName: moduleName, className, funcName, params)
    }
    
    func call(moduleName: String, _ className: String ,_ funcName: String) -> Void {
//        self.call(moduleName:moduleName, className, funcName, nil)
        let moduleOfClass = moduleName + "." + className
        let classObject = callClassName(moduleOfClass)
        guard let classObjectE = classObject else {
            return
        }
        callFunc(classObjectE, funcName)
    }
    
    func call(moduleName: String, _ className: String ,_ funcName: String, _ params: Dictionary<String, Any>?) -> Void {
        let moduleOfClass = moduleName + "." + className
        let classObject = callClassName(moduleOfClass)
        guard let classObjectE = classObject else {
            return
        }
        callFunc(classObjectE, funcName, params)
    }
}

extension ComRoute {
    fileprivate func callClassName(_ className:String) -> NSObject? {
        let classType = NSClassFromString(className) as? NSObject.Type
        if let type = classType {
            let classInit = type.init()
            return classInit
        }
        return nil
    }
    
    fileprivate func callFunc(_ classObject: NSObject, _ funcName: String) -> Void {
        self.callFunc(classObject, funcName, nil)
    }
    
    fileprivate func callFunc(_ classObject: NSObject, _ funcName: String, _ params: Dictionary<String,Any>?) -> Void {
        let selectorAction:Selector = NSSelectorFromString(funcName)
        if classObject.responds(to: selectorAction) {
            classObject.perform(selectorAction, with: params)
        }
    }
}

//MARK:
extension ComRoute {
    
}
