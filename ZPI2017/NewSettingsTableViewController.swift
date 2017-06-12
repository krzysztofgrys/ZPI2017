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
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBOutlet weak var sysDBSwitch: UISwitch!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var cellWidthTextField: UITextField!
    @IBOutlet weak var fontSize: UITextField!
    @IBAction func fontSizeAction(_ sender: Any) {
        Connecion.instanceOfConnection.fontSize = CGFloat((fontSize.text! as NSString).floatValue)
    }
    @IBAction func touchIDSwitchAction(_ sender: Any) {
        userDefults.set(touchIDSwitch.isOn, forKey: "touchId")
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
        showAlert(message: "Usunięto wszystkie ostatnie logowania!", type: "Informacja")
    }
    @IBAction func removeFavourities(_ sender: Any) {
        var new: [LastFav] = []
        for cred in 0..<(tmp.count){
            let read = tmp[cred]
            if(read.type=="last"){
                new.append(read)
            }
        }
        tmp = new
        saveCred()
        showAlert(message: "Usunięto wszystkie ulubione!", type: "Informacja")
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
        let cellWidth = String(format: "%.2f", Double(Connecion.instanceOfConnection.cellWidth))
        cellWidthTextField.text = cellWidth
        let fontSizetmp = String(format: "%.2f", Double(Connecion.instanceOfConnection.fontSize))
        fontSize.text = fontSizetmp
        touchIDSwitch.setOn(userDefults.bool(forKey: "touchId"), animated: true)
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "5FC3DA")
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
    
    func showAlert(message: String, type: String){
        let alertController = UIAlertController(title: type, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
   }
