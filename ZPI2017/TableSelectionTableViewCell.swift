//
//  TableSelectionTableViewCell.swift
//  ZPI2017
//
//  Created by Łukasz on 07.04.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import UIKit

class TableSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var table: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
