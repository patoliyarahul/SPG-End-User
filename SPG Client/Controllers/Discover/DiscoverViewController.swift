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
    
    @IBOutlet weak var viewForSearchBar: UIView!
    
    //MARK: - Variables
    
    var galleryImgaeArray = [Dictionary<String, String>]()
    var designCategory    = 0
    
    var selectedIndex = IndexPath(row: 0, section: 0)
    
    let activeColor     =   UIColor(red: 93.0/255, green: 9.0/255, blue: 139.0/255, alpha: 1)
    let mainLableColor  =   UIColor(red: 92.0/255, green: 87.0/255, blue: 96.0/255, alpha: 1)
    let subLabelColor   =   UIColor(red: 155.0/255, green: 155.0/255, blue: 155.0/255, alpha: 1)
    
    let headerFont      =   UIFont(name: "Gotham Medium", size: 14)
    let subHeaderFont   =   UIFont(name: "Gotham Book", size: 10)
    
    let sprayTitle: NSString    =   "SPRAY\nHair & Training"
    let paintTitle: NSString    =   "PAINT\nMakeup & Nails"
    let goTitle: NSString       =   "GO\nAll Things Skin"
    
    var arrSearchResult     =   [Dictionary<String, String>]()
    
    var searchActive = false
    var searchController: UISearchController!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        topHeaderButton_Click(self.view.viewWithTag(100) as! UIButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false;
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        
        searchController.searchBar.searchBarStyle   =   .minimal
        searchController.searchBar.placeholder      =   ""
        
        searchController.searchBar.sizeToFit()
        
        viewForSearchBar.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
    }
    
    //MARK: - Helper Methods
    @IBAction func topHeaderButton_Click(_ sender: AnyObject) {
        
        let button = sender as! UIButton
        
        if designCategory != button.tag - 100 + 1 {
            designCategory = button.tag - 100 + 1
            
            let sprayButton =   self.view.viewWithTag(100) as! UIButton
            let paintButton =   self.view.viewWithTag(101) as! UIButton
            let goButton    =   self.view.viewWithTag(102) as! UIButton
            
            setAttributedTextToButton(button: sprayButton, title: sprayTitle, mainColor: mainLableColor, subColor: subLabelColor)
            setAttributedTextToButton(button: paintButton, title: paintTitle, mainColor: mainLableColor, subColor: subLabelColor)
            setAttributedTextToButton(button: goButton, title: goTitle, mainColor: mainLableColor, subColor: subLabelColor)
            
            switch button.tag {
            case 100:
                setAttributedTextToButton(button: sprayButton, title: sprayTitle, mainColor: activeColor, subColor: activeColor)
            case 101:
                setAttributedTextToButton(button: paintButton, title: paintTitle, mainColor: activeColor, subColor: activeColor)
            case 102:
                setAttributedTextToButton(button: goButton, title: goTitle, mainColor: activeColor, subColor: activeColor)
            default:
                break
            }
            
            callServiceMethod()
        }
    }
    
    func setAttributedTextToButton(button: UIButton, title: NSString, mainColor: UIColor, subColor: UIColor) {
        
        let newLineRange : NSRange = title.range(of: "\n")
        
        var subString1: NSString = ""
        var subString2: NSString = ""
        
        if newLineRange.location != NSNotFound {
            subString1 = title.substring(to: newLineRange.location) as NSString
            subString2 = title.substring(from: newLineRange.location) as NSString
        }
     
        let attrString1 =   NSMutableAttributedString(string: subString1 as String)
        let attrString2 =   NSMutableAttributedString(string: subString2 as String)
        
        attrString1.addAttributes([NSFontAttributeName : headerFont! , NSForegroundColorAttributeName : mainColor], range: NSRange(location:0,length: (subString1 as String).characters.count))
        attrString2.addAttributes([NSFontAttributeName : subHeaderFont! , NSForegroundColorAttributeName : subColor], range: NSRange(location:0,length: (subString2 as String).characters.count))
        
        attrString1.append(attrString2)
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineSpacing = 5
        mutableParagraphStyle.alignment = .center
        
        attrString1.addAttribute(NSParagraphStyleAttributeName, value: mutableParagraphStyle, range: NSMakeRange(0, (title as String).characters.count))
        
        button.setAttributedTitle(attrString1, for: .normal)
    }
    
    func callServiceMethod() {
        let innerJson = ["pass_data" : ["business_category_id" : "\(designCategory)", "offset" : "0"] as Dictionary<String, String>] as Dictionary<String, Any>
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
        if segue.identifier == DiscoverSegue.imageDetailSegue {
            let dv = segue.destination as! DiscoverImageVC
            
            var dict = Dictionary<String, String>()
            
            if searchController.searchBar.text != "" && searchActive {
                dict = arrSearchResult[selectedIndex.row]
                searchController.hidesNavigationBarDuringPresentation = true
            } else {
               dict = galleryImgaeArray[selectedIndex.row]
            }
            
            dv.dict = dict
        }
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive && searchController.searchBar.text != "" {
            return arrSearchResult.count
        }
        
        return galleryImgaeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DesiredLookCell
        
        if galleryImgaeArray.count > 0 {
            
            var dict = Dictionary<String, String>()
            
            if searchActive && searchController.searchBar.text != "" {
                dict = arrSearchResult[indexPath.row]
            } else {
                dict = galleryImgaeArray[indexPath.row]
            }
            
            let url = ImageDirectory.gallaryDir + "\(dict["gallery_image_name"]!)"
            Utils.downloadImage(url, imageView: cell.desiredLookImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: DiscoverSegue.imageDetailSegue, sender: self)
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

//MARK: - UISearchBarDelegate

extension DiscoverViewController : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
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
        let searchPredicate = NSPredicate(format: "gallery_image_name CONTAINS[C] %@", searchText)
        arrSearchResult = (galleryImgaeArray as NSArray).filtered(using: searchPredicate) as! [Dictionary<String, String>]
        
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


