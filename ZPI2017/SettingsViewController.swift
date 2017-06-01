//
//  SettingsViewController.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 5/26/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var tmp: [LastFav] = []
    let userDefults = UserDefaults.standard
    
    @IBOutlet weak var sysDBSwitch: UISwitch!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var cellWidthTextField: UITextField!
    @IBAction func addToFavButton(_ sender: Any) {
        saveCredentials()
    }
    @IBAction func logOutButtonAction(_ sender: Any) {
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
        let n = NumberFormatter().number(from: cellWidthTextField.text!)
        Connecion.instanceOfConnection.cellWidth = CGFloat(n!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCredentials()
        checkIfFavExist()
        sysDBSwitch.setOn(userDefults.bool(forKey: "sysDB"), animated: true)
        let cellWidth = String(format: "%.3f", Double(Connecion.instanceOfConnection.cellWidth))
        cellWidthTextField.text = cellWidth
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func FavouritesDatabases()
    {
        
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
