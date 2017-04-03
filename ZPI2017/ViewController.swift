//
//  ViewController.swift
//  MySQLSampleiOS
//
//  Created by cipi on 25/12/15.
//
//

import UIKit
import MySqlSwiftNative


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let con = MySQL.Connection()
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var FavLastSwitcher: UISegmentedControl!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var pickerControll: UISegmentedControl!
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var portField: UITextField!
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LastTableViewCell
        if(FavLastSwitcher.selectedSegmentIndex==0){
            cell.LastCell.text = "ulubione"
        }else{
            cell.LastCell.text = "ostatnie"
        }
            return cell
    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    
    public func switcherChange(){
        if FavLastSwitcher.selectedSegmentIndex==0 {
         TableView.reloadData()
//            DispatchQueue.main.async{
//                self.TableView.reloadData()
//            
//            }
        }else{
            TableView.reloadData()
        }
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    public func connect(){
        if validateFields(){
            do{
                try con.open(ipField.text!, user: userField.text!, passwd: passwordField.text)
                let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "databaseSelection") as! DatabaseSelectionTableViewController
                destination.con = self.con
                navigationController?.pushViewController(destination, animated: true)
            }catch(let e){
                print(e)
                showAlert(message: "Nie mozna polaczyc sie z baza danych")
            }
        }
    }
    
    
    public func validateFields() -> Bool{
        if(ipField.text == "" || ipField.text == nil){
            showAlert(message: "Ip nie moze byc puste")
            return false
        }
        if(userField.text == "" || userField.text == nil){
            showAlert(message: "User nie moze byc puste")
            return false
        }
        if(passwordField.text == "" || passwordField.text == nil){
            showAlert(message: "Password nie moze byc puste")
            return false
        }
        if(port.text == "" || port.text == nil){
            showAlert(message: "Port nie moze byc pusty")
            return false
        }
        return true
    }
    
    
    override func viewDidLoad() {
    
        FavLastSwitcher.addTarget(self, action: #selector(switcherChange), for: .valueChanged)
        
        login.addTarget(self, action: #selector(connect), for: .touchDown)
        
        super.viewDidLoad()
        port.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.touchDown)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        port.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

