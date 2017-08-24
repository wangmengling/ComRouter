//
//  ComRouterError.swift
//  ComRoute
//
//  Created by jackWang on 2017/7/5.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import Foundation
enum ComRouterError:Int {
    
    case defaultError
    
    public static let domain = "ComRouterErrorDomain"
    enum empty:Int {
        case moduleName = 1001
        case className = 1002
        case funcName = 1003
        
        func error() -> NSError {
            switch self {
            case .moduleName:
                return ComRouterError.error(info: "moduleName is empty", rawValue: self.rawValue)
            case .className:
                return ComRouterError.error(info: "className is empty", rawValue: self.rawValue)
            case .funcName:
                return ComRouterError.error(info: "funcName is empty", rawValue: self.rawValue)
            }
        }
    }
    
    enum property:Int {
        case classType = 2001
        case selectorAction = 2002
        case selectorIMP = 2003
        
        func error() -> NSError {
            switch self {
            case .classType:
                return ComRouterError.error(info: "No Such Class Of NSObject", rawValue: self.rawValue)
            case .selectorAction:
                return ComRouterError.error(info: "No Such SelectorAction", rawValue: self.rawValue)
            case .selectorIMP:
                return ComRouterError.error(info: "No Such SelectorAction For IMP", rawValue: self.rawValue)
            }
        }
    }
    
    enum params:Int {
        case paramsLimit = 3001
        case paramNamesLimit = 3002
        func error() -> NSError {
            switch self {
            case .paramsLimit:
                return ComRouterError.error(info: "Parameter cannot be greater than 5", rawValue: self.rawValue)
            case .paramNamesLimit:
                return ComRouterError.error(info: "The params and paramNames do not match", rawValue: self.rawValue)
            }
        }
    }
    
    ///create error
    static func error(info: String, rawValue: Int) -> NSError {
        let error: NSError = NSError(domain:ComRouterError.domain,
                                     code: rawValue,
                                     userInfo: [NSLocalizedDescriptionKey : info])
        return error
    }
}
