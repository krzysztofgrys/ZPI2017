//
//  TabBarController.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 5/22/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative
class TabBarController: UITabBarController {
    var con = MySQL.Connection()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
