//
//  newExecuteViewController.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 6/4/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import KSTokenView
import MySqlSwiftNative
class newExecuteViewController: UIViewController {
    let dictionary: Array<String> = Dict.sqlCommon()
    var dictionaryT: Array<String> = []
    var dictionaryD: Array<String> = []
    
    @IBOutlet weak var act: UIActivityIndicatorView!
    static var con = MySQL.Connection()
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var list = [DataModel]()
    var list2 = [DataModel]()
    
    @IBAction func executeSqlAction(_ sender: Any) {
        startAct()
        let query:String = tokenView.text
        
        DispatchQueue.main.async {
            self.list2.removeAll()
            do{
                let gett = try  Connecion.instanceOfConnection.con!.query(q: query)
                //rows to wszystkie wiersze z query
                self.rows = try gett.readAllRows()
                //rowss to tez wszystkie wiersze z query XDD
                if(self.rows?.isEmpty==false){
                    var list = [DataModel]()
                    //rowss to tez wszystkie wiersze z query
                    let rowss = self.rows?[0]
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
                    self.performSegue(withIdentifier: "SQLshowViewTable1", sender: self)
                }else{
                    print("Pusta tabela!")
                    self.showAlert(message: "Operacja wykonana poprawnie!",type: "Sukces")
                }
                self.stopAct()
            }catch(let e){
                print(e)
                self.showAlert(message: "Blad wykonania operacji!",type: "Błąd")
                self.stopAct()
            }
        }
    }
    
    @IBOutlet weak var tokenView: KSTokenView!
    override func viewDidLoad() {
        super.viewDidLoad()
        newExecuteViewController.con = Connecion.instanceOfConnection.con!

        dictionaryD = getDatabases()
        
        tokenView.delegate = self
        tokenView.promptText = ""
        tokenView.placeholder = "Wpisz zapytanie"
        tokenView.descriptionText = "Languages"
        tokenView.maxTokenLimit = -1
        tokenView.minimumCharactersToSearch = 1
        tokenView.style = .squared
        tokenView.direction = .vertical
        tokenView.editable = true
        tokenView.separatorText = " "
        tokenView.shouldDisplayAlreadyTokenized = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
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
    
    func getDatabases()->Array<String>{
        var list = [DataModel]()
        var databases: Array<String> = []
        do{
            let gett = try newExecuteViewController.con.query(q: "SHOW DATABASES")
            rows = try gett.readAllRows()
            rowss = rows?[0]
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
        }catch(let e){
            print(e)
        }
        
        print(list.count)
        
        for index in 0..<list.count {
            databases.append(list[index].value as! String)
            print(list[index].value)
        }
        
        return databases
        
    }
    
    
    static func getTables()->Array<String>{
        var rows: [MySQL.ResultSet]? = nil
        var rowss: MySQL.ResultSet? = nil
        var list = [DataModel]()
        var tables: Array<String> = []
        do{
            try newExecuteViewController.con.use(dbname: ExecuteSQLHelper.database.database)
            let gett = try con.query(q: "SHOW TABLES")
            rows = try gett.readAllRows()
            rowss = rows?[0]
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
        }catch(let e){
            print(e)
        }
        
        
        for index in 0..<list.count {
            tables.append(list[index].value as! String)
        }

        return tables
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SQLshowViewTable1"){
            if let destination = segue.destination as? TableViewViewController{
                var rowss = self.rows?[0]
                destination.list = self.list2
                destination.numberRows = (rowss?.count)!
                destination.numberColumns = rowss![0].count
            }
        }
    }
    
    func showAlert(message: String, type: String){
    let alertController = UIAlertController(title: type, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
{
    (result : UIAlertAction) -> Void in
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
    }
    
}


extension newExecuteViewController: KSTokenViewDelegate {
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(dictionary as Array<AnyObject>)
            return
        }
        
        var data: Array<String> = []
        if((string.range(of: "@t")) != nil){
            dictionaryT = newExecuteViewController.getTables()
            var newString = string.substring(from: 2)

            for value: String in dictionaryT {
                if value.lowercased().range(of: newString.lowercased()) != nil {
                    data.append(value)
                }
            }
        }else  if((string.range(of: "@d")) != nil){
            var newString = string.substring(from: 2)
            
            if(newString.characters.count > 0){
                for value: String in dictionaryD {
                    if value.lowercased().range(of: newString.lowercased()) != nil {
                        data.append(value)
                    }
                }
            }
        }else {
            for value: String in dictionary {
                if value.lowercased().range(of: string.lowercased()) != nil {
                    data.append(value)
                }
            }

        }

        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        ExecuteSQLHelper.database.database = object as! String
        return object as! String
    }
    
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
