//
//  LookBookDetailsVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 13/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol LookBookDetailDelegate {
    func didDeleteLookBook()
}

class LookBookDetailsVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var noImagesView: UIView!
    
    //MARK: - Variables
    
    var lookBookArray   =   [Dictionary<String, String>]()
    var lookBookDict    =   Dictionary<String, String>()
    
    var selectedIndex   =   IndexPath(row: 0, section: 0)
    
    var delegate : LookBookDetailDelegate?
    
    var isChoosImage    =   false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: noImagesView)
        
        self.navigationItem.title = "\(lookBookDict[LookBookParams.lookBookName]!)"
        
        if Int("\(lookBookDict[LookBookParams.lookBookTotalImg]!)")! > 0 {
            callService()
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.noImagesView.alpha = 1
            })
        }
        print(lookBookDict)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helper Methods
    
    func callService() {
        let innerJson = ["pass_data" : [ EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!, LookBookParams.lookBookId : lookBookDict[LookBookParams.lookBookId]!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getLookBookByID, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnDelete_Click(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete Lookbook", message: "You will loose all of the images saved.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in}
        let okAction    =   UIAlertAction(title: "DELETE", style: .destructive) { (alert) in
            let innerJson = ["pass_data" : [EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!, LookBookParams.lookBookId : "\(self.lookBookDict[LookBookParams.lookBookId]!)"] as Dictionary<String, String>] as Dictionary<String, Any>
            innerJson.printJson()
            Utils.callServicePost(innerJson.json, action: Api.deleteLookbookById, urlParamString: "", delegate: self)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LookBookSegue.lookBookImageSegue {
            let dict = lookBookArray[selectedIndex.row]
            
            let dv = segue.destination as! LookBookImageVC
            dv.dict = dict
        }
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension LookBookDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lookBookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LookBookCell
        
        if lookBookArray.count > 0 {
            
            let dict = lookBookArray[indexPath.row]
            
            if (dict[LookBookParams.lookBookDetailImage]?.characters.count)! > 0 {
                let url = ImageDirectory.lookBookDir + "\(dict[LookBookParams.lookBookDetailImage]!)"
                Utils.downloadImage(url, imageView: cell.desiredLookImage)
            }
            
            if isChoosImage {
                
                cell.selectionView.alpha = 0
                
                if checkWeatherDictIsInArray(sourceDictArray: appDelegate.desiredLookArray, dict: dict, key: LookBookParams.lookBookImageId).0 {
                    cell.selectionView.alpha = 1
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 30) / 2
        return CGSize(width: width, height: width + 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isChoosImage {
            let dict = lookBookArray[indexPath.row]
            let result = checkWeatherDictIsInArray(sourceDictArray: appDelegate.desiredLookArray, dict: dict, key: LookBookParams.lookBookImageId)
            if result.0 {
                appDelegate.desiredLookArray.remove(at: result.1)
            } else {
                appDelegate.desiredLookArray.append(dict)
            }
            
            myCollectionView.reloadItems(at: [indexPath])
        } else {
            if lookBookArray.count > 0 {
                selectedIndex = indexPath
                self.performSegue(withIdentifier: LookBookSegue.lookBookImageSegue, sender: self)
            }
        }
    }
}

//MARK: - RequestManager Delegate

extension LookBookDetailsVC : RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                if action == Api.getLookBookByID {
                    lookBookArray = resultDict[MainResponseParams.data] as! [Dictionary<String, String>]
                    
                    if lookBookArray.count > 0 {
                        self.myCollectionView.reloadData()
                    } else {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.noImagesView.alpha = 1
                        })
                    }
                } else if action == Api.deleteLookbookById {
                    _ = self.navigationController?.popViewController(animated: true)
                    delegate?.didDeleteLookBook()
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



