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
            var ii:Int = 0
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
        numberRows = (rowss?.count)!
        // Do any additional setup after loading the view.
        self.collectionView!.collectionViewLayout = NodeLayout(itemWidth: 300.0, itemHeight: 50.0, space: 5.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowss![0].count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableViewCollectionViewCell
        var tekst=""
        let indeks = indexPath.row
        let kolumna = indexPath.section
        print("indeks:")
        print(indeks)
        print("kolumna")
        print(kolumna)
        for dat in list{
            if(dat.row==kolumna && dat.column==indeks){
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

class NodeLayout : UICollectionViewFlowLayout {
    var itemWidth : CGFloat
    var itemHeight : CGFloat
    var space : CGFloat
    var columns: Int{
        return self.collectionView!.numberOfItems(inSection: 0)
    }
    var rows: Int{
        return self.collectionView!.numberOfSections
    }
    
    init(itemWidth: CGFloat, itemHeight: CGFloat, space: CGFloat) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.space = space
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.itemWidth = 50
        self.itemHeight = 50
        self.space = 3
        super.init()
    }
    
    override var collectionViewContentSize: CGSize{
        let w : CGFloat = CGFloat(columns) * (itemWidth + space)
        let h : CGFloat = CGFloat(rows) * (itemHeight + space)
        return CGSize(width: w, height: h)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x : CGFloat = CGFloat(indexPath.row) * (itemWidth + space)
        let y : CGFloat = CGFloat(indexPath.section) + CGFloat(indexPath.section) * (itemHeight + space)
        attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let minRow : Int = (rect.origin.x > 0) ? Int(floor(rect.origin.x/(itemWidth + space))) : 0
        let maxRow : Int = min(columns - 1, Int(ceil(rect.size.width / (itemWidth + space)) + CGFloat(minRow)))
        var attributes : Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< rows {
            for j in minRow ... maxRow {
                attributes.append(self.layoutAttributesForItem(at: IndexPath(item: j, section: i))!)
            }
        }
        return attributes
    }
}


