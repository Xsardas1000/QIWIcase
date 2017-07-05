//
//  histTableViewCell.swift
//  MessengerQIWI
//
//  Created by Максим on 04.07.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit

class histTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var amountMoney: UILabel!

    @IBOutlet weak var date: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
