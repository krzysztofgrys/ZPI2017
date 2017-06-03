//
//  InsertRowTableViewCell.swift
//  ZPI2017
//
//  Created by Łukasz on 04.06.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit

class InsertRowTableViewCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
