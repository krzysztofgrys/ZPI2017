//
//  NewSettingsTableViewController.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 6/3/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit

class NewSettingsTableViewController: UITableViewController {

    var tmp: [LastFav] = []
    let userDefults = UserDefaults.standard
    
    @IBOutlet weak var sysDBSwitch: UISwitch!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var cellWidthTextField: UITextField!
    @IBOutlet weak var fontSize: UITextField!
    @IBAction func fontSizeAction(_ sender: Any) {
        Connecion.instanceOfConnection.fontSize = CGFloat((fontSize.text! as NSString).floatValue)
    }
    @IBAction func removeLastCredentailsList(_ sender: Any) {
        var new: [LastFav] = []
        for cred in 0..<(tmp.count){
            let read = tmp[cred]
            if(read.type=="fav"){
                new.append(read)
            }
        }
        tmp = new
        saveCred()
        
    }
    @IBAction func removeFavouritiesCredentialsList(_ sender: Any) {
        var new: [LastFav] = []
        for cred in 0..<(tmp.count){
            let read = tmp[cred]
            if(read.type=="last"){
                new.append(read)
            }
        }
        
        tmp = new
        saveCred()
    }
    
    @IBAction func addToFavButton(_ sender: Any) {
        saveCredentials()
    }
    @IBAction func sysDBSwitchAction(_ sender: Any) {
        userDefults.set(sysDBSwitch.isOn, forKey: "sysDB")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCredentials()
        checkIfFavExist()
        sysDBSwitch.setOn(userDefults.bool(forKey: "sysDB"), animated: true)
        let cellWidth = String(format: "%.3f", Double(Connecion.instanceOfConnection.cellWidth))
        cellWidthTextField.text = cellWidth

        
        
//        let view1: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 360, height: 150));
//        view1.backgroundColor = UIColor.init(red: 95/255, green: 195/255, blue: 218/255, alpha: 1)
//        let label: UILabel = UILabel()
//
//    
//        
//        label.text = "ZPI 2017"
//        label.center = view1.center
//        label.sizeToFit()
//        label.textAlignment = NSTextAlignment.center
//        
//        
//        let image = UIImageView()
//        image.image = UIImage(named: "icons.png")
//        let imageAspect = image.image!.size.width/image.image!.size.height
//        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect,y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
//        image.contentMode = UIViewContentMode.scaleAspectFit
//        
//        view1.addSubview(label);
//        view1.addSubview(image)
////        tableView.backgroundColor = UIColor.init(red: 78/255, green: 188/255, blue: 212/255, alpha: 1)
//        
//        
//        self.tableView.tableHeaderView = view1;
        
    }
    
   
    @IBAction func logOutAction(_ sender: Any) {
        let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainLoginPage") as! ViewController
        do{
            try Connecion.instanceOfConnection.con?.close()
        }
        catch(_){
            print("blad zkaonczenia polaczenia")
        }
        self.present(destination, animated: true, completion: nil)
    }
    @IBAction func sysDBAction(_ sender: Any) {
        userDefults.set(sysDBSwitch.isOn, forKey: "sysDB")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Connecion.instanceOfConnection.cellWidth = CGFloat((cellWidthTextField.text! as NSString).floatValue)
    }
    
    func checkIfFavExist() -> Bool{
        for favv in 0..<(tmp.count){
            let read = tmp[favv]
            if(read.ip == CredentialsTmp.CredentialIp.ip && CredentialsTmp.CredentialUser.user == read.user && read.type=="fav"){
                favButton.isHidden  = true
                return true
            }
        }
        return false
    }
    
    func saveCred(){
        let filename = NSHomeDirectory().appending("/Documents/profile.bin")
        NSKeyedArchiver.archiveRootObject(tmp, toFile: filename)
    }
    
    func saveCredentials(){
        let credentials = tmp+[(LastFav(ip: CredentialsTmp.CredentialIp.ip, user: CredentialsTmp.CredentialUser.user, password: CredentialsTmp.CredentialPassword.password, port: CredentialsTmp.CredentialPort.port, type: "fav"))]
        let filename = NSHomeDirectory().appending("/Documents/profile.bin")
        NSKeyedArchiver.archiveRootObject(credentials, toFile: filename)
        print("zapisano Ulubione")
    }
    
    func getCredentials(){
        if let data = NSData(contentsOfFile: NSHomeDirectory().appending("/Documents/profile.bin")){
            let unarchiveProfile = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LastFav]
            print("odczytano")
            for favv in 0..<(unarchiveProfile.count){
                let read = unarchiveProfile[favv]
                tmp.append(read)
            }
        }
    }

    
    public func FavouritesDatabases()
    {
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
   }
