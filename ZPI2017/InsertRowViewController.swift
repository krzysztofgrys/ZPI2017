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
    }
    var tableName: String! = nil
    var keys = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InsertRowTableViewCell
        let index = indexPath.row
        cell.key.text = keys[index]
        return cell
    }
    
    func getAllCells() -> [InsertRowTableViewCell] {
        var cells = [InsertRowTableViewCell]()
        for j in 0...keys.count-1
        {
            if let cell = tableView.cellForRow(at: IndexPath(row:j, section: 1)) {
                cells.append(cell as! InsertRowTableViewCell)
            }
        }
        return cells
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
