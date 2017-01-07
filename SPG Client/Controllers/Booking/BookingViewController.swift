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
    
    //MARK: - Variables
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var arrUpcommingBooking = [AnyObject]()
    var arrPastBooking = [AnyObject]()
    let sectionTitles = ["UPCOMING", "PAST"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "Gotham Book", size: 13)!
        cancelButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        configureTableView()
        callService()
        tableView.isHidden = true
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func cancelButton_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAppointment(_ sender: UIBarButtonItem) {
        
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func callService() {
        
        let innerJson = ["pass_data": ["end_user_id": "\(userDefault.value(forKey: "end_user_id")!)"] as Dictionary<String, String>] as Dictionary<String, Any>
        
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.booking_history, urlParamString: "", delegate: self)
    }
}

extension BookingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if arrUpcommingBooking.count > 0 {
                return arrUpcommingBooking.count
            }else {
                return 1
            }
        }else {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookingsCell", for: indexPath) as! bookingsTableViewCell
            
            var dictData = Dictionary<String, String>()
            if indexPath.section == 0 {
                dictData = arrUpcommingBooking[indexPath.row] as! Dictionary<String, String>
            } else {
                dictData = arrPastBooking[indexPath.row] as! Dictionary<String, String>
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookingDetailSegue" {
            let vc = segue.destination as! BookingDetailViewController
            
            var dict = Dictionary<String, String>()
            if selectedIndexPath.section == 0 {
                dict = arrUpcommingBooking[selectedIndexPath.row] as! Dictionary<String, String>
            }else {
                dict = arrPastBooking[selectedIndexPath.row] as! Dictionary<String, String>
            }
            
            let gdate = Date().dateFromString(format: DateFormate.dateFormate_1, dateString: dict["appointment_date"]!)
            let fDate = Date().stringDate(format: DateFormate.dateFormate_2, date: gdate)
            vc.navigationItem.title = fDate
            vc.strAppointmentId = dict["appointment_id"]!
        }
    }
}

extension BookingViewController : RequestManagerDelegate {
    
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        tableView.isHidden = false
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                arrUpcommingBooking = resultDict["upcoming_data"] as! [AnyObject]
                arrPastBooking = resultDict["past_data"] as! [AnyObject]
                //                tableView.reloadData()
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
}
