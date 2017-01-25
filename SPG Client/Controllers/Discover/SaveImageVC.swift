//
//  SaveImageVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 15/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol SaveImageDelegate {
    func imageAddedSuccessFully()
}

class SaveImageVC: UIViewController {

    //MARK: - IBoulets 
    @IBOutlet weak var imgLookbook: UIImageView!
    @IBOutlet weak var txtNotes: UITextView!
    
    //MARK: - Variables
    
    var dict = Dictionary<String, String>()
    var selectedLookBookId  =   "0"
    
    var delegate: SaveImageDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    //MARK: - Helper Methdos
    
    func initialSetup() {
        let url = ImageDirectory.gallaryDir + "\(dict[GalleryParams.galleryImageName]!)"
        Utils.downloadImage(url, imageView: imgLookbook)
    }

    //MARK: - UIButton Action Methods
    @IBAction func btnCancel_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave_Click(_ sender: Any) {
        if selectedLookBookId != "0" {
            
            let innerJson = ["pass_data" : [LookBookParams.lookBookId : selectedLookBookId, EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!, LookBookParams.lookBookNotes : txtNotes.text!, LookBookParams.lookBookImagesName : ["\(dict[GalleryParams.galleryImageName]!)"], StylistListParams.stylistId : dict[StylistListParams.stylistId]!] as Dictionary<String, Any>] as Dictionary<String, Any>
            innerJson.printJson()
            Utils.callServicePost(innerJson.json, action: Api.saveLookBookImage, urlParamString: "", delegate: self)
            
        } else {
            Utils.showAlert("No Lookbook Selected", message: "Please select lookbook where you wants to save image.", controller: self)
        }
    }
    
    @IBAction func btnSelectLookbook_Click(_ sender: Any) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DiscoverSegue.selectLookBookSegue {
            let dv = segue.destination as! SelectLookBookVC
            dv.delegate = self
            dv.selectedLookBookId = selectedLookBookId
        }
    }
}

extension SaveImageVC: SelectLokBookDelegate {
    func didSelectLookBook(lookBookId: String) {
        selectedLookBookId = lookBookId
    }
}

extension SaveImageVC: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                self.dismiss(animated: true, completion: { 
                    self.delegate?.imageAddedSuccessFully()
                })
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
