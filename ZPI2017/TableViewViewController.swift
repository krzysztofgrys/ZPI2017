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
        
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self 
        // Do any additional setup after loading the view.
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized))
        self.collectionView.minimumZoomScale = 1.0
        self.collectionView.maximumZoomScale = 10.0
        self.collectionView.addGestureRecognizer(pinchGesture)
        
        self.collectionView!.collectionViewLayout = NodeLayout(itemWidth: itemWidth, itemHeight: 50.0, space: 5.0)
    }

    func pinchRecognized(gesture: UIPinchGestureRecognizer) {
        itemWidth = self.itemWidth*(gesture.scale/100)
        self.collectionView.collectionViewLayout = NodeLayout.init(itemWidth: itemWidth, itemHeight: 50.0, space: 5.0)
        print(itemWidth)
        collectionView.reloadData()
        
        if(gesture.state == .began) {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = gesture.scale
        }
        if (gesture.state == .began || gesture.state == .changed) {
            let currentScale = gesture.view!.layer.value(forKeyPath:"transform.scale")! as! CGFloat
            // Constants to adjust the max/min values of zoom
            let kMaxScale:CGFloat = 2.0
            let kMinScale:CGFloat = 1.0
            var newScale = 1 -  (lastScale - gesture.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = (gesture.view?.transform)!.scaledBy(x: newScale, y: newScale)
            gesture.view?.transform = transform
            lastScale = gesture.scale
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberColumns
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableViewCollectionViewCell
        var tekst=""
        let indeks = indexPath.row
        let kolumna = indexPath.section
//        print("indeks:")
//        print(indeks)
//        print("kolumna")
//        print(kolumna)
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


