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
    
    var con = MySQL.Connection()
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var list = [DataModel]()
    var list2 = [DataModel]()
    
    
    @IBOutlet weak var tokenView: KSTokenView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.con = Connecion.instanceOfConnection.con!

        dictionaryD = getDatabases()
        
        tokenView.delegate = self
        tokenView.promptText = "Top: "
        tokenView.placeholder = "Type to search"
        tokenView.descriptionText = "Languages"
        tokenView.maxTokenLimit = -1
        tokenView.minimumCharactersToSearch = 1
        tokenView.style = .squared
        tokenView.direction = .vertical
        tokenView.editable = true
        tokenView.shouldDisplayAlreadyTokenized = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func getDatabases()->Array<String>{
        var list = [DataModel]()
        var databases: Array<String> = []
        do{
            let gett = try con.query(q: "SHOW DATABASES")
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
        var tables: Array<String> = []
        
        return tables
    }
}


extension newExecuteViewController: KSTokenViewDelegate {
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(dictionary as Array<AnyObject>)
            return
        }
        
        var data: Array<String> = []
        dictionaryT = newExecuteViewController.getTables()
        if((string.range(of: "@t")) != nil){
            for value: String in dictionaryT {
                if value.lowercased().range(of: string.lowercased()) != nil {
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
