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
    var error:NSError?
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
    /// call
    ///
    /// - Parameters:
    ///   - moduleName: Module name
    ///   - className: Class name
    ///   - funcName: Function name
    func call(_ moduleName:String, _ className:String, _ funcName:String) -> Self {
        self.moduleName = moduleName
        self.className = className
        self.funcName = funcName
        return self
    }
    
    
    /// No parameter callback
    ///
    /// - Parameters:
    ///   - moduleName: Module name
    ///   - className: Class name
    ///   - funcName: Function name
    ///   - block: Perform a callback result
    func call(_ moduleName:String, _ className:String, _ funcName:String, block: (Any,NSError?)->()) -> Void {
        self.moduleName = moduleName
        self.className = className
        self.funcName = funcName
        self.params([], [], block)
    }
}


//MARK: Add parameters
extension ComRouter {
    
    /// Add parameters
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - block: Perform a callback result
    func params(_ params:Any ...,_ block: (Any?,NSError?)->()) {
        self.params(params, [], block)
    }
    
    
    /// Add parameters And paramNames
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - paramNames: Parameter name -[String]
    ///   - block: Perform a callback result
    func params(_ params:Any ..., paramNames:[String], _ block: (Any?,NSError?)->()) {
        if params.count != paramNames.count {
            block(nil,ComRouterError.params.paramNamesLimit.error());
            return
        }
        self.params(params, paramNames, block)
    }
    
    
    /// Add parameters And paramNames
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - paramNames: Parameter name -[Index,String] Parameter name position , Parameter name
    ///   - block: Perform a callback result
    func params(_ params:Any ..., paramNames:Dictionary<Int,String>, _ block: (Any?,NSError?)->()) {
        var paramNameArr:[String] = []
        params.enumerated().forEach { (index,value) in
            let paramName = paramNames[index]
            if (paramName != nil) {
                paramNameArr.append(paramName!)
            }else {
                paramNameArr.append("")
            }
        }
        self.params(params, paramNameArr, block)
    }
    
    /// Call Function
    ///
    /// - Parameters:
    ///   - params: [Parameter]
    ///   - paramNames: [Parameter name]
    ///   - block: Call block (result,NSError)
    fileprivate func params(_ params:[Any], _ paramNames:[String], _ block: (Any?,NSError?)->()) {
        // Compile selectorName according to funcName, params, paramNames
        let (selectorName,selectorNameError) = self.selectorName(self.funcName,params,paramNames)
        guard (selectorNameError == nil) else {
            return block(selectorName,selectorNameError)
        }
        // According to the module, class classifies className
        let (className,classNameError) = self.className(self.moduleName, className: self.className)
        guard (classNameError == nil) else {
            return block(className,classNameError)
        }
        // Call comRouterManager
        ComRouterManager.shareInstance.call(className, selectorName, params, block)
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
    @nonobjc fileprivate func selectorName(_ funcName: String?, _ params:[Any], _ paramNames:[String]) -> (String,NSError?) {
        guard let funcName = funcName else {
            return ("",ComRouterError.empty.funcName.error())
        }
        if params.count == 0 {
            return (funcName,nil)
        }
        //Selector name assembly
        var funcNameAndParamName = funcName
        if paramNames.count > 0 { //Have parameter name - FuncName:paramNameOne:paramNameTwo:
            params.enumerated().forEach { (index,param) in
                if index == 0 {
                    funcNameAndParamName.append(":")
                }else {
                    let paramName = paramNames[index]
                    funcNameAndParamName.append(paramName+":")
                }
            }
        }else { //NO parameter name - FuncName:::
            params.enumerated().forEach { (index,param) in
                funcNameAndParamName.append(":")
            }
        }
        return (funcNameAndParamName,nil)
    }
}


// MARK: - Assembly class name
extension ComRouter {
    
    /// Assembly class name
    ///
    /// - Parameters:
    ///   - moduleName: Module name
    ///   - className: Class Name
    /// - Returns: Assembly class name
    fileprivate func className(_ moduleName: String?, className: String?) -> (String,NSError?) {
        guard let className = className  , className.count != 0 else {
            let error = ComRouterError.empty.className.error()
            return ("",error)
        }
        guard let moduleName = moduleName , moduleName.count != 0 else {
            let error = ComRouterError.empty.moduleName.error()
            return (className,error)
        }
        return (moduleName+"."+className,nil)
    }
}
