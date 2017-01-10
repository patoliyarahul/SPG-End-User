//
//  StylistProfileVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 06/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class StylistProfileVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblStylistName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var chooseDateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chooseDateView: UIView!
    
    //MARK: - Variables
    var detailsDict         = Dictionary<String, Any>()
    var serviceArray        = [Dictionary<String, String>]()
    var desiredLookArray    = [Dictionary<String, String>]()
    
    var selectedServiceArray    =   [Dictionary<String, String>]()
    
    var logoUrl             =   ""
    var bannerUrl           =   ""
    
    let chooseDateViewHeightValue    =   90
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(myTableView)
        setText()
    }
    
    //MARK: - Helper Methods
    
    func setText() {
        if detailsDict[StylistListParams.bannerPhoto] != nil {
            bannerUrl = ImageDirectory.bannerDir + "\(detailsDict[StylistListParams.bannerPhoto]!)"
            Utils.downloadImage(bannerUrl, imageView: imgBanner)
        }
        
        if detailsDict[StylistListParams.logoImage] != nil {
            logoUrl = ImageDirectory.logoDir + "\(detailsDict[StylistListParams.logoImage]!)"
            Utils.downloadImage(logoUrl, imageView: imgLogo)
        }
        
        lblStylistName.text = "\(detailsDict[StylistListParams.firtName]!) \(detailsDict[StylistListParams.lastName]!)"
        lblProfession.text  = "\(detailsDict[StylistListParams.profession]!)"
        lblAddress.text     = "\(detailsDict["business_street_address"]! as! String) \(detailsDict["business_suit"]! as! String), \(detailsDict["business_city"]! as! String) \(detailsDict["business_state"]! as! String) \(detailsDict["business_zipcode"]! as! String)"
        
        if let serviceArrayTemp = detailsDict[StylistListParams.services] as? [Dictionary<String, String>] {
            serviceArray = serviceArrayTemp
        }
        
        if let desiredLookArrayTemp = detailsDict[StylistListParams.recentWork] as? [Dictionary<String, String>] {
            desiredLookArray = desiredLookArrayTemp
        }
        
        if serviceArray.count > 3 {
            myTableViewHeight.constant = CGFloat(3 * 74)
        } else if serviceArray.count > 0 {
            myTableViewHeight.constant = CGFloat(serviceArray.count * 74)
        } else {
            myTableViewHeight.constant = CGFloat(74)
        }
        
        myTableView.reloadData()
        myCollectionView.reloadData()
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnFollow_Click(_ sender: Any) {
        
    }
    
    @IBAction func btnViewAllRecentWork_Click(_ sender: Any) {
        if desiredLookArray.count > 0 {
            performSegue(withIdentifier: StylistSegue.showAllGalleryImageSegue, sender: self)
        } else {
            Utils.showToastMessage("No Recent Work Available")
        }
    }
    
    @IBAction func btnMessage_Click(_ sender: Any) {
        
    }
    
    @IBAction func btnViewAll_Services(_ sender: Any) {
        if serviceArray.count > 0 {
            performSegue(withIdentifier: StylistSegue.showAllServicesSegue, sender: self)
        } else {
            Utils.showToastMessage("No Service Available")
        }
    }
    
    @IBAction func btnChooseDate_Click(_ sender: Any) {
        self.performSegue(withIdentifier: StylistSegue.chooseDateSegue, sender: self)
    }
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StylistSegue.showAllServicesSegue {
            let dv = segue.destination as! ServicesListVC
            dv.serviceArray = serviceArray
            dv.stylistName          =   lblStylistName.text!
            dv.profession           =   lblProfession.text!
            dv.logoUrl              =   logoUrl
            dv.selectedServiceArray = selectedServiceArray
        } else if segue.identifier == StylistSegue.showAllGalleryImageSegue {
            let dv = segue.destination as! GalleryViewController
            dv.galleryImgaeArray    =   desiredLookArray
            dv.stylistName          =   lblStylistName.text!
            dv.profession           =   lblProfession.text!
            dv.logoUrl              =   logoUrl
        } else if segue.identifier == StylistSegue.chooseDateSegue {
            let dv = segue.destination as! SelectDateVC
            dv.stylistName          =   lblStylistName.text!
            dv.profession           =   lblProfession.text!
            dv.logoUrl              =   logoUrl
        }
    }
}

//MARK: - UITableVeiw Delegate & Datasource Methods

extension StylistProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if serviceArray.count > 3 {
            return 3
        } else if serviceArray.count > 0 {
            return serviceArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if serviceArray.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceSelectionCell
            
            let dict = serviceArray[indexPath.item]
            
            cell.lblServiceName.text    =   "\(dict[ServicesParams.serviceName]!)"
            cell.lblPrice.text          =   "$\(dict[ServicesParams.price]!)"
            
            cell.btnSelect.addTarget(self, action: #selector(StylistProfileVC.btnSelect_Click(_:)), for: .touchUpInside)
            
            var image = UIImage(named: "btnSelect")
            
            if checkWeatherDictIsInArray(dict: dict).0 {
                image = UIImage(named: "btnSelect_active")
            }
            
            cell.btnSelect.setImage(image, for: .normal)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoServiceCell", for: indexPath)
            return cell
        }
    }
    
    func btnSelect_Click(_ sender: AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: myTableView)
        let indexPath = myTableView.indexPathForRow(at: buttonPosition)
        
        let dict = serviceArray[(indexPath?.row)!]
        
        let result = checkWeatherDictIsInArray(dict: dict)
        
        if result.0 {
            selectedServiceArray.remove(at: result.1)
        } else {
            selectedServiceArray.append(dict)
        }
        
        if chooseDateViewHeight.constant == 0 && selectedServiceArray.count > 0 {
            chooseDateViewHeight.constant = CGFloat(chooseDateViewHeightValue)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: {(value: Bool) in
                let rect = CGRect(x: 0, y: self.chooseDateView.frame.origin.y, width: 1, height: self.chooseDateView.frame.size.height)
                self.myScrollView.scrollRectToVisible(rect, animated: true)
            })
            
        } else if chooseDateViewHeight.constant == CGFloat(chooseDateViewHeightValue) && selectedServiceArray.count == 0 {
            chooseDateViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        myTableView.reloadRows(at: [indexPath!], with: .automatic)
    }
    
    func checkWeatherDictIsInArray(dict: Dictionary<String, String>) -> (Bool, Int) {
        
        var index = 0
        
        for tempDict in selectedServiceArray {
            if tempDict[ServicesParams.serviceId] == dict[ServicesParams.serviceId] {
                return (true, index)
            }
            index += 1
        }
        return (false, index)
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension StylistProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if desiredLookArray.count > 0 {
//            selectedImageUrl = ImageDirectory.desiredLookDir + "\(desiredLookArray[indexPath.row])"
//            self.performSegue(withIdentifier: "imageSegue", sender: self)
        }
    }
}
