//
//  ComRouters.swift
//  ComRoute
//
//  Created by jackWang on 2017/7/2.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import Foundation
struct ComRouterManager {
    static let shareInstance = ComRouterManager()
    lazy var classObjects:Dictionary<String,NSObject> = Dictionary()
    lazy var selectorMethods:Dictionary<String,Dictionary<String,IMP>> = Dictionary()
    
    
}

extension ComRouterManager {
    
}

//MARK: Class Object
extension ComRouterManager {
    mutating func classObject(_ className:String) -> NSObject? {
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
    mutating func selectorMethod(_ className:String, _ selectorName:String) -> IMP? {
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
    
    mutating func saveSelectorMethods(_ className: String, _ selectorName: String, _ methodIMP: IMP) {
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


