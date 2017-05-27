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
    var dbToDelete: Int = -1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = Connecion.instanceOfConnection.list!
        con = Connecion.instanceOfConnection.con!
        tableView.delegate = self
        tableView.dataSource = self
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
                            cc += 1
                        }
                        ii += 1
                    }
                    destination.list = list
                    destination.numberRows = (rowss?.count)!
                    destination.numberColumns = rowss![0].count
                    
                    rowss = nil
                    //self.navigationController?.pushViewController(destination, animated: true)
                    self.performSegue(withIdentifier: "showViewTable", sender: self)
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
