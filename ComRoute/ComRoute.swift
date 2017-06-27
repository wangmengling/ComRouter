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
<<<<<<< Updated upstream
        let selectorAction:Selector = NSSelectorFromString(funcName+"::")
//        if classObject.responds(to: selectorAction) {
//            classObject.perform(selectorAction, with: params, with: "asdf")
//        }
        let object = self.extractMethodFrom(owner: classObject, selector: selectorAction)
        if object != nil {
            let dsd = object!("asdf","test")
            print(dsd)
        }
    }
    
    
    func extractMethodFrom(owner: AnyObject, selector: Selector) -> ((String,String) -> AnyObject)? {
        let method: Method
        if owner is AnyClass {
            method = class_getClassMethod(owner as! AnyClass, selector)
        } else {
            method = class_getInstanceMethod(type(of: owner), selector)
=======
        let selectorAction:Selector = NSSelectorFromString(funcName)
        if classObject.responds(to: selectorAction) {
            classObject.perform(selectorAction, with: params)
//            classObject.
//            externalP
>>>>>>> Stashed changes
        }
        
        let implementation = method_getImplementation(method)
        
        typealias Function = @convention(c) (AnyObject, Selector, String,String) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        
        return { string,test in function(owner, selector, string,test).takeUnretainedValue() }
    }
    
    func methodForBlock(_ classObject: NSObject, selectorAction:Selector) -> Void {
//        let methodBlock = (() -> (Void)).self;
//        typealias MethodType = (AnyObject, Selector, AnyObject) -> Void
//        let methodToCall:MethodType = classObject.method(for: selectorAction) as MethodType
//        classObject.method(for: selectorAction)
//        methodToCall(classObject, selectorAction, "asdf" as AnyObject)
    }
}

//MARK: 参数解析
extension ComRoute {
    func queryParamsOfDic(params:Dictionary<String,Any>) -> Any? {
        return nil
    }
    
    func queryParamsOfArray(params:Array<Any>) -> Any? {
        var tuples = ()
        for param in params {
            
        }
        return nil
    }
}
