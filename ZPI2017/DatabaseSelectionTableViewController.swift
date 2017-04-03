//
//  DatabaseSelectionTableViewController.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 4/3/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative


class DatabaseSelectionTableViewController: UITableViewController  {

    var con: MySQL.Connection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            do{
                try con?.close()
                print("mysql closed")
            } catch(let e){
                print(e)
                // todo lepiej to obsluzyc?
            }
        }
    }
    
   
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DatabaseSelectionTableViewCell
        cell.database.text = "Tutaj bedzie baza"
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }

   
}
