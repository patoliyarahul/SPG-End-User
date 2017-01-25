//
//  GalleryViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 06/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var lblStylistName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var myCollectionVieww: UICollectionView!
    
    //MARK: - Variables
    
    var galleryImgaeArray = [Dictionary<String, String>]()
    
    var profession          =   ""
    var stylistName         =   ""
    var logoUrl             =   ""
    
    var selectedIndex = IndexPath(row: 0, section: 0)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helper Methods
    
    func setText() {
        lblStylistName.text =   stylistName
        lblProfession.text  =   profession
        Utils.downloadImage(logoUrl, imageView: imgLogo)
    }
    
    //MARK: - UIButton Action Methods
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DiscoverSegue.imageDetailSegue {
            let dv = segue.destination as! DiscoverImageVC
            dv.dict = galleryImgaeArray[selectedIndex.row] as Dictionary<String, String>
        }
    }
}


//MARK: - UICollectionView Delegate & Datasource Methods

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if galleryImgaeArray.count > 0 {
            return galleryImgaeArray.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if galleryImgaeArray.count > 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DesiredLookCell
            
            if galleryImgaeArray.count > 0 {
                
                let dict = galleryImgaeArray[indexPath.row]
                
                let url = ImageDirectory.gallaryDir + "\(dict["gallery_image_name"]!)"
                Utils.downloadImage(url, imageView: cell.desiredLookImage)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotAvailableCell", for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if galleryImgaeArray.count > 0 {
            selectedIndex = indexPath
            self.performSegue(withIdentifier: DiscoverSegue.imageDetailSegue, sender: self)
        }
    }
}

