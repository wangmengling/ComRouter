//
//  ComRouter.swift
//  ComRouter
//
//  Created by jackWang on 2017/6/25.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import Foundation


let comRouter = ComRouter()
class ComRouter: NSObject {
    
    class var shareInstance: ComRouter {
        return comRouter;
    }
    
    var modleName: String?
    var classObject: AnyObject?
    var selectorAction:Selector?
    
    let syncQueue: DispatchQueue = DispatchQueue(label: "com.wangmaoling.router.syncQueue", attributes: .concurrent)
    
}

extension ComRouter {
    func moduleName(_ moduleName: String) -> Void {
        self.syncQueue.sync {
            
        }
//        self.syncQueue.add
//        return self
    }
}

extension ComRouter {
    
    func call(className: String, _ funcName: String) -> Self {
        return self.call(className: className, funcName, nil)
    }
    
    func call(className: String, _ funcName: String, _ params: Dictionary<String, Any>?) -> Self {
        guard let moduleName: String = self.modleName else { return self; }
        return self.call(moduleName: moduleName, className, funcName, params)
    }
    
    func call(moduleName: String, _ className: String ,_ funcName: String) -> Self {
//        self.call(moduleName:moduleName, className, funcName, nil)
        let moduleOfClass = moduleName + "." + className
        let classObject = callClassName(moduleOfClass)
        guard let classObjectE = classObject else {
            return self
        }
        return callFunc(classObjectE, funcName)
    }
    
    func call(moduleName: String, _ className: String ,_ funcName: String, _ params: Dictionary<String, Any>?) -> Self {
        let moduleOfClass = moduleName + "." + className
        let classObject = callClassName(moduleOfClass)
        guard let classObjectE = classObject else {
            return self
        }
        return callFunc(classObjectE, funcName, params)
    }
}

extension ComRouter {
    fileprivate func callClassName(_ className:String) -> NSObject? {
        let classType = NSClassFromString(className) as? NSObject.Type
        if let type = classType {
            let classInit = type.init()
            return classInit
        }
        return nil
    }
    
    fileprivate func callFunc(_ classObject: NSObject, _ funcName: String) -> Self {
        return self.callFunc(classObject, funcName, nil)
    }
    
    fileprivate func callFunc(_ classObject: NSObject, _ funcName: String, _ params: Dictionary<String,Any>?) -> Self {
        let selectorAction:Selector = NSSelectorFromString(funcName)
//        if classObject.responds(to: selectorAction) {
//            classObject.perform(selectorAction, with: params, with: "asdf")
//        }
//        let object = self.extractMethodFrom(owner: classObject, selector: selectorAction)
//        if object != nil {
//            let dsd = object!("asdf","test")
//            print(dsd)
//        }
        self.classObject = classObject;
        self.selectorAction = selectorAction;
        return self;
    }
    
    
    func extractMethodFrom(owner: AnyObject, selector: Selector) -> ((String,String) -> AnyObject)? {
        let method: Method
        if owner is AnyClass {
            method = class_getClassMethod(owner as! AnyClass, selector)
        } else {
            method = class_getInstanceMethod(type(of: owner), selector)
        }
        
        let implementation = method_getImplementation(method)
        typealias tupls = (AnyObject, Selector, String,String)
        
        typealias Function = @convention(c) (AnyObject, Selector, String,String) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        
        return { string,test in function(owner, selector, string,test).takeUnretainedValue() }
    }
    
    func methodForBlock<U>(_ params:U) -> Void {
        
        typealias Function = @convention(c) (AnyObject, Selector, Any) -> Unmanaged<AnyObject>
    }
    
    func methodForBlock(_ block:(AnyObject, Selector, Any) -> Unmanaged<AnyObject>) -> Void {
        typealias Function = @convention(c) (AnyObject, Selector, Any) -> Unmanaged<AnyObject>
    }
}

//MARK: Method IMP
extension ComRouter {
    
    // Method
    func getMethod(owner: AnyObject, selector: Selector) -> Method {
        let method: Method
        if owner is AnyClass {
            method = class_getClassMethod(owner as! AnyClass, selector)
        } else {
            method = class_getInstanceMethod(type(of: owner), selector)
        }
        return method;
    }
    
    // Method IMP
    func getMethodIMP(_ method:Method) -> IMP? {
        let implementation = method_getImplementation(method)
        return implementation;
    }
    
    func getMethodIMP() -> IMP? {
        guard let classObject = self.classObject, let selectorAction = self.selectorAction else { return nil }
        let method = self.getMethod(owner: classObject, selector: selectorAction)
        return self.getMethodIMP(method)
    }
}

extension ComRouter {
    fileprivate func sendParam() -> Any? {
        guard let implementation = self.getMethodIMP() else { return nil; }
        typealias Function = @convention(c) (AnyObject, Selector) -> Unmanaged<AnyObject>?
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(self.classObject!, self.selectorAction!)?.takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ param:Any) -> Any? {
        guard let implementation = self.getMethodIMP() else { return nil; }
        typealias Function = @convention(c) (AnyObject, Selector, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(self.classObject!, self.selectorAction!, param).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ param:Any,_ paramTwo:Any) -> Any? {
        guard let implementation = self.getMethodIMP() else { return nil; }
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(self.classObject!, self.selectorAction!, param, param).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ param:Any, _ paramTwo:Any, _ paramThree:Any) -> Any? {
        guard let implementation = self.getMethodIMP() else { return nil; }
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(self.classObject!, self.selectorAction!, param, paramTwo, paramThree).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ param:Any, _ paramTwo:Any, _ paramThree:Any, _ paramFour:Any) -> Any? {
        guard let implementation = self.getMethodIMP() else { return nil; }
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(self.classObject!, self.selectorAction!, param, paramTwo, paramThree, paramFour).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ param:Any, _ paramTwo:Any, _ paramThree:Any, _ paramFour:Any, _ paramFive:Any) -> Any? {
        guard let implementation = self.getMethodIMP() else { return nil; }
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any, Any, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(self.classObject!, self.selectorAction!, param, paramTwo, paramThree, paramFour, paramFive).takeUnretainedValue()
    }
    
    //    fileprivate func sendParam(_ param:String) -> ((String) -> AnyObject)? {
    //        guard let implementation = self.getMethodIMP() else { return nil; }
    //        typealias Function = @convention(c) (AnyObject, Selector, String) -> Unmanaged<AnyObject>
    //        let function = unsafeBitCast(implementation, to: Function.self)
    //        return { string in function(self.classObject!, self.selectorAction!, string).takeUnretainedValue() }
    //    }
}

//MARK: 参数解析
extension ComRouter {
    func params(_ params:Any ...,_ block: (Any)->()) {
        let o = self.sendParam()
        if (o != nil) {
            block(o as Any)
        }
    }
}
