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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.desiredLookArray = [Dictionary<String, String>]()
        
        setTextAndImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myCollectionView.reloadData()
    }
    
    //MARK: - Helper Methods
    
    func setTextAndImage() {
        if appDelegate.selfieImage != #imageLiteral(resourceName: "userpic") {
            imgSelfie.image = appDelegate.selfieImage
        }
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnNext_Click(_ sender: Any) {
        self.performSegue(withIdentifier: StylistSegue.reviewSegue, sender: self)
    }
    
    @IBAction func btnSelectImage_Click(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "MyLookBookVC") as! UINavigationController
        let lookbookVC = nav.viewControllers[0] as! MyLookBookVC
        lookbookVC.isChoosImage = true
        lookbookVC.delegate = self
        self.present(nav, animated: true, completion: nil)
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
            appDelegate.appointmentNotes = txtNotes.text!
        }
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension AdditionalInfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if appDelegate.desiredLookArray.count > 0 {
            return appDelegate.desiredLookArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if appDelegate.desiredLookArray.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DesiredLookCell
            
            if appDelegate.desiredLookArray.count > 0 {
                
                let dict = appDelegate.desiredLookArray[indexPath.row]
                
                let url = ImageDirectory.lookBookDir + "\(dict["lookbook_image_name"]!)"
                Utils.downloadImage(url, imageView: cell.desiredLookImage)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotAvailableCell", for: indexPath)
            
            return cell
        }
    }
}

//MARK - MyLookBookVCDelegate 

extension AdditionalInfoVC : MyLookBookDelegate {
    func didUpdateDesiredLook() {
        myCollectionView.reloadData()
    }
}
