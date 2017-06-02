//
//  AddTableTableViewCell.swift
//  ZPI2017
//
//  Created by Łukasz on 01.06.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit

class AddTableTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerData = ["int","String","double"]
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dataType: UIPickerView!
    @IBOutlet weak var nullCheckBox: UIButton!
    @IBOutlet weak var uniqueCheckBox: UIButton!
    @IBOutlet weak var primaryKeyCheckBox: UIButton!
    @IBOutlet weak var length: UITextField!
    @IBAction func nullButtonAction(_ sender: Any) {
        if(nullCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            nullCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        }else{
            nullCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
        }
    }
    @IBAction func uniqueButtonAction(_ sender: Any) {
        if(uniqueCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            uniqueCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        }else{
            uniqueCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
        }
    }
    @IBAction func primaryKeyButtonAction(_ sender: Any) {
        if(Connecion.instanceOfConnection.primaryButton){
            Connecion.instanceOfConnection.primaryButton = false
        if(primaryKeyCheckBox.currentImage! == UIImage(named: "checked_checkbox.png")!){
            primaryKeyCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
        }else{
            primaryKeyCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
            }
        }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataType.delegate = self
        self.dataType.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
