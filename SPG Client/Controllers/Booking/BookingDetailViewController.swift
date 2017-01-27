//
//  BookingDetailViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/9/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

protocol BookingDetailsDelegate {
    func didCancelAppointment()
    func recheduledAppointment(dict: Dictionary<String, String>)
}

class BookingDetailViewController : UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblSaloonName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblDayTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnReschedule: UIButton!
    @IBOutlet weak var btnCancelAppointment: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var viewCancelAppoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewCancelAppo: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewDesierLookCollection: UICollectionView!
    //MARK: - Variables
    
    var strAppointmentId = String()
    var detailsDict         =   Dictionary<String, Any>()
    var serviceArray        =   [Dictionary<String, String>]()
    var desiredLookArray    =   [String]()
    
    let datepickerHeight        = 295
    let appointmntViewHeight    = 180
    let serviceCellHeight: Int  = 30
    
    var rescheduleClicked = false
    var cancelApptmntClicked = false
    
    var selectedImageUrl = ""
    
    var delegate : BookingDetailsDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        
        callService()
        configureTableView()
    }
    
    //MARK: - Helper Methods
    
    func configureTableView() {
        myTableView.tableFooterView = UIView()
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 30
    }
    
    func callService() {
        
        let innerJson = [Request.pass_data: ["appointment_id": strAppointmentId] as Dictionary<String, String>] as Dictionary<String, Any>
        
        //        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.appointment_detail, urlParamString: "", delegate: self)
    }
    
    
    func setText() {
        
        let gdate = Date().dateFromString(format: DateFormate.dateFormate_2, dateString: detailsDict["title_appointment_date"]! as! String)
        let fDate = Date().stringDate(format: DateFormate.dateFormate_3, date: gdate)
        
        lblSaloonName.text = detailsDict["business_name"]! as? String
        
        let finalAddress = "\(detailsDict["business_street_address"]! as! String) \(detailsDict["business_suit"]! as! String), \(detailsDict["business_city"]! as! String)"
        
        let finalAddress1 = "\(detailsDict["business_state"]! as! String) \(detailsDict["business_zipcode"]! as! String)"
        
        lblAddress.attributedText = getAttributedTextWithSpacing(text: finalAddress + "," + finalAddress1)
        
        lblDayTime.text = String(format: "\(fDate) at %@", detailsDict["appointment_time"]! as! String)
        lblDate.text = detailsDict["appointment_date"]! as? String
        
        lblNote.text = detailsDict["user_notes"]! as? String
        
        if "\(detailsDict["user_notes"]! as? String)".characters.count == 0 {
            lblNote.text = "No Notes Available"
        }
        
        serviceArray = detailsDict[AppointmentDetailParams.serviceRequested] as! [Dictionary<String, String>]
        myTableView.reloadData()
        tableViewHeight.constant = CGFloat(serviceCellHeight * serviceArray.count)
        
        let desiredLookString   =   "\(detailsDict[AppointmentDetailParams.desiredLook]!)"
        desiredLookArray        =   desiredLookString.components(separatedBy: ",")
        
        myCollectionView.reloadData()
        
        if desiredLookArray.count == 0 || desiredLookArray[0].characters.count == 0{
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //MARK: - UIButton Action Methods
    
    
    @IBAction func btnRescheduleClicked(_ sender: Any) {
        cancelApptmntClicked = false
        hideCancelView()
        if rescheduleClicked {
            hidePicker()
        } else {
            pickerViewHeight.constant = CGFloat(datepickerHeight)
            btnReschedule.titleLabel?.font = UIFont(name: "Gotham Medium", size: 12)
        }
        
        rescheduleClicked = !rescheduleClicked
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    func hidePicker() {
        pickerViewHeight.constant = 0
        pickerView.alpha = 0
        btnReschedule.titleLabel?.font = UIFont(name: "Gotham Book", size: 12)
    }
    
    func hideCancelView() {
        btnCancelAppointment.titleLabel?.font = UIFont(name: "Gotham Book", size: 12)
        viewCancelAppo.alpha = 0
        viewCancelAppoHeight.constant = 0
    }
    
    @IBAction func btnCancelAppointmentClicked(_ sender: Any) {
        rescheduleClicked = false
        hidePicker()
        if cancelApptmntClicked {
            hideCancelView()
        }else {
            btnCancelAppointment.titleLabel?.font = UIFont(name: "Gotham Medium", size: 12)
            viewCancelAppoHeight.constant = CGFloat(appointmntViewHeight)
        }
        cancelApptmntClicked = !cancelApptmntClicked
        UIView.animate(withDuration: 0.5, animations: {
            self.viewCancelAppo.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnSendRequestClicked(_ sender: Any) {
        
        let date = Date().stringDate(format: DateFormate.dateFormate_4, date: datePicker.date)
        let time = Date().stringDate(format: DateFormate.dateFormate_6, date: datePicker.date)
        
        let innerJson = [Request.pass_data: [AppointmentParams.appointmentId: strAppointmentId,AppointmentDetailParams.appointmentDate: date, AppointmentDetailParams.appointmentTime: time] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.reschedule_appointment, urlParamString: "", delegate: self)
    }
    
    @IBAction func btnCancelAppClicked(_ sender: Any) {
        
        let innerJson = [Request.pass_data: [AppointmentParams.appointmentId: strAppointmentId] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.cancel_appointment, urlParamString: "", delegate: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSegue" {
            //            let dv = segue.destination as! ImageBrowserVC
            //            dv.imageUrl = selectedImageUrl
        }
    }
}

//MARK: - UITableVeiw Delegate & Datasource Methods

extension BookingDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppointmentServiceCell
        
        let dict = serviceArray[indexPath.row]
        
        cell.lblServiceName.text    =   "\(dict[ServicesParams.serviceName]!)"
        cell.lblTime.text           =   "$"+"\(dict[ServicesParams.price]!)"
        
        return cell
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension BookingDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if desiredLookArray.count > 0 {
            return desiredLookArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if desiredLookArray.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DesiredLookCell
            let url = ImageDirectory.desiredLookDir + "\(desiredLookArray[indexPath.row])"
            Utils.downloadImage(url, imageView: cell.desiredLookImage)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotAvailableCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if desiredLookArray.count > 0 {
            selectedImageUrl = ImageDirectory.desiredLookDir + "\(desiredLookArray[indexPath.row])"
//            self.performSegue(withIdentifier: "imageSegue", sender: self)
        }
    }
}

extension BookingDetailViewController : RequestManagerDelegate {
    
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                if action == Api.appointment_detail {
                    detailsDict = (resultDict[MainResponseParams.data] as? [String : AnyObject])!
                    scrollView.isHidden = false
                    setText()
                } else if action == Api.reschedule_appointment {
//                    let dictArray = resultDict[MainResponseParams.data]
//                    delegate?.recheduledAppointment(dict: dictArray as! Dictionary<String, String>)
                    _ = self.navigationController?.popViewController(animated: true)
                } else if action == Api.cancel_appointment {
                    delegate?.didCancelAppointment()
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

