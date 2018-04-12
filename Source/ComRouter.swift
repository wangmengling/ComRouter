//
//  ComRouter.swift
//  ComRouter
//
//  Created by jackWang on 2017/6/25.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import Foundation


let comRouter = ComRouter()
public class ComRouter: NSObject {
    
    public class var shareInstance: ComRouter {
        return comRouter;
    }
    
    var moduleName: String?
    var className: String?
    var funcName: String?
    
    var classObject: AnyObject?
    var selectorAction:Selector?
}

extension ComRouter {
    public func moduleName(_ moduleName: String) -> Self {
        self.moduleName = moduleName
        return self;
    }
    
    public func className(_ className: String) -> Self {
        self.className = className
        return self;
    }
    
    public func funcName(_ funcName: String) -> Self {
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
    public func call(_ moduleName:String, _ className:String, _ funcName:String) -> Self {
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
    public func call(_ moduleName:String, _ className:String, _ funcName:String, block: (Any,NSError?)->()) -> Void {
        self.moduleName = moduleName
        self.className = className
        self.funcName = funcName
        self.params([], [], block: block)
    }
    
    /// No parameter callback
    ///
    /// - Parameters:
    ///   - moduleName: Module name
    ///   - className: Class name
    ///   - funcName: Function name
    ///   - block: Perform a callback result
    public func call(_ moduleName:String, _ className:String, _ funcName:String) -> (Any?,NSError?) {
        self.moduleName = moduleName
        self.className = className
        self.funcName = funcName
        return self.params([], [])
    }
    
    /// No parameter callback
    ///
    /// - Parameters:
    ///   - moduleName: Module name
    ///   - className: Class name
    ///   - funcName: Function name
    ///   - block: Perform a callback result
    public func call<E:RawRepresentable>(_ moduleName:E, _ className:E, _ funcName:E, block: (Any,NSError?)->()) -> Void {
        self.moduleName = (moduleName.rawValue as! String)
        self.className = (className.rawValue as! String)
        self.funcName = (funcName.rawValue as! String)
        self.params([], [], block: block)
    }
    
    /// No parameter callback
    ///
    /// - Parameters:
    ///   - moduleName: Module name
    ///   - className: Class name
    ///   - funcName: Function name
    ///   - block: Perform a callback result
    public func call<E:RawRepresentable>(_ moduleName:E, _ className:E, _ funcName:E) -> (Any?,NSError?) {
        self.moduleName = (moduleName.rawValue as! String)
        self.className = (className.rawValue as! String)
        self.funcName = (funcName.rawValue as! String)
        return self.params([], [])
    }
}


//MARK: Add parameters
extension ComRouter {
    
    /// Add parameters
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - block: Perform a callback result
    public func params(_ params:Any ... ,  block: (Any?,NSError?)->()) {
        self.params(params, [], block: block)
    }
    
    
    /// Add parameters And paramNames
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - paramNames: Parameter name -[String]
    ///   - block: Perform a callback result
    public func params(_ params:Any ..., paramNames:[String],  block: (Any?,NSError?)->()) {
        if params.count != paramNames.count {
            block(nil,ComRouterError.params.paramNamesLimit.error());
            return
        }
        self.params(params, paramNames, block: block)
    }
    
    
    /// Add parameters And paramNames
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - paramNames: Parameter name -[Index,String] Parameter name position , Parameter name
    ///   - block: Perform a callback result
    public func params(_ params:Any ..., paramNames:Dictionary<Int,String>,  block: (Any?,NSError?)->()) {
        var paramNameArr:[String] = []
        params.enumerated().forEach { (index,value) in
            let paramName = paramNames[index]
            if (paramName != nil) {
                paramNameArr.append(paramName!)
            }else {
                paramNameArr.append("")
            }
        }
        self.params(params, paramNameArr, block: block)
    }
    
    /// Call Function
    ///
    /// - Parameters:
    ///   - params: [Parameter]
    ///   - paramNames: [Parameter name]
    ///   - block: Call block (result,NSError)
    fileprivate func params(_ param:[Any], _ paramNames:[String],  block: (Any?,NSError?)->()) {
        // Compile selectorName according to funcName, params, paramNames
        //        let (selectorName,selectorNameError) = self.selectorName(self.funcName,params,paramNames)
        //        guard (selectorNameError == nil) else {
        //            return block(selectorName,selectorNameError)
        //        }
        //        // According to the module, class classifies className
        //        let (className,classNameError) = self.className(self.moduleName, className: self.className)
        //        guard (classNameError == nil) else {
        //            return block(className,classNameError)
        //        }
        //        // Call comRouterManager
        //        ComRouterManager.shareInstance.call(className, selectorName, params, block)
        let result:(Any?,NSError?) = params(param, paramNames)
        block(result.0,result.1)
    }
}

extension ComRouter {
    /// Add parameters
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    /// - Result:
    ///   - (Any?,NSError?)
    public func params(_ params:Any ... ) ->(Any?,NSError?){
        return self.params(params, [])
    }
    
    
    /// Add parameters And paramNames
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - paramNames: Parameter name -[String]
    /// - Result:
    ///   - (Any?,NSError?)
    public func params(_ params:Any ..., paramNames:[String]) ->(Any?,NSError?) {
        if params.count != paramNames.count {
            return(nil,ComRouterError.params.paramNamesLimit.error());
        }
        return self.params(params, paramNames)
    }
    
    
    /// Add parameters And paramNames
    ///
    /// - Parameters:
    ///   - params: Parameter value -[Any]
    ///   - paramNames: Parameter name -[Index,String] Parameter name position , Parameter name
    /// - Result:
    ///   - (Any?,NSError?)
    public func params(_ params:Any ..., paramNames:Dictionary<Int,String>) ->(Any?,NSError?) {
        var paramNameArr:[String] = []
        params.enumerated().forEach { (index,value) in
            let paramName = paramNames[index]
            if (paramName != nil) {
                paramNameArr.append(paramName!)
            }else {
                paramNameArr.append("")
            }
        }
        return self.params(params, paramNameArr)
    }
    
    /// Call Function
    ///
    /// - Parameters:
    ///   - params: [Parameter]
    ///   - paramNames: [Parameter name]
    /// - Result:
    ///   - (Any?,NSError?)
    fileprivate func params(_ params:[Any], _ paramNames:[String]) -> (Any?,NSError?) {
        // Compile selectorName according to funcName, params, paramNames
        let (selectorName,selectorNameError) = self.selectorName(self.funcName,params,paramNames)
        guard (selectorNameError == nil) else {
            return (selectorName,selectorNameError)
        }
        // According to the module, class classifies className
        let (className,classNameError) = self.className(self.moduleName, className: self.className)
        guard (classNameError == nil) else {
            return (className,classNameError)
        }
        // Call comRouterManager
        return ComRouterManager.shareInstance.call(className, selectorName, params)
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

