//
//  PictureDisplayViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/19/16.
//  Copyright © 2016 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class PictureDisplayViewController : UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var imageView: UIImageView!
    var imageToDisplay : UIImage = UIImage()
    
    
    //MARK: - Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageToDisplay
    }
    @IBAction func backToDiscover_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Memeory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
