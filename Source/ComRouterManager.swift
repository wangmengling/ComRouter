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
    
    /// Get the class object
    ///
    /// - Parameter className: The name assembled by module and class
    /// - Returns: Class object
    fileprivate mutating func classObject(_ className:String?) -> NSObject? {
        guard let className = className else { return nil }
        let classObject:NSObject? = self.classObjects[className]
        guard let classObjectG = classObject else {
            let classObject =  self.callClassObject(className)
            return classObject
        }
        return classObjectG
    }
    
    
    /// Create Class Object
    ///
    /// - Parameter:
    /// - className: The name assembled by module and class
    /// - Returns: Create class object
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
    
    /// Get func selector
    ///
    /// - Parameters:
    ///   - className: The name assembled by module and class
    ///   - selectorName: Func name and parameter assembly of the selectorName
    /// - Returns: Selector
    mutating func selectorActions(_ className: String?, _ selectorName: String?) -> Selector? {
        guard let className = className else { return nil }
        guard let selectorName = selectorName else { return nil }
        // SelectorActions is a two-dimensional array that stores values and values by className and selectorName
        let selectorActions = self.selectorActions[className]
        guard var selectorActionsGuard:[String:Selector] = selectorActions else {
            // If there is no array, redefine it
            let selectorAction:Selector = NSSelectorFromString(selectorName)
            self.selectorActions[className] = [selectorName:selectorAction]
            return selectorAction
        }
        let selectorAction = selectorActionsGuard[selectorName]
        guard let selectorActionGuard = selectorAction else {
            // If there is no array, redefine it
            let selectorAction:Selector = NSSelectorFromString(selectorName)
            selectorActionsGuard[selectorName] = selectorAction
            self.selectorActions[className] = selectorActionsGuard
            return selectorAction
        }
        return selectorActionGuard;
    }
    
    
}


// MARK: - Get IMP
extension ComRouterManager {
    
    /// Get IMP in selectorMethods and redefine if not
    ///
    /// - Parameters:
    ///   - className: The name assembled by module and class
    ///   - selectorName: Func name and parameter assembly of the selectorName
    /// - Returns: IMP
    mutating func selectorMethod(_ className:String?, _ selectorName:String?) -> IMP? {
        guard let className = className else { return nil }
        guard let selectorName = selectorName else { return nil }
        let classObjectSelectors = self.selectorMethods[className];
        guard let classObjectSelectorsG = classObjectSelectors else {
            // If there is no array, redefine IMP
            let implementation = self.getMethodIMP(className, selectorName)
            if implementation != nil {
                self.saveSelectorMethods(className, selectorName, implementation!)
            }
            return implementation
        }
        
        let selectorMethodIMP = classObjectSelectorsG[selectorName]
        guard let selectorMethodIMPG = selectorMethodIMP else {
            // If there is no array, redefine IMP
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
    
    /// Get IMP by className and selectorName
    ///
    /// - Parameters:
    ///   - className: The name assembled by module and class
    ///   - selectorName: Func name and parameter assembly of the selectorName
    /// - Returns: IMP
    fileprivate mutating func getMethodIMP(_ className: String, _ selectorName: String) -> IMP? {
        let classObject = self.classObject(className)
        guard let classObjectG = classObject else {
            return nil
        }
        // have object
        let methodIMP = self.getMethodIMP(classObjectG, selectorName)
        return methodIMP
    }
    
    
    /// Set Method
    ///
    /// - Parameters:
    ///   - owner: classObject
    ///   - selector: selector
    /// - Returns: Method
    private func getMethod(owner: AnyObject, selector: Selector) -> Method? {
        let method: Method?
        if owner is AnyClass {
            method = class_getClassMethod(owner as! AnyClass, selector)
        } else {
            method = class_getInstanceMethod(type(of: owner), selector)
        }
        return method;
    }
    
    
    /// Get IMP by method
    ///
    /// - Parameter method: Method
    /// - Returns: IMP
    private func getMethodIMP(_ method:Method) -> IMP? {
        let implementation = method_getImplementation(method)
        return implementation;
    }
    
    
    /// Get IMP by classObject and selectorAction
    ///
    /// - Parameters:
    ///   - classObject: AnyObject
    ///   - selectorAction: Selector
    /// - Returns: IMP
    private func getMethodIMP(_ classObject: AnyObject, _ selectorAction:Selector) -> IMP? {
        // get method
        guard let method = self.getMethod(owner: classObject, selector: selectorAction) else {
            return nil
        }
        return self.getMethodIMP(method)
    }
    
    
    /// Get IMP by classObject and selectorName
    ///
    /// - Parameters:
    ///   - classObject: AnyObject
    ///   - selectorName: Func name and parameter assembly of the selectorName
    /// - Returns: IMP
    private func getMethodIMP(_ classObject: AnyObject?, _ selectorName: String) -> IMP? {
        guard let classObjectG = classObject else { return nil }
        let selectorAction:Selector = NSSelectorFromString(selectorName)
        let methodIMP = self.getMethodIMP(classObjectG, selectorAction)
        return methodIMP
    }
}

//MARK: Save Method IMP
extension ComRouterManager {
    
    /// Save IMP to selectorMethods
    ///
    /// - Parameters:
    ///   - className: The name assembled by module and class
    ///   - selectorName: Func name and parameter assembly of the selectorName
    ///   - methodIMP: IMP
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


// MARK: - Execute call
extension ComRouterManager {
    
    /// Execute call and return result
    ///
    /// - Parameters:
    ///   - classObject: Class Object
    ///   - selectorAction: Selector
    ///   - implementation: IMP
    /// - Returns: return result
    fileprivate func sendParam(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP) -> Any? {
        // Defines a function type
        typealias Function = @convention(c) (AnyObject, Selector) -> Unmanaged<AnyObject>?
        // unsafeBitCast 会将第一个参数的内容按照第二个参数的类型转换，但是存在不安全性
        //        UnsafeBitCast converts the contents of the first argument to the type of the second argument, but there is insecurity
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(classObject, selectorAction)?.takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP, _ param:Any) -> Any? {
        typealias Function = @convention(c) (AnyObject, Selector, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(classObject, selectorAction, param).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP, _ param:Any,_ paramTwo:Any) -> Any? {
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(classObject, selectorAction, param, paramTwo).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP, _ param:Any, _ paramTwo:Any, _ paramThree:Any) -> Any? {
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(classObject, selectorAction, param, paramTwo, paramThree).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP, _ param:Any, _ paramTwo:Any, _ paramThree:Any, _ paramFour:Any) -> Any? {
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(classObject, selectorAction, param, paramTwo, paramThree, paramFour).takeUnretainedValue()
    }
    
    fileprivate func sendParam(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP , _ param:Any, _ paramTwo:Any, _ paramThree:Any, _ paramFour:Any, _ paramFive:Any) -> Any? {
        typealias Function = @convention(c) (AnyObject, Selector, Any, Any, Any, Any, Any) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        return function(classObject, selectorAction, param, paramTwo, paramThree, paramFour, paramFive).takeUnretainedValue()
    }
    
    
    /// Call sendParam() according to parameter judgment
    ///
    /// - Parameters:
    ///   - classObject: AnyObject
    ///   - selectorAction: Selector
    ///   - implementation: IMP
    ///   - params: [Any]
    /// - Returns: call result Any
    func callSelectorAction(_ classObject:AnyObject, _ selectorAction:Selector, _ implementation:IMP, _ params:[Any]) ->  Any?  {
        
//        return self.sendParam(classObject,selectorAction,implementation,params)
        switch params.count {
        case 0:
            return self.sendParam(classObject,selectorAction,implementation)
        case 1:
            return self.sendParam(classObject, selectorAction, implementation, params[0])
        case 2:
            return self.sendParam(classObject, selectorAction, implementation, params[0], params[1])
        case 3:
            return self.sendParam(classObject, selectorAction, implementation, params[0], params[1], params[2])
        case 4:
            return self.sendParam(classObject, selectorAction, implementation, params[0], params[1], params[2], params[3])
        case 5:
            return self.sendParam(classObject, selectorAction, implementation, params[0], params[1], params[2], params[3], params[4])
        default:
            return self.sendParam(classObject,selectorAction,implementation)
        }
    }
}

// MARK: - Provide interface to ComrRouter call
extension ComRouterManager {
    
    /// Initiates a call and returns the result of the call
    ///
    /// - Parameters:
    ///   - className: The name assembled by module and class
    ///   - selectorName: Func name and parameter assembly of the selectorName
    ///   - params: Method parameter value
    ///   - block: CallBack result (Any,NSError)
    mutating func call(_ className: String?, _ selectorName: String?, _ params:[Any],  _ block: (Any?,NSError?)->()) {
        guard let classObject = self.classObject(className) else {
            return  block(nil,ComRouterError.property.classType.error())
        } //Class Object Init
        guard let selectorAction = self.selectorActions(className, selectorName) else {
            return  block(nil,ComRouterError.property.selectorAction.error())
            
        } //Selector
        guard let implementation = self.selectorMethod(className, selectorName) else {
            return block(nil,ComRouterError.property.selectorIMP.error())
        } // Selector IMP
        
        let result = self.callSelectorAction(classObject, selectorAction, implementation, params)
        block(result,nil)
    }
}

extension ComRouter {
    fileprivate func extractMethodFrom(owner: AnyObject, selector: Selector) -> ((String,String) -> AnyObject)? {
        let method: Method
        if owner is AnyClass {
            method = class_getClassMethod(owner as? AnyClass, selector)!
        } else {
            method = class_getInstanceMethod(type(of: owner), selector)!
        }
        
        let implementation = method_getImplementation(method)
        typealias tupls = (AnyObject, Selector, String,String)
        
        typealias Function = @convention(c) (AnyObject, Selector, String,String) -> Unmanaged<AnyObject>
        let function = unsafeBitCast(implementation, to: Function.self)
        
        return { string,test in function(owner, selector, string,test).takeUnretainedValue() }
    }
}
