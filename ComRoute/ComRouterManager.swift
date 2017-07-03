//
//  ComRouters.swift
//  ComRoute
//
//  Created by jackWang on 2017/7/2.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import Foundation
struct ComRouterManager {
    static var shareInstance = ComRouterManager()
    lazy var classObjects:Dictionary<String,NSObject> = Dictionary()
    lazy var selectorMethods:Dictionary<String,Dictionary<String,IMP>> = Dictionary()
    lazy var selectorActions:Dictionary<String,Dictionary<String,Selector>> = Dictionary()
    
}

extension ComRouterManager {
    
}

//MARK: Class Object
extension ComRouterManager {
    
    fileprivate mutating func classObject(_ className:String?) -> NSObject? {
        guard let className = className else { return nil }
        let classObject:NSObject? = self.classObjects[className]
        guard let classObjectG = classObject else {
            let classObject =  self.callClassObject(className)
            return classObject
        }
        return classObjectG
    }
    
    fileprivate mutating func callClassObject(_ className:String) -> NSObject? {
        let classType = NSClassFromString(className) as? NSObject.Type
        if let type = classType {
            let classInit = type.init()
            self.classObjects[className] = classInit
            return classInit
        }
        return nil
    }
}

extension ComRouterManager {
    func selectorActions(_ className: String?, _ selectorName: String?) -> Selector? {
        guard let className = className else { return nil }
        guard let selectorName = selectorName else { return nil }
        let selectorAction = self.selectorActions
//        guard let selectorActions = selectorActions else { return <#return value#> }
    }
}

extension ComRouterManager {
    mutating func selectorMethod(_ className:String?, _ selectorName:String?) -> IMP? {
        guard let className = className else { return nil }
        guard let selectorName = selectorName else { return nil }
        let classObjectSelectors = self.selectorMethods[className];
        guard let classObjectSelectorsG = classObjectSelectors else {
            let implementation = self.getMethodIMP(className, selectorName)
            if implementation != nil {
                self.saveSelectorMethods(className, selectorName, implementation!)
            }
            return implementation
        }
        
        let selectorMethodIMP = classObjectSelectorsG[selectorName]
        guard let selectorMethodIMPG = selectorMethodIMP else {//No IMP
            let implementation = self.getMethodIMP(className, selectorName)
            if implementation != nil {
                self.saveSelectorMethods(className, selectorName, implementation!)
            }
            return implementation
        }
        return selectorMethodIMPG;
    }
}
//MARK: Method IMP
extension ComRouterManager {
    
    fileprivate mutating func getMethodIMP(_ className: String, _ selectorName: String) -> IMP? {
        let classObject = self.classObject(className)
        guard let classObjectG = classObject else {
            return nil
        }
        // have object
        let methodIMP = self.getMethodIMP(classObjectG, selectorName)
        return methodIMP
    }
    
    // Method
    private func getMethod(owner: AnyObject, selector: Selector) -> Method {
        let method: Method
        if owner is AnyClass {
            method = class_getClassMethod(owner as! AnyClass, selector)
        } else {
            method = class_getInstanceMethod(type(of: owner), selector)
        }
        return method;
    }
    
    // Method IMP
    private func getMethodIMP(_ method:Method) -> IMP? {
        let implementation = method_getImplementation(method)
        return implementation;
    }
    
    //
    private func getMethodIMP(_ classObject: AnyObject, _ selectorAction:Selector) -> IMP? {
        let method = self.getMethod(owner: classObject, selector: selectorAction)
        return self.getMethodIMP(method)
    }
    
    private func getMethodIMP(_ classObject: AnyObject?, _ selectorName: String) -> IMP? {
        guard let classObjectG = classObject else { return nil }
        let selectorAction:Selector = NSSelectorFromString(selectorName)
        let methodIMP = self.getMethodIMP(classObjectG, selectorAction)
        return methodIMP
    }
}

//MARK: Save Method IMP
extension ComRouterManager {
    
    fileprivate mutating func saveSelectorMethods(_ className: String, _ selectorName: String, _ methodIMP: IMP) {
        let methodIMPs = self.selectorMethods[className]
        guard var methodIMPsG = methodIMPs else {
            let newMethodIMP = [selectorName:methodIMP]
            self.selectorMethods.updateValue(newMethodIMP, forKey: className)
            return
        }
        let implementation = methodIMPsG[selectorName]
        guard implementation != nil else {
            methodIMPsG.updateValue(methodIMP, forKey: selectorName)
            return
        }
    }
}


extension ComRouterManager {
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
    
    func callSelectorAction(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP, _ params:[Any]) ->  Any?  {
        
    }
}

extension ComRouterManager {
    mutating func call(_ className: String?, _ selectorName: String?, _ params:[Any],  _ block: (Any)->()) {
        
        guard let classObject = self.classObject(className) else { return  }
        guard let selectorAction = self.selectorMethod(className, selectorName) else { return  }
        guard let implementation = self.selectorMethod(className, selectorName) else { return }
        self.callSelectorAction(classObject, selectorAction, implementation, params)
    }
}


