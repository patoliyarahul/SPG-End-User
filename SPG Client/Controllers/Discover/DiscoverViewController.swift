//
//  DiscoverViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 11/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //MARK: - Variables
    
    var galleryImgaeArray = [Dictionary<String, String>]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Methods
    @IBAction func topHeaderButton_Click(_ sender: AnyObject) {
        
        let button = sender as! UIButton
        
        switch button.tag {
        case 100:
            setTitleAndButtons(button: button)
        default:
            break
        }
    }
    
    func setTitleAndButtons(button: UIButton) {
//        let sprayButton =   self.view.viewWithTag(100) as! UIButton
//        let paintButton =   self.view.viewWithTag(101) as! UIButton
//        let goButton    =   self.view.viewWithTag(102) as! UIButton
    }
    
    func callServiceMethod() {
        
        let innerJson = ["pass_data" : [StylistListParams.businessCatId : "1", "offset" : "0"] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getDiscoverImages, urlParamString: "", delegate: self)
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
        
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if galleryImgaeArray.count > 0 {
            //            selectedImageUrl = ImageDirectory.desiredLookDir + "\(desiredLookArray[indexPath.row])"
            //            self.performSegue(withIdentifier: "imageSegue", sender: self)
        }
    }
}

//MARK: - RequestManger Delegate

extension DiscoverViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                galleryImgaeArray = resultDict[MainResponseParams.data] as! [Dictionary<String, String>]
                myCollectionView.reloadData()
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

