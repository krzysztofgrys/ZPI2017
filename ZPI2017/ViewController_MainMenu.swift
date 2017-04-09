//
//  ViewController.swift
//  zpi2017test2
//
//  Created by Administrator on 09.04.2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var TabBut:UIButton!
    @IBOutlet var SQLBut:UIButton!
    @IBOutlet var StatBut:UIButton!
    @IBOutlet var DelBut:UIButton!
    @IBOutlet var LogoutBut:UIButton!
    

    @IBAction func TabButAction()
    {
        NSLog("Tabele")
    }
    
    @IBAction func SQLButAction()
    {
        NSLog("SQL")
    }
    
    @IBAction func StatButAction()
    {
        NSLog("Stat")
    }
    
    @IBAction func DelButAction()
    {
        NSLog("Del")
    }
    
    @IBAction func LogoutButAction()
    {
        NSLog("Logout")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

