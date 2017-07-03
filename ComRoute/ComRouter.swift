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
    
    var moduleName: String?
    var className: String?
    var funcName: String?
    
    var classObject: AnyObject?
    var selectorAction:Selector?
    
    let syncQueue: DispatchQueue = DispatchQueue(label: "com.wangmaoling.router.syncQueue", attributes: .concurrent)
    
}

extension ComRouter {
    func moduleName(_ moduleName: String) -> Self {
        self.moduleName = moduleName
        return self;
    }
    
    func className(_ className: String) -> Self {
        self.className = className
        return self;
    }
    
    func funcName(_ funcName: String) -> Self {
        self.funcName = funcName
        return self;
    }
}

extension ComRouter {
    fileprivate func extractMethodFrom(owner: AnyObject, selector: Selector) -> ((String,String) -> AnyObject)? {
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
}


//MARK: 参数解析
extension ComRouter {
    func params(_ params:Any ...,_ block: (Any)->()) {
        self.params(params, paramNames: [], block)
    }
    
    func params(_ params:Any ..., paramNames:[String], _ block: (Any)->()) {
        let selectorName = self.selectorName(self.funcName,params,paramNames)
        let className = self.className(self.moduleName, className: self.className)
        ComRouterManager.shareInstance.call(className, selectorName, params, block)
    }
    
    func params(_ params:Any ..., paramNames:Dictionary<Int,String>, _ block: (Any)->()) {
        var paramNameArr:[String] = []
        params.enumerated().forEach { (index,value) in
            let paramName = paramNames[index]
            if (paramName != nil) {
                paramNameArr.append(paramName!)
            }else {
                paramNameArr.append("")
            }
        }
        self.params(params, paramNames: paramNameArr, block)
    }
}

//MARK: Build FunName And ParamName
extension ComRouter {
    
    /// Build FunName And ParamName
    ///
    /// - Parameters:
    ///   - funcName: Function Name -String
    ///   - params: Param value -[]
    ///   - paramNames: Param Name -[]
    /// - Returns: For Selector String
    @nonobjc fileprivate func selectorName(_ funcName: String?, _ params:[Any], _ paramNames:[String]) -> String {
        guard let funcName = funcName else { return "" }
        if params.count != paramNames.count {
            return funcName
        }
        var funcNameAndParamName = funcName + ":"
        params.enumerated().forEach { (index,param) in
            if index == 0 {
                funcNameAndParamName.append(":")
            }else {
                let paramName = paramNames[index]
                funcNameAndParamName.append(paramName+":")
            }
        }
        return funcNameAndParamName
    }
}


extension ComRouter {
    fileprivate func className(_ moduleName: String?, className: String?) -> String {
        guard let className = className else { return "" }
        guard let moduleName = moduleName else { return className }
        return moduleName+"."+className
    }
}
