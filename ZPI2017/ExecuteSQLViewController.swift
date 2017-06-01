//
//  ExecuteSQLViewController.swift
//  ZPI2017
//
//  Created by Administrator on 15.05.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative

class ExecuteSQLViewController: UIViewController {

    var con = MySQL.Connection()
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var list = [DataModel]()
    var list2 = [DataModel]()    
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var SQLTextField: UITextView!
    @IBAction func executeButtonClicked(_ sender: AnyObject) {
        startAct()
        DispatchQueue.main.async {
            self.list2.removeAll()
            do{
                //prepare query
                let query = self.SQLTextField.text
                let gett = try self.con.query(q: query!)
                //rows to wszystkie wiersze z query
                self.rows = try gett.readAllRows()
                //rowss to tez wszystkie wiersze z query XDD
                if(self.rows?.isEmpty==false){
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
                    self.performSegue(withIdentifier: "SQLshowViewTable", sender: self)
                }else{
                    print("Pusta tabela!")
                }
                self.stopAct()
            }catch(let e){
                print(e)
                self.stopAct()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.con = Connecion.instanceOfConnection.con!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SQLshowViewTable"){
            if let destination = segue.destination as? TableViewViewController{
                var rowss = self.rows?[0]
                destination.list = self.list2
                destination.numberRows = (rowss?.count)!
                destination.numberColumns = rowss![0].count
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
