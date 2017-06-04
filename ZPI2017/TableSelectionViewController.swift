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
    var list2 = [DataModel]()
    var dbName = String()
    var tableName: String! = nil
    var dbToDelete: Int = -1
    var refreshControl: UIRefreshControl!
    var tField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(TableSelectionViewController.refreshData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        self.title = dbName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.bringSubview(toFront: act)
        startAct()
        DispatchQueue.main.async {
            let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tableView") as! TableViewViewController
            let tblName = self.list[indexPath.row].value as! String
            self.tableName = tblName
            self.list2.removeAll()
            do{
                //prepare query
                let query = "SELECT * FROM " + tblName
                let gett = try self.con.query(q: query)
                self.tableName = tblName
                //rows to wszystkie wiersze z query
                self.rows = try gett.readAllRows()
                //rowss to tez wszystkie wiersze z query XDD
                if(self.rows?.isEmpty==false){
                    destination.con = self.con
                    destination.tableName = tblName
                    var list = [DataModel]()
                    //rowss to tez wszystkie wiersze z query
                    var rowss = self.rows?[0]
                    // row to jeden wiersz z query
                    var ii:Int = 0
                    var cc:Int = 0
                    for row in rowss!{
                        cc = 0
                        for(key,value) in row{
                            list.append(DataModel(k: key, v: value, r: ii, c:cc))
                            self.list2.append(DataModel(k: key, v: value, r: ii, c:cc))
                            cc += 1
                        }
                        ii += 1
                    }
                    destination.list = list
                    destination.numberRows = (rowss?.count)!
                    destination.numberColumns = rowss![0].count
                    
                    self.performSegue(withIdentifier: "showViewTable", sender: self)
                }else{
                    self.performSegue(withIdentifier: "showViewTable", sender: self)
                    //self.showAlert(message: "Tabela jest pusta")
                }
                self.stopAct()
            }catch(let e){
                print(e)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableSelectionTableViewCell
        cell.table.text = list[indexPath.row].value as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            dbToDelete = indexPath.row
            confirm(msg: (list[indexPath.row].value as! String))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showViewTable"){
            if let destination = segue.destination as? TableViewViewController{
                if((self.rows?.isEmpty)! == false){
                    var rowss = self.rows?[0]
                    destination.list = self.list2
                    destination.numberRows = (rowss?.count)!
                    destination.numberColumns = rowss![0].count
                    destination.tableName = self.tableName
                }else{
                    destination.list = self.list2
                    destination.numberRows = 0
                    destination.numberColumns = 0
                }
            }
        }
    }
    
    func confirm(msg: String){
        let alert = UIAlertController(title: "UWAGA", message: "Czy na pewno chcesz usunąć tabelę \(msg)? Operacja jest nieodwracalna!", preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteDB)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteDB(alertAction: UIAlertAction){
        self.view.bringSubview(toFront: act)
        startAct()
        DispatchQueue.main.async {
            do{
                let query = "DROP TABLE " + (self.list[self.dbToDelete].value as! String)
                let _ = try self.con.query(q: query)
                self.list.remove(at: self.dbToDelete)
                self.tableView.reloadData()
            }catch(let e){
                print(e)
            }
            self.stopAct()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshData()
    }
    
    func refreshData(){
        do{
            list.removeAll()
            //prepare query
            let gett = try con.query(q: "SHOW TABLES")
            //rows to wszystkie wiersze z query
            rows = try gett.readAllRows()
            //rowss to tez wszystkie wiersze z query
            if((rows?.isEmpty)! == false){
            rowss = rows?[0]
            // row to jeden wiersz z query
            var ii:Int = 1
            var cc:Int = 0
            for row in rowss!{
                cc = 0
                for(key,value) in row{
                    list.append(DataModel(k: key, v: value, r: ii, c:cc))
                    cc += 1
                }
                ii += 1
                }
            }
        }catch(let e){
            print(e)
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
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
