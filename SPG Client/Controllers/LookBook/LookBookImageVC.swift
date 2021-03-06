//
//  LookBookImageVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 13/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol LookBookImageDelegate {
    func didDeleteImage()
}

class LookBookImageVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var imgLookBook: UIImageView!
    
    //MARK: - Variables
    
    var dict    =   Dictionary<String, String>()
    
    var delegate : LookBookImageDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setInitialValues() {
        let url = ImageDirectory.lookBookDir + "\(dict[LookBookParams.lookBookDetailImage]!)"
        Utils.downloadImage(url, imageView: imgLookBook)
    }
    
    //MARK: - Helper Methods
    
    func callServiceForProfileDetail() {
        let innerJson = ["pass_data" : [StylistListParams.stylistId : dict[StylistListParams.stylistId]!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getStylistProfile, urlParamString: "", delegate: self)
    }
    
    func callDeleteImageService() {
        let innerJson = ["pass_data" : [LookBookParams.lookBookImageId : dict[LookBookParams.lookBookImageId]!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.deleteLookBookImage, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnStylistInfo_Click(_ sender: Any) {
        callServiceForProfileDetail()
    }
    
    @IBAction func btnClose_Click(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeleteSave_Click(_ sender: Any) {
        callDeleteImageService()
    }
    
    @IBAction func btnShare_Click(_ sender: Any) {
        
        let imageToShare = [imgLookBook.image]
        
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
        
    }
}

extension LookBookImageVC : RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.getStylistProfile {
                    if let dict = resultDict[MainResponseParams.data] as? Dictionary<String, Any> {
                        let storyboard = UIStoryboard(name: "Stylists", bundle: nil)
                        let stylistDetailVC = storyboard.instantiateViewController(withIdentifier: "StylistProfileVC") as! StylistProfileVC
                        stylistDetailVC.detailsDict = dict
                        self.navigationController?.pushViewController(stylistDetailVC, animated: true)
                    }
                } else if action == Api.deleteLookBookImage {
                    delegate?.didDeleteImage()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            } else {
                let dict = resultDict[MainResponseParams.message] as! Dictionary<String, String>
                Utils.showAlert("\(dict[MainResponseParams.msgTitle]!)", message: "\(dict[MainResponseParams.msgDesc]!)", controller: self)
            }
        }
    }
    
    func onFault(_ error: Error!) {
        Utils.HideHud()
    }
}
