//
//  ViewController.swift
//  ComRoute
//
//  Created by jackWang on 2017/6/25.
//  Copyright © 2017年 jackWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ComRouter.shareInstance.call("ComRouteCompenontTest", "ComRouteInterface", "comRouteForParams").params("one", "two", paramNames: ["test","string"]) { (result,error) in
            print(error as Any)
        }
    }
}

