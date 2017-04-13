//
//  TableViewViewController.swift
//  ZPI2017
//
//  Created by Łukasz on 13.04.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative

class TableViewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var con = MySQL.Connection()
    var rows: [MySQL.ResultSet]? = nil
    var rowss: MySQL.ResultSet? = nil
    var list = [DataModel]()
    var dbName = String()
    var tableName = String()
    var numberRows:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self 
        do{
            let query = "SELECT * FROM " + tableName
            //prepare query
            let gett = try con.query(q: query)
            //rows to wszystkie wiersze z query
            rows = try gett.readAllRows()
            //rowss to tez wszystkie wiersze z query XDD
            rowss = rows?[0]
            // row to jeden wiersz z query
            var ii:Int = 1
            for row in rowss!{
                for(key,value) in row{
                    list.append(DataModel(k: key, v: value, r: ii))
                }
                ii += 1
            }
            
        }catch(let e){
            print(e)
        }
        numberRows = (rowss?.count)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberRows
    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return ii
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableViewCollectionViewCell
        var label = UILabel()
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
        cell.values.text = tekst
        return cell
    }

}
