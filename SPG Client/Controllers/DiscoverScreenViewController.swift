//
//  DiscoverScreenViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/7/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class DiscoverScreenViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet var sprayButton: UIButton!
    @IBOutlet var paintButton: UIButton!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    //MARK: - Variables
//    let dataSim : BusinessDataSim = BusinessDataSim()
    var sprayArray  = [UIImage]()
    var paintArray  = [UIImage]()
    var goArray     = [UIImage]()
    
    var selectedIndex : Int = Int()
    
    
    let spraySelectedAttributedTitle = NSAttributedString(string: "SPRAY",
                                                       attributes: [NSForegroundColorAttributeName : UIColor.purple])
    let sprayNormalAttributedTitle = NSAttributedString(string: "SPRAY",
                                                     attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
    let paintSelectedAttributedTitle = NSAttributedString(string: "PAINT",
                                                          attributes: [NSForegroundColorAttributeName : UIColor.purple])
    let paintNormalAttributedTitle = NSAttributedString(string: "PAINT",
                                                        attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
    let goSelectedAttributedTitle = NSAttributedString(string: "GO",
                                                          attributes: [NSForegroundColorAttributeName : UIColor.purple])
    let goNormalAttributedTitle = NSAttributedString(string: "GO",
                                                     attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
    var state : Int = Int()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sprayArray = dataSim.sprayArray
//        paintArray = dataSim.paintArray
//        goArray = dataSim.goArray
        
//        let storage = FIRStorage.storage().reference()
//        let tempImageRef = storage.child("image/png")
        
//        tempImageRef.data(withMaxSize: (1*1000*1000), completion:
//        {(data, error) in
//            if error == nil {
//                print(data!)
//            } else {
//                print((error?.localizedDescription)!)
//                print("Baloooza!")
//            }
//        })
        //SET SPRAY TO BE SELECTED
        sprayButton.setImage(UIImage(named: "icon_dis_spray_active"), for: .normal)
        paintButton.imageView?.image = UIImage(named: "icon_dis_paint")
        goButton.imageView?.image = UIImage(named: "icon_dis_go")
        
//        sprayButton.titleLabel?.textColor = UIColor.purple
//        paintButton.titleLabel?.textColor = UIColor.darkGray
//        goButton.titleLabel?.textColor = UIColor.darkGray
        
        
        state = 0; print("SPRAY")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        layout.itemSize = CGSize(width: screenWidth/2, height: 185)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func sprayButton_Click(_ sender: Any) {
        
        sprayButton.setImage(UIImage(named: "icon_dis_spray_active"), for: .normal)
        paintButton.imageView?.image = UIImage(named: "icon_dis_paint")
        goButton.imageView?.image = UIImage(named: "icon_dis_go")
        state = 0; print("SPRAY")
//        sprayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
//        sprayButton.titleLabel?.textColor = UIColor.purple
//        sprayButton.setAttributedTitle(spraySelectedAttributedTitle, for: .selected)
//        paintButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        goButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        collectionView.reloadData()
        
    }
    @IBAction func paintButton_Click(_ sender: Any) {
        sprayButton.setImage(UIImage(named: "icon_dis_spray"), for: .normal)
        paintButton.setImage(UIImage(named: "icon_dis_paint_active"), for: .normal)
        goButton.setImage(UIImage(named: "icon_dis_go"), for: .normal)

        state = 1; print("PAINT")
        collectionView.reloadData()
//        sprayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        paintButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
//        goButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
    
    }
    @IBAction func goButton_Click(_ sender: Any) {
        sprayButton.setImage(UIImage(named: "icon_dis_spray"), for: .normal)
        paintButton.setImage(UIImage(named: "icon_dis_paint"), for: .normal)
        goButton.setImage(UIImage(named: "icon_dis_go_active"), for: .normal)
        state = 2; print("GO")
        
        collectionView.reloadData()
        
//        sprayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        paintButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        goButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
    
    }
    
    
    //MARK: - Helper & Initialization Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(state){
        case 0:
            return sprayArray.count
        case 1:
            return paintArray.count
        case 2:
            return goArray.count
        default:
            break
        }
        return sprayArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverCollectionViewCell", for: indexPath) as! discoverCollectionViewCell
        switch(state){
        case 0:
            cell.imageView.image = sprayArray[indexPath.row]
            break
        case 1:
            cell.imageView.image = paintArray[indexPath.row]
            break
        case 2:
            cell.imageView.image = goArray[indexPath.row]
        default:
            break
        }
        cell.imageView.layer.masksToBounds = true//.borderWidth = 0.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showSinglePicture", sender: self)
    }
    //MARK: - Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if segue.identifier == "showSinglePicture" {
            let vc  = segue.destination as! PictureDisplayViewController
            switch(state){
            case 0:
                vc.imageToDisplay = sprayArray[selectedIndex]
                break
            case 1:
                vc.imageToDisplay = paintArray[selectedIndex]
                break
            case 2:
                vc.imageToDisplay = goArray[selectedIndex]
            default:
                break
            }
        }
    }
    
}
