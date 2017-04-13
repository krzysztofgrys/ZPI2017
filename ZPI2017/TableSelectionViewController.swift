//
//  TableSelectionViewController.swift
//  ZPI2017
//
//  Created by Łukasz on 13.04.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative

class TableSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var con = MySQL.Connection()
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var list = [DataModel]()
    var dbName = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        do{
            try con.use(dbname: dbName)
            //prepare query
            let gett = try con.query(q: "SHOW TABLES")
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.bringSubview(toFront: act)
        startAct()
        DispatchQueue.main.async {
            let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tableView") as! TableViewViewController
            let tblName = self.list[indexPath.row].value as! String
            do{
                //prepare query
                let query = "SELECT * FROM " + tblName
                let gett = try self.con.query(q: query)
                //rows to wszystkie wiersze z query
                self.rows = try gett.readAllRows()
                //rowss to tez wszystkie wiersze z query XDD
                if(self.rows?.isEmpty==false){
                    destination.con = self.con
                    destination.tableName = tblName
                    self.navigationController?.pushViewController(destination, animated: true)
                }else{
                    self.showAlert(message: "Tabela jest pusta")
                }
                self.stopAct()
            }catch(let e){
                print(e)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableSelectionTableViewCell
        cell.table.text = list[indexPath.row].value as! String
        return cell
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
    func startAct(){
        self.view.superview?.bringSubview(toFront: self.act)
        self.act.startAnimating()
        self.act.isHidden = false
    }
    func stopAct(){
        DispatchQueue.main.async {
            self.act.stopAnimating()
        }
    }
    
}
