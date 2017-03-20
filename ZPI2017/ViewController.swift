//
//  ViewController.swift
//  MySQLSampleiOS
//
//  Created by cipi on 25/12/15.
//
//

import UIKit
import MySqlSwiftNative

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let con = MySQL.Connection()
        let db_name = "hanna123"
        
        do{
            // open a new connection
            try con.open("149.202.40.84", user: "root", passwd: "haslo")
            
            // create a new database for tests, use exec since we don't expect any results
            try con.exec(q: "DROP DATABASE IF EXISTS " + db_name)
            try con.exec(q: "CREATE DATABASE IF NOT EXISTS " + db_name)
            
            // select the database
            try con.use(dbname: db_name)
            
            // create a table for our tests
            try con.exec(q: "CREATE TABLE test (id INT NOT NULL AUTO_INCREMENT, age INT, cash FLOAT, name VARCHAR(30), PRIMARY KEY (id))")
            
            // prepare a new statement for insert
            let ins_stmt = try con.prepare(q: "INSERT INTO test(age, cash, name) VALUES(?,?,?)")
            
            // prepare a new statement for select
            let select_stmt = try con.prepare(q: "SELECT * FROM test WHERE Id=?")
            
            // insert 300 rows
            for i in 1...300 {
                // use a int, float and a string
                try ins_stmt.exec([10-i, Float(i)/3.0, "name for \(i)"])
            }
            
            // read rows 30 to 60
            for i in 30...60 {
                do {
                    // send query
                    let res = try select_stmt.query([i])
                    
                    //read all rows from the resultset
                    let rows = try res.readAllRows()
                    
                    // print the rows
                    print(rows)
                }
                catch (let err) {
                    // if we get a error print it out
                    print(err)
                }
            }
            
            try con.close()
        }
        catch (let e) {
            print(e)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

