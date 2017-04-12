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

    var con = MySQL.Connection()
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var list = [DataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            //prepare query
            let gett = try con.query(q: "SHOW DATABASES")
            //rows to wszystkie wiersze z query
            rows = try gett.readAllRows()
            //rowss to tez wszystkie wiersze z query XDD
            rowss = rows?[0]
            // row to jeden wiersz z query
            var ii:Int=1
            for row in rowss!{
                for(key,value) in row{
                    list.append(DataModel(k: key, v: value, r: ii))
                }
                ii += 1
            }
            
        }catch(let e){
            print(e)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            do{
                try con.close()
                print("mysql closed")
            } catch(let e){
                print(e)
                // todo lepiej to obsluzyc?
            }
        }
    }
    
   
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DatabaseSelectionTableViewCell
        cell.database.text = list[indexPath.row].value as! String
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return list.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tableSelection") as! TableSelectionTableViewController
        let dbName = list[indexPath.row].value as! String
        do{
            try con.use(dbname: dbName)
            //prepare query
            let gett = try con.query(q: "SHOW TABLES")
            //rows to wszystkie wiersze z query
            rows = try gett.readAllRows()
            //rowss to tez wszystkie wiersze z query XDD
            if(rows?.isEmpty==false){
                destination.con = self.con
                destination.dbName = dbName
                navigationController?.pushViewController(destination, animated: true)
            }else{
                showAlert(message: "Wybrana baza danych jest pusta")
            }
            
        }catch(let e){
            print(e)
        }
        
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

   
}
