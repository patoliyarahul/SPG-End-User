//
//  ChatListCell.swift
//  SPG Stylist
//
//  Created by Dharmesh Vaghani on 07/02/17.
//  Copyright © 2017 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
