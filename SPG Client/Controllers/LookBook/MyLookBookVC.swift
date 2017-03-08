//
//  MyLookBookVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 13/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol MyLookBookDelegate {
    func didUpdateDesiredLook()
}

class MyLookBookVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var noLookBookView: UIView!
    
    @IBOutlet weak var viewForSearchBar: UIView!
    //MARK: - Variables
    
    var lookBookArray   =   [Dictionary<String, String>]()
    var selectedIndex   =   IndexPath(row: 0, section: 0)
    
    var isChoosImage    =   false
    
    var delegate: MyLookBookDelegate?
    
    /// Search controller to help us with filtering.
    var arrSearchResult     =   [Dictionary<String, String>]()
    
    var searchActive = false
    var searchController: UISearchController!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: noLookBookView)
        
        configureSearchController()
        callService()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        
        searchController.searchBar.searchBarStyle   =   .minimal
        searchController.searchBar.placeholder      =   "Find Lookbook"
        
        searchController.searchBar.sizeToFit()
        
        viewForSearchBar.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
    }
    
    //MARK: - Helper Methods
    
    func callService() {
        let innerJson = ["pass_data" : [ EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getAllLookBook, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnCancel_Click(_ sender: Any) {
        self.dismiss(animated: true) { 
            self.delegate?.didUpdateDesiredLook()
        }
    }
    
    @IBAction func btnAdd_Click(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a Lookbook", message: "Use this to hold all of your ideas and favorite styles.", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {(textField: UITextField) -> Void in
            textField.placeholder = "My new Lookbook"
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        let saveAction  =  UIAlertAction(title: "SAVE", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            if (textField.text?.characters.count)! > 0 {
                let innerJson = ["pass_data" : [EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!, "lookbook_name" : textField.text!] as Dictionary<String, String>] as Dictionary<String, Any>
                innerJson.printJson()
                
                Utils.callServicePost(innerJson.json, action: Api.addLookBook, urlParamString: "", delegate: self)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
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
        if segue.identifier == LookBookSegue.viewLookBookSegue {
            
            let dict = lookBookArray[selectedIndex.row]
            
            let dv = segue.destination as! LookBookDetailsVC
            dv.lookBookDict = dict
            dv.isChoosImage = isChoosImage
            dv.delegate = self
        }
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension MyLookBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive && searchController.searchBar.text != "" {
            return arrSearchResult.count
        }
        
        return lookBookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyLookBookCollectionCell
        
        if lookBookArray.count > 0 {
            
            var dict = Dictionary<String, String>()
            
            if searchActive && searchController.searchBar.text != "" {
                dict = arrSearchResult[indexPath.row]
            } else {
                dict = lookBookArray[indexPath.row]
            }
            
            cell.lookBookImage.image = #imageLiteral(resourceName: "lookbook_default_thumbnail")
            
            cell.lookBookName.text  = "\(dict[LookBookParams.lookBookName]!)"
            cell.noOfImages.text    =  "\(dict[LookBookParams.lookBookTotalImg]!) IMAGES"
            
            let url = ImageDirectory.lookBookDir + "\(dict[LookBookParams.lookBookImage]!)"
            Utils.downloadImage(url, imageView: cell.lookBookImage)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 30) / 2
        return CGSize(width: width, height: width + 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        
        if lookBookArray.count > 0 {
            self.performSegue(withIdentifier: LookBookSegue.viewLookBookSegue, sender: self)
        }
    }
}

//MARK: - RequestManager Delegate

extension MyLookBookVC : RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                if (action == Api.getAllLookBook) || (action == Api.addLookBook) {
                    lookBookArray = resultDict[MainResponseParams.data] as! [Dictionary<String, String>]
                    
                    if lookBookArray.count > 0 {
                        self.myCollectionView.reloadData()
                        UIView.animate(withDuration: 0.5, animations: {
                            self.noLookBookView.alpha = 0
                        })
                    } else {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.noLookBookView.alpha = 1
                        })
                    }
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

//MARK: - Lookbook Detail Delegate

extension MyLookBookVC: LookBookDetailDelegate {
    func didDeleteLookBook() {
        lookBookArray.remove(at: selectedIndex.row)
        self.myCollectionView.performBatchUpdates({
            self.myCollectionView.deleteItems(at: [self.selectedIndex])
        }, completion: {
            (finished: Bool) in
            self.myCollectionView.reloadItems(at: self.myCollectionView.indexPathsForVisibleItems)
        })
        
        if lookBookArray.count == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.noLookBookView.alpha = 1
            })
        }
    }
}


//MARK: - SearchResultsDelegate Methods

extension MyLookBookVC : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        myCollectionView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Put your key in predicate that is "Name"
        let searchPredicate = NSPredicate(format: "lookbook_name CONTAINS[C] %@", searchText)
        arrSearchResult = (lookBookArray as NSArray).filtered(using: searchPredicate) as! [Dictionary<String, String>]
        
        myCollectionView.reloadData()
    }
    
    
    // MARK: - UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method:.")
        searchActive = false
        myCollectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

