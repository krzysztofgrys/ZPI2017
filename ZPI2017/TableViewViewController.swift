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
    var numberColumns:Int = 1
    var pinchGesture = UIPinchGestureRecognizer()
    var itemWidth: CGFloat = 300.0
    var lastScale: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TableViewCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tekst = ""
        for dat in list{
            if(dat.row == indexPath.section-1 && dat.column == indexPath.row){
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
                case let tmpVal as Double:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as Date:
                    tekst+="\(tmpVal)"
                    break;
                default:
                    tekst+=String(describing: dat.value)
                    print("blad")
                }
            }
        }
        let alert = UIAlertController(title: tekst, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if(indexPath.section != 0){
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberColumns
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberRows+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableViewCollectionViewCell
        var tekst=""
        let indeks = indexPath.row
        let kolumna = indexPath.section
        let keyes = self.getKeyes()
        for dat in self.list{
            if(kolumna == 0){ tekst += keyes[indeks]; break;}
            else if(dat.row==kolumna-1 && dat.column==indeks){
                switch dat.value {
                case let tmpVal as Float:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as Double:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as String:
                    tekst+=tmpVal
                    break;
                case let tmpVal as Int:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as Date:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as TimeZone:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as Data:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as UInt16:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as UInt8:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as Int16:
                    tekst+="\(tmpVal)"
                    break;
                case let tmpVal as UInt8:
                    tekst+="\(tmpVal)"
                    break;
                default:
                    tekst+=String(describing: dat.value)
                    print("blad")
                }
            }
        }
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor.darkGray
            cell.values.textColor = UIColor.white
            
            
        } else {
            cell.backgroundColor = UIColor.white
            cell.values.textColor = UIColor.black
        }
        cell.values.text = tekst
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
    
    func getKeyes() -> [String]{
        var result = [String]()
        for dat in list {
            result.append(dat.key)
            if(result.count == numberColumns){ break;}
        }
        return result
    }

}

//class NodeLayout : UICollectionViewFlowLayout {
//    var itemWidth : CGFloat
//    var itemHeight : CGFloat
//    var space : CGFloat
//    var columns: Int{
//        return self.collectionView!.numberOfItems(inSection: 0)
//    }
//    var rows: Int{
//        return self.collectionView!.numberOfSections
//    }
//    
//    init(itemWidth: CGFloat, itemHeight: CGFloat, space: CGFloat) {
//        self.itemWidth = itemWidth
//        self.itemHeight = itemHeight
//        self.space = space
//        super.init()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        self.itemWidth = 50
//        self.itemHeight = 50
//        self.space = 3
//        super.init()
//    }
//    
//    override var collectionViewContentSize: CGSize{
//        let w : CGFloat = CGFloat(columns) * (itemWidth + space)
//        let h : CGFloat = CGFloat(rows) * (itemHeight + space)
//        return CGSize(width: w, height: h)
//    }
//    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        let x : CGFloat = CGFloat(indexPath.row) * (itemWidth + space)
//        let y : CGFloat = CGFloat(indexPath.section) + CGFloat(indexPath.section) * (itemHeight + space)
//        attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
//        return attributes
//    }
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let minRow : Int = (rect.origin.x > 0) ? Int(floor(rect.origin.x/(itemWidth + space))) : 0
//        let maxRow : Int = min(columns - 1, Int(ceil(rect.size.width / (itemWidth + space)) + CGFloat(minRow)))
//        var attributes : Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
//        for i in 0 ..< rows {
//            for j in minRow ... maxRow {
//                attributes.append(self.layoutAttributesForItem(at: IndexPath(item: j, section: i))!)
//            }
//        }
//        return attributes
//    }
//}


