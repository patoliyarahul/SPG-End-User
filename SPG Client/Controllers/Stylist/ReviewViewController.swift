//
//  ReviewViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 10/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class ReviewViewController : UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblSaloonName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblDayTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewDesierLookCollection: UICollectionView!
    //MARK: - Variables
    
    var strAppointmentId = String()
    
    let datepickerHeight        = 295
    let appointmntViewHeight    = 180
    let serviceCellHeight: Int  = 30
    
    var rescheduleClicked = false
    var cancelApptmntClicked = false
    
    var selectedImageUrl = ""
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setText()
    }
    
    //MARK: - Helper Methods
    
    func configureTableView() {
        myTableView.tableFooterView = UIView()
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 30
    }
    
    func callService() {
        
//        let innerJson = [Request.pass_data: ["appointment_id": strAppointmentId] as Dictionary<String, String>] as Dictionary<String, Any>
//        
//        //        innerJson.printJson()
//        Utils.callServicePost(innerJson.json, action: Api.appointment_detail, urlParamString: "", delegate: self)
    }
    
    
    func setText() {
    
        let gdate = Date().dateFromString(format: DateFormate.dateFormate_4, dateString: appDelegate.appointmentDate)
        let fDate = Date().stringDate(format: DateFormate.dateFormate_3, date: gdate)
        
        lblSaloonName.text = appDelegate.stylistName
        
        lblAddress.attributedText = getAttributedTextWithSpacing(text: appDelegate.stylistAddress)
        
        lblDayTime.text = String(format: "\(fDate) at %@", appDelegate.appointmentTime)
        lblDate.text = Date().stringDate(format: DateFormate.dateFormate_5, date: gdate)
        
        if appDelegate.appointmentNotes.characters.count == 0 {
            lblNote.text = "No Notes Available"
        } else {
            lblNote.attributedText = getAttributedTextWithSpacing(text: appDelegate.appointmentNotes)
        }
        
        myTableView.reloadData()
        tableViewHeight.constant = CGFloat(serviceCellHeight * appDelegate.serviceListArray.count)
    
        myCollectionView.reloadData()
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnSendRequest_Click(_ sender: Any) {
        callServiceForBookAppointment()
    }
    
    //MARK: - Service Call Methods
    
    func callServiceForBookAppointment() {
        
        var desireLookArr = [String]()
        
        for dict in appDelegate.desiredLookArray {
            desireLookArr.append(dict[LookBookParams.lookBookDetailImage]!)
        }
        
        let totalLength = secondsToHoursMinutesSeconds(seconds: appDelegate.totalLength * 60)
        
        let innerJson = ["pass_data" : [StylistListParams.stylistId : appDelegate.stylistId,
                                        EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!,
                                        "service_id_list" : appDelegate.serviceListId,
                                        "total_price" : "\(appDelegate.totalPrice)",
                                        AppointmentDetailParams.userNote : appDelegate.appointmentNotes,
                                        AppointmentDetailParams.appointmentDate : appDelegate.appointmentDate,
                                        AppointmentDetailParams.appointmentTime : appDelegate.appointmentTime,
                                        AppointmentDetailParams.selfiePic : "",
                                        AppointmentDetailParams.desiredLook : desireLookArr,
                                        ManualAppointmentParams.totalLength: "\(totalLength.0):\(totalLength.1):\(totalLength.2)"] as Dictionary<String, Any>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.bookAppointment, urlParamString: "", delegate: self)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func callServiceForUploadSelfie() {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

//MARK: - UITableVeiw Delegate & Datasource Methods

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.serviceListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppointmentServiceCell
        
        let dict = appDelegate.serviceListArray[indexPath.row]
        
        cell.lblServiceName.text    =   "\(dict[ServicesParams.serviceName]!)"
        cell.lblTime.text           =   "$"+"\(dict[ServicesParams.price]!)"
        
        return cell
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if appDelegate.desiredLookArray.count > 0 {
            return appDelegate.desiredLookArray.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if appDelegate.desiredLookArray.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DesiredLookCell
            
            let dict = appDelegate.desiredLookArray[indexPath.row]
            
            let url = ImageDirectory.lookBookDir + "\(dict["lookbook_image_name"]!)"
            Utils.downloadImage(url, imageView: cell.desiredLookImage)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotAvailableCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if appDelegate.desiredLookArray.count > 0 {
            selectedImageUrl = ImageDirectory.desiredLookDir + "\(appDelegate.desiredLookArray[indexPath.row])"
//            self.performSegue(withIdentifier: "imageSegue", sender: self)
        }
    }
}

extension ReviewViewController : RequestManagerDelegate {
    
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.bookAppointment {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    print("appointment booked successfully \(resultDict)")
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
