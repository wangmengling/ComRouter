//
//  ComRouteInterface.swift
//  ComRouteCompenontTest
//
//  Created by utouu-imac on 2017/6/26.
//  Copyright © 2017年 maolin. All rights reserved.
//

import Foundation
class ComRouteInterface: NSObject {
    func comRouteForParams(_ params: Dictionary<String,Any>?) {
        print(params);
    }
    
    @objc func comRouteForParams() {
        print("params");
    }
}
