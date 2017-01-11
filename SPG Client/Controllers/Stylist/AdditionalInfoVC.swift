//
//  AdditionalInfoVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 10/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class AdditionalInfoVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var imgSelfie: UIImageView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var txtNotes: UITextField!
    
    //MARK: - Variables
    
    var desiredLookArray    =   [Dictionary<String, String>]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Methods
    
    func setTextAndImage() {
        
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnNext_Click(_ sender: Any) {
        self.performSegue(withIdentifier: StylistSegue.reviewSegue, sender: self)
    }
    
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StylistSegue.reviewSegue {
            
        }
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension AdditionalInfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if desiredLookArray.count > 0 {
            return desiredLookArray.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if desiredLookArray.count > 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DesiredLookCell
            
            if desiredLookArray.count > 0 {
                
                let dict = desiredLookArray[indexPath.row]
                
                let url = ImageDirectory.gallaryDir + "\(dict["gallery_image_name"]!)"
                Utils.downloadImage(url, imageView: cell.desiredLookImage)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotAvailableCell", for: indexPath)
            
            return cell
        }
    }
}
