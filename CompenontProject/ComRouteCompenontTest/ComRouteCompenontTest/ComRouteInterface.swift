//
//  ComRouteInterface.swift
//  ComRouteCompenontTest
//
//  Created by utouu-imac on 2017/6/26.
//  Copyright © 2017年 maolin. All rights reserved.
//

import Foundation
class ComRouteInterface: NSObject {
//    func comRouteForParams(_ params: Dictionary<String,Any>?) {
//        print(params);
//    }
    
//    func comRouteForParams(_ params: Dictionary<String,Any>?,string: String) {
//        print(params);
//        print(string);
//    }
//    
//    func comRouteForParams(_ params: Dictionary<String,Any>?, string: String, test:String) {
//        print(params);
//        print(string);
//        print(test);
//    }
    
    func comRouteForParams(_ test: String, _ string: String) -> AnyObject?{
        print(string);
        return test as AnyObject;
    }
    
    func comRouteForParams(test: String, _ string: String, name:String) -> AnyObject?{
        print(string);
        return test as AnyObject;
    }
    
//    func comRouteForParams(_ test: String, string: String) -> AnyObject?{
//        print(string);
//        return test as AnyObject;
//    }
    
    func comRouteForParams() {
        print("params");
    }
    
    func comRouteForParams(_ test: String) -> Any{
        print(test);
        return 1;
    }
    
    func comRouteForParam(_ test: String) -> Any{
        print(test);
        return 1;
    }
}
