//
//  AddTableViewController.swift
//  ZPI2017
//
//  Created by Łukasz on 01.06.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit
import MySqlSwiftNative

class AddTableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerData = ["int","char","varchar","double","float","date"]
    var primaryKey = ""
    var attributes = [String]()
    
    @IBOutlet weak var queryLabel: UITextView!
    @IBOutlet weak var columnName: UITextField!
    @IBOutlet weak var dataTypePicker: UIPickerView!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var primaryCheckBox: UIButton!
    @IBOutlet weak var uniqueCheckBox: UIButton!
    @IBOutlet weak var nullCheckBox: UIButton!
    @IBAction func nameOfTableAction(_ sender: Any) {
        queryLabel.text = "CREATE TABLE " + deleteSpaces(txt: nameOfNewTable.text!) + "( "
    }
    @IBAction func addAttributeAction(_ sender: Any) {
        var query = ""
        let pickerIndex = dataTypePicker.selectedRow(inComponent: 0)
        query += deleteSpaces(txt: columnName.text!)
        query += " " + pickerData[pickerIndex]
        if(pickerIndex == 1 || pickerIndex == 2){
            query += "(" + deleteSpaces(txt: length.text) + ")"
        }
        if(nullCheckBox.currentImage! == UIImage(named: "unchecked_checkbox.png")!){
            query += " NOT NULL"
        }
        if(uniqueCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            query += " UNIQUE"
        }
        if(primaryCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            primaryKey = ",PRIMARY KEY(" + deleteSpaces(txt: columnName.text!) + ")"
        }
        attributes.append(query)
        appendAttributes()
        resetInputs()
    }
    @IBAction func primaryCheckBoxAction(_ sender: Any) {
        if(Connecion.instanceOfConnection.primaryButton){
            Connecion.instanceOfConnection.primaryButton = false
            if(primaryCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
                primaryCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
            }else{
                primaryCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
            }
        }
    }
    @IBAction func uniqueCheckBoxAction(_ sender: Any) {
        if(uniqueCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            uniqueCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        }else{
            uniqueCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
        }
    }
    @IBAction func nullCheckBoxAction(_ sender: Any) {
        if(nullCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            nullCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        }else{
            nullCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
        }
    }
    
    @IBOutlet weak var nameOfNewTable: UITextField!
    @IBOutlet weak var act: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.queryLabel.text = "CREATE TABLE ("
        Connecion.instanceOfConnection.primaryButton = true
        self.dataTypePicker.delegate = self
        self.dataTypePicker.dataSource = self
    }
    @IBAction func addTableAction(_ sender: Any) {
        let con = Connecion.instanceOfConnection.con
        do{
            let tmp = queryLabel.text!
            let _ = try con?.query(q: tmp)
            _ = self.navigationController?.popViewController(animated: true)
        }catch(let e){
            print(e)
            print("Blad dodania tabeli")
            print(queryLabel.text!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appendAttributes(){
        var tmpQuery = "CREATE TABLE " + deleteSpaces(txt: nameOfNewTable.text!) + "( "
        for attribute in attributes{
            tmpQuery += attribute + ","
        }
        tmpQuery.remove(at: tmpQuery.index(before: tmpQuery.endIndex))
        tmpQuery += primaryKey
        tmpQuery += " );"
        queryLabel.text = tmpQuery
    }
    
    func resetInputs(){
        primaryCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        uniqueCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        nullCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        columnName.text = ""
        length.text = ""
        dataTypePicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 1 || row == 2){
            self.length.isEnabled = true
        }else{
            self.length.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func startAct(){
        self.view.superview?.bringSubview(toFront: self.act)
        self.act.startAnimating()
        self.act.isHidden = false
    }
    
    func stopAct(){
        DispatchQueue.main.async {
            self.act.stopAnimating()
        }
    }
    
    func deleteSpaces(txt: String!) -> String!{
        var txtTmp = txt!
        txtTmp = txtTmp.replacingOccurrences(of: " ", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: ",", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: ".", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "@", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "!", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "?", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "/", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "#", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "@", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "$", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "%", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "^", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "(", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: ")", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "+", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "=", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "-", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: "<", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: ">", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: ":", with: "")
        txtTmp = txtTmp.replacingOccurrences(of: ";", with: "")
        return txtTmp
    }

}
