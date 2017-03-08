//
//  DiscoverImageVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 15/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class DiscoverImageVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgStylistWork: UIImageView!
    @IBOutlet weak var blackTransperantView: UIView!
    
    //MARK: - Variables
    
    var dict    =   Dictionary<String, String>()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationItem.title = ""
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setInitialValues() {
        let url = ImageDirectory.gallaryDir + "\(dict[GalleryParams.galleryImageName]!)"
        Utils.downloadImage(url, imageView: imgStylistWork)
    }
    
    //MARK: - Helper Methods
    
    func callServiceForProfileDetail() {
        
        let innerJson = ["pass_data" : [StylistListParams.stylistId : dict[StylistListParams.stylistId]!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getStylistProfile, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStylistInfo_Click(_ sender: Any) {
        callServiceForProfileDetail()
    }
    
    @IBAction func btnSaveImage_Click(_ sender: Any) {
        self.performSegue(withIdentifier: LookBookSegue.saveImageSegue, sender: self)
    }
    
    @IBAction func btnShare_Click(_ sender: Any) {
        let imageToShare = [imgStylistWork.image]
        
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LookBookSegue.saveImageSegue {
            let nv = segue.destination as! UINavigationController
            let dv = nv.viewControllers[0] as! SaveImageVC
            dv.delegate = self
            dv.dict = dict
        }
    }
}

extension DiscoverImageVC : RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.getStylistProfile {
                    let storyboard = UIStoryboard(name: "Stylists", bundle: nil)
                    let stylistDetailVC = storyboard.instantiateViewController(withIdentifier: "StylistProfileVC") as! StylistProfileVC
                    stylistDetailVC.detailsDict = resultDict[MainResponseParams.data] as! Dictionary<String, Any>
                    
                    self.navigationController?.pushViewController(stylistDetailVC, animated: true)
                    
                } else {
                    let dict = resultDict[MainResponseParams.message] as! Dictionary<String, String>
                    Utils.showAlert("\(dict[MainResponseParams.msgTitle]!)", message: "\(dict[MainResponseParams.msgDesc]!)", controller: self)
                }
            }
        }
    }
    
    func onFault(_ error: Error!) {
        Utils.HideHud()
    }
}

extension DiscoverImageVC: SaveImageDelegate {
    func imageAddedSuccessFully() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.blackTransperantView.alpha = 1
        }) { (book : Bool) in
            UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseInOut, animations: {
                self.blackTransperantView.alpha = 0
            }, completion: nil)
        }
    }
}

