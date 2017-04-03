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
    var getData: MySQL.Statement! = nil
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var indeks = Int()
    var list = [DataModel]()

   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        var tekst=""
        let indeks = indexPath.row + 1
        for dat in list{
            if(dat.row==indeks){
                tekst+=" key:"+dat.key+", value: "
                switch dat.value {
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
                    tekst+=String(describing: dat.value)
                    print("blad")
                }
                
            }
        }
        print(tekst)
        cell.label.text=tekst
        return cell
    }
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do{
            //make new connection with DB
            try con.open("149.202.40.84", user: "root", passwd: "haslo")
            try con.use(dbname: db_name)
            //prepare query
            let gett = try con.query(q: "SELECT * FROM test")
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
        // Dispose of any resources that can be recreated.
    }
    
    
}

