//
//  SelectLookBookCell.swift
//  SPG Client
//
//  Created by Dharmik Ghelani on 15/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class SelectLookBookCell: UITableViewCell {

    @IBOutlet weak var lblLookbookName: UILabel!
    @IBOutlet weak var lblNoofPhotos: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
