//
//  AppointmentServiceCell.swift
//  SPG Stylist
//
//  Created by Dharmesh Vaghani on 14/12/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class AppointmentServiceCell: UITableViewCell {

    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
