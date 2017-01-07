//
//  LookbookDisplayViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/8/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class LookbookDisplayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    
    var sprayArray = [UIImage]()
    var selectedIndex : Int = Int()
    var lookbookTitle : String = ""
    @IBOutlet var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navBar.topItem?.title = lookbookTitle
        
        let font = UIFont(name: "Gotham Book", size: 13)!
        backButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        deleteButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
//        sprayArray = dataSim.sprayArray
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        layout.itemSize = CGSize(width: screenWidth/2, height: 185)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sprayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lookbookDisplayCollectionViewCell", for: indexPath) as! lookbookDisplayCollectionViewCell
        
            cell.imageView.image = sprayArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "displayLookbookPicture", sender: self)
    }
    @IBAction func backButton_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteButton_Click(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Lookbook", message: "You will lose all of the images saved.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) -> Void in
//            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            (action) -> Void in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayLookbookPicture" {
            let vc = segue.destination as! LookbookPictureDisplayViewController
            vc.imageToDisplay = sprayArray[selectedIndex]
            
        }
    }
}
