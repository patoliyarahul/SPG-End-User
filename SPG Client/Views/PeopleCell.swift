//
//  PeopleCell.swift
//  SPG Stylist
//
//  Created by Dharmesh Vaghani on 20/02/17.
//  Copyright © 2017 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    @IBOutlet weak var profilePIc: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
