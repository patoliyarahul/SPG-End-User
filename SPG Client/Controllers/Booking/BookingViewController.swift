//
//  BookingsTableViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/8/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController{
    
    //MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var blackTransperantView: UIView!
    
    @IBOutlet weak var viewForSearch: UIView!
    
    //MARK: - Variables
    var selectedIndexPath   =   IndexPath(row: 0, section: 0)
    var arrUpcommingBooking =   [Dictionary<String, String>]()
    var arrPastBooking      =   [Dictionary<String, String>]()
    let sectionTitles       =   ["UPCOMING", "PAST"]
    
    var arrSearchMerged     =   [Dictionary<String, String>]()
    var arrSearchResult     =   [Dictionary<String, String>]()
    
    var searchActive = false
    var searchController: UISearchController!
    
    
    //MARK : - LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: blackTransperantView)
        
        let font = UIFont(name: "Gotham Book", size: 13)!
        cancelButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        
        configureSearchController()
        configureTableView()
        callService()
        
        tableView.isHidden = true
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        
        searchController.searchBar.searchBarStyle   =   .minimal
        searchController.searchBar.placeholder      =   "Search Bookings"
        
        searchController.searchBar.sizeToFit()
        
        viewForSearch.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
    }
    
    
    //MARK: - Helper Methods
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func callService() {
        
        let innerJson = ["pass_data": [EndUserParams.endUserID: "\(userDefault.value(forKey: EndUserParams.endUserID)!)"] as Dictionary<String, String>] as Dictionary<String, Any>
        
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.booking_history, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func cancelButton_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UINavigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookingDetailSegue" {
            let vc = segue.destination as! BookingDetailViewController
            
            var dict = Dictionary<String, String>()
            
            if searchActive && searchController.searchBar.text != "" {
                dict = arrSearchResult[selectedIndexPath.row]
            } else if selectedIndexPath.section == 0 {
                dict = arrUpcommingBooking[selectedIndexPath.row]
            } else {
                dict = arrPastBooking[selectedIndexPath.row]
            }
            
            let gdate = Date().dateFromString(format: DateFormate.dateFormate_1, dateString: dict["appointment_date"]!)
            let fDate = Date().stringDate(format: DateFormate.dateFormate_2, date: gdate)
            vc.navigationItem.title = fDate
            vc.strAppointmentId = dict["appointment_id"]!
            vc.delegate = self
        }
    }
}

//MARK: - UITableView Delegate Methods
extension BookingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive && searchController.searchBar.text != "" {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if searchActive && searchController.searchBar.text != "" {
            return ""
        }
        
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive && searchController.searchBar.text != "" {
            return arrSearchResult.count
        } else if section == 0 {
            if arrUpcommingBooking.count > 0 {
                return arrUpcommingBooking.count
            }else {
                return 1
            }
        } else {
            if arrPastBooking.count > 0 {
                return arrPastBooking.count
            }else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Gotham Book", size: 10)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if (indexPath.section == 0 && arrUpcommingBooking.count > 0) || (indexPath.section == 1 && arrPastBooking.count > 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! bookingsTableViewCell
            
            var dictData = Dictionary<String, String>()
            if searchActive && searchController.searchBar.text != "" {
                dictData = arrSearchResult[indexPath.row]
            } else if indexPath.section == 0 {
                dictData = arrUpcommingBooking[indexPath.row] 
            } else {
                dictData = arrPastBooking[indexPath.row] 
            }
            
            cell.dateLabel.text = dictData["appointment_date"]
            let name = String(format: "%@ %@",dictData["appointment_time"]!,dictData["business_name"]!)
            cell.descriptionLabel.text = name
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellNo", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0 && arrUpcommingBooking.count > 0) || (indexPath.section == 1 && arrPastBooking.count > 0){
            selectedIndexPath = indexPath
            performSegue(withIdentifier: "bookingDetailSegue", sender: self)
        }
    }
}

//MARK: - Request Manager Delegate
extension BookingViewController : RequestManagerDelegate {
    
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        tableView.isHidden = false
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                arrUpcommingBooking = resultDict["upcoming_data"] as! [Dictionary<String, String>]
                arrPastBooking      = resultDict["past_data"] as! [Dictionary<String, String>]
                //                tableView.reloadData()
                
                mergeUpcommingAndPastBookings()
                
                reloadTableViewWithAnimation(myTableView: tableView)
                
            } else {
                let dict = resultDict[MainResponseParams.message] as! Dictionary<String, String>
                Utils.showAlert("\(dict[MainResponseParams.msgTitle]!)", message: "\(dict[MainResponseParams.msgDesc]!)", controller: self)
            }
        }
    }
    
    func onFault(_ error: Error!) {
        Utils.HideHud()
    }
    
    func mergeUpcommingAndPastBookings() {
        arrSearchMerged = [Dictionary<String, String>]()
        arrSearchMerged.append(contentsOf: arrUpcommingBooking)
        arrSearchMerged.append(contentsOf: arrPastBooking)
    }
}

//MARK: - BookingDetailViewController Delegate 
extension BookingViewController: BookingDetailsDelegate {
    func didCancelAppointment() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackTransperantView.alpha = 1
        }) { (bool : Bool) in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut, animations: {
                self.blackTransperantView.alpha = 0
            }, completion: { (bool : Bool) in
                if self.selectedIndexPath.section == 0 {
                    self.arrUpcommingBooking.remove(at: self.selectedIndexPath.row)
                    
                    if self.arrUpcommingBooking.count > 0 {
                        self.myTableView.deleteRows(at: [self.selectedIndexPath], with: .automatic)
                    } else {
                        self.myTableView.reloadSections([self.selectedIndexPath.section], with: .automatic)
                    }
                    
                } else {
                    self.arrPastBooking.remove(at: self.selectedIndexPath.row)
                    
                    if self.arrPastBooking.count > 0 {
                        self.myTableView.deleteRows(at: [self.selectedIndexPath], with: .automatic)
                    } else {
                        self.myTableView.reloadSections([self.selectedIndexPath.section], with: .automatic)
                    }
                }
                
            })
        }
    }
    
    func recheduledAppointment() {
        callService()
    }
}

//MARK: - UISearchBarDelegate

extension BookingViewController : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
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
        arrSearchResult = (arrSearchMerged as NSArray).filtered(using: searchPredicate) as! [Dictionary<String, String>]
        
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





