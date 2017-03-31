//
//  ViewController.swift
//  MySQLSampleiOS
//
//  Created by cipi on 25/12/15.
//
//

import UIKit
import MySqlSwiftNative


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let con = MySQL.Connection()
    let db_name = "hanna123"

   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        var tekst=""
        do{
            //make new connection with DB
            try con.open("149.202.40.84", user: "root", passwd: "haslo")
            try con.use(dbname: db_name)
            //prepare query
            let getData = try con.prepare(q: "SELECT * FROM test WHERE id=?")
            // get row index
            let indeks = indexPath.row + 1
            // get data from table from index row
            let res = try getData.query([indeks])
            //read all rows from the resultset
            let row = try res.readAllRows()
            //read from Array
            for p in row! {
                //read from Array<[String:Any]>
                for dat in p {
                    //read [String:Any]
                    for (key,value) in dat{
                        tekst+=" key:"+key+", value: "
                        switch value {
                        case let tmpVal as String:
                            tekst+=tmpVal
                            break;
                        case let tmpVal as Int:
                            tekst+="\(tmpVal)"
                            break;
                        case let tmpVal as Float:
                            tekst+="\(tmpVal)"
                            break;
                        default:
                            tekst+=String(describing: value)
                            print("blad")
                        }
                    }
                }
            }
        }
        catch (let e) {
            print(e)
        }
        cell.label.text=tekst
        return cell
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

