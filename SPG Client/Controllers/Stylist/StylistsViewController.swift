//
//  StylistsViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 05/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class StylistsViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var viewForSearchBar: UIView!
    
    
    //MARK: - Variables
    
    var featuredArray   =   [Dictionary<String, String>]()
    var recomendedArray =   [Dictionary<String, String>]()
    var detailInfo      =   Dictionary<String, Any>()
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    /// Search controller to help us with filtering.
    var arrSearchMerged     =   [Dictionary<String, String>]()
    var arrSearchResult     =   [Dictionary<String, String>]()
    
    var searchActive = false
    var searchController: UISearchController!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: "Gotham Book", size: 13)!
        btnCancel.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        
        configureTableView(myTableView)
        myTableView.alpha = 0
        
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
        searchController.searchBar.placeholder      =   "Find Stylists"
        
        searchController.searchBar.sizeToFit()
        
        viewForSearchBar.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
        
    }
    
    //MARK: - Helper Methods
    
    func callService() {
        let innerJson = ["pass_data" : ["offset" : "0"] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getListOfStylist, urlParamString: "", delegate: self)
    }
    
    func callServiceForProfileDetail() {
        
        var dict = Dictionary<String, String>()
        
        if searchActive && searchController.searchBar.text != "" {
            dict = arrSearchResult[selectedIndexPath.row]
        } else if selectedIndexPath.section == 0 {
            dict = recomendedArray[selectedIndexPath.row]
        } else {
            dict = featuredArray[selectedIndexPath.row]
        }
        
        let innerJson = ["pass_data" : [StylistListParams.stylistId : dict[StylistListParams.stylistId]!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getStylistProfile, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnCancel_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StylistSegue.stylistDetailSegue {
            let dv = segue.destination as! StylistProfileVC
            dv.detailsDict = detailInfo
        }
    }
}

//MARK: - UITableViewDelegate And Datasource Methods

extension StylistsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchActive && searchController.searchBar.text != "" {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive && searchController.searchBar.text != "" {
            return arrSearchResult.count
        }
        
        if section == 0 {
            return recomendedArray.count
        } else {
            return featuredArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StylistTableViewCell
        
        var dict = Dictionary<String, String>()
        
        if searchActive && searchController.searchBar.text != "" {
            dict = arrSearchResult[indexPath.row]
        } else if indexPath.section == 0 {
            dict = recomendedArray[indexPath.row]
        } else {
            dict = recomendedArray[indexPath.row]
        }
        
        cell.lblStylistname.text    =   dict[StylistListParams.businessName]
        cell.lblService.text        =   dict[StylistListParams.profession]
        
        if dict[StylistListParams.logoImage]! != "" && dict[StylistListParams.logoImage]! != "not define" {
            let url = ImageDirectory.logoDir + "\(dict[StylistListParams.logoImage]!)"
            Utils.downloadImage(url, imageView: cell.imgProfile)
        }
        
        let address = "\(dict[StylistListParams.businessStreet]!), \(dict[StylistListParams.businessSuit]!), \(dict[StylistListParams.businessCity]!), \(dict[StylistListParams.businessState]!), \(dict[StylistListParams.businessZipCode]!)"
        
        cell.lblAddress.attributedText = getAttributedTextWithSpacing(text: address)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let title = UILabel()
        title.font = UIFont(name: "Gotham Book", size: 11)!
        title.textColor = UIColor.lightGray
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = title.font
        header.textLabel?.textColor = title.textColor
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if searchActive && searchController.searchBar.text != "" {
            return ""
        } else if section == 0 {
            return "RECOMMENDED STYLIST"
        } else {
            return "FEATURED STYLIST"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        callServiceForProfileDetail()
    }
}

//MARK: - RequestManager Delegate Methods

extension StylistsViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.getListOfStylist {
                    featuredArray   = resultDict[StylistListParams.featuredList] as! [Dictionary<String, String>]
                    recomendedArray = resultDict[StylistListParams.recommendedList] as! [Dictionary<String, String>]
                    
                    if featuredArray.count > 0 || recomendedArray.count > 0 {
                        myTableView.alpha = 1;
                        reloadTableViewWithAnimation(myTableView: myTableView)
                    }
                } else if action == Api.getStylistProfile {
                    if let details : Dictionary<String, Any> = resultDict[MainResponseParams.data] as? Dictionary<String, Any> {
                        detailInfo = details
                        self.performSegue(withIdentifier: StylistSegue.stylistDetailSegue, sender: self)
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

//MARK: - UISearchBarDelegate

//MARK: - UISearchBarDelegate

extension StylistsViewController : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        myTableView.reloadData()
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
        let searchPredicate = NSPredicate(format: "business_name CONTAINS[C] %@", searchText)
        arrSearchResult = (recomendedArray as NSArray).filtered(using: searchPredicate) as! [Dictionary<String, String>]
        
        myTableView.reloadData()
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
        myTableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


