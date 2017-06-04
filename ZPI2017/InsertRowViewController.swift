//
//  InsertRowViewController.swift
//  ZPI2017
//
//  Created by Łukasz on 03.06.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit

class InsertRowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func insertRowAction(_ sender: Any) {
        do{
            let cells = getAllCells()
            var query = "INSERT INTO " + tableName + " VALUES ("
            for cell in cells{
            query += cell.value.text! + ","
        }
        query.remove(at: query.index(before: query.endIndex))
        query += ");"
        
            let _ = try Connecion.instanceOfConnection.con?.query(q: query)
            _ = self.navigationController?.popViewController(animated: true)
        }catch(_){
            print("Blad dodania wiersza")
        }
    }
    var tableName: String! = nil
    var keys = [String]()
    var types = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        keys.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        types = getDataTypes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InsertRowTableViewCell
        let index = indexPath.row
        cell.key.text = keys[index]
        cell.key.text = keys[index] + ", " + types[keys[index]]!
        return cell
    }
    
    func getAllCells() -> [InsertRowTableViewCell] {
        var cells = [InsertRowTableViewCell]()
        if(keys.isEmpty == false){
        for j in 0...keys.count-1
        {
            if let cell = tableView.cellForRow(at: IndexPath(row:j, section: 0)) {
                cells.append(cell as! InsertRowTableViewCell)
            }
            }
        }
        return cells
    }
    
    func getDataTypes() -> [String : String]{
        let con = Connecion.instanceOfConnection.con
        var dataTypes = [String : String]()
        do{
            var qr = "SELECT column_name, column_type FROM information_schema.columns WHERE table_name='"
            qr += tableName + "'"
            let get = try con?.query(q: "show fields from "+tableName)
            let rows = try get?.readAllRows()
            if(rows?.isEmpty == false){
                let rowss = rows?[0]
                for row in rowss!{
                    let tmpType = unwrap(row["Type"])
                    let tmpNull = unwrap(row["Null"])
                    let tmpKey = unwrap(row["Key"])
                    let tmpField = unwrap(row["Field"])
                    dataTypes[String(describing: tmpField)] = "Null: " + String(describing: tmpNull) + ", Klucz: " + String(describing: tmpKey) + ", Typ: " + String(describing: tmpType)
                    keys.append(String(describing: tmpField))
                }
            }
        }catch(_){
            print("Blad pobrania typow danych")
        }
        return dataTypes
        
    }
    
    func unwrap<T>(_ any: T) -> Any {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }
        return unwrap(first.value)
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
