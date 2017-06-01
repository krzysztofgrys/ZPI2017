//
//  AddTableViewController.swift
//  ZPI2017
//
//  Created by Łukasz on 01.06.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative

class AddTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var pickerData = ["int","varchar(255)","double"]
    var numberOfAttributes = 1
    @IBOutlet weak var nameOfNewTable: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func addAttributeAction(_ sender: Any) {
        numberOfAttributes += 1
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: numberOfAttributes-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    @IBAction func addTableAction(_ sender: Any) {
        let con = Connecion.instanceOfConnection.con
        let cells = self.tableView.visibleCells as! Array<AddTableTableViewCell>
        var columns = [String]()
        var lengths = [String]()
        var dataTypes = [String]()
        var nulls = [Bool]()
        var uniques = [Bool]()
        var primary = [Bool]()
        for cell in cells {
            columns.append(cell.name.text!)
            lengths.append(cell.length.text!)
            let indeks = cell.dataType.selectedRow(inComponent: 0)
            dataTypes.append(pickerData[indeks])
            if(cell.nullCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
                nulls.append(true)
            }else{
                nulls.append(false)
            }
            if(cell.uniqueCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
                uniques.append(true)
            }else{
                uniques.append(false)
            }
            if(cell.primaryKeyCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
                primary.append(true)
            }else{
                primary.append(false)
            }
        }
        do{
            var query = "CREATE TABLE "+nameOfNewTable.text!+"("
            for i in 0...columns.count-1{
                query += columns[i]
                query += " " + dataTypes[i]
                if(i != columns.count - 1) {query += ", "}
            }
            query += " );"
            let _ = try con?.query(q: query)
        }catch(let e){
            print(e)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfAttributes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddTableTableViewCell
        cell.nullCheckBox.tag = indexPath.row
        return cell
    }

}
