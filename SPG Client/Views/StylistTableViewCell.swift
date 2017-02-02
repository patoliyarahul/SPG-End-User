//
//  StylistTableViewCell.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 05/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class StylistTableViewCell: UITableViewCell {

    @IBOutlet weak var lblStylistname: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
