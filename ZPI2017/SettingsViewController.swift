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
    
    @IBAction func addToFavButton(_ sender: Any) {
        saveCredentials()
    }
    @IBAction func logoutButton(_ sender: Any) {
        
        // TO NIE DZIALA TO TYLKO DO TESTOW ULUBIONYCH
        let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainLoginPage") as! ViewController
            self.navigationController?.pushViewController(destination, animated: true)
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
            tmp = []
            for favv in 0..<(unarchiveProfile.count){
                let read = unarchiveProfile[favv]
                    tmp.append(read)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCredentials()

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
