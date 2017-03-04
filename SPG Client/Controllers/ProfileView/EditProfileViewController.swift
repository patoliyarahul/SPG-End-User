//
//  EditProfileViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 03/03/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol EditProfileDelegate {
    func didEditProfile()
}

class EditProfileViewController: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var txtFirstName: TextFieldValidator!
    @IBOutlet weak var txtLastName: TextFieldValidator!
    @IBOutlet weak var txtMobileNo: TextFieldValidator!
    
    //MARK: - Variables
    
    var delegate : EditProfileDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextToTextField()
        addValidationToTextField()
    }
    
    //MARK: - Helper Methods
    
    func setTextToTextField() {
        txtFirstName.text   = userDefault.string(forKey: EndUserParams.firstName)
        txtLastName.text    = userDefault.string(forKey: EndUserParams.lastName)
        txtMobileNo.text    = userDefault.string(forKey: EndUserParams.phone)
    }
    
    func addValidationToTextField() {
        txtFirstName.updateLengthValidationMsg(MESSAGES.first_name_empty)
        txtLastName.updateLengthValidationMsg(MESSAGES.last_name_empty)
        txtMobileNo.updateLengthValidationMsg(MESSAGES.mobile_number_empty)
        
        txtMobileNo.addRegx(Regx.phone, withMsg: MESSAGES.phone_valid)
        
        txtMobileNo.delegate = self
    }
    
    func callUpdateProfileService() {
        let innerJson = [Request.pass_data  : ["user_id": userDefault.string(forKey: ClientsParams.enduserId)!,
            PersonalInfoParams.firstName    : "\(txtFirstName.text!)",
            PersonalInfoParams.lastName     : "\(txtLastName.text!)",
            PersonalInfoParams.phone        : "\(txtMobileNo.text!)",
            ClientsParams.email             : userDefault.string(forKey: ClientsParams.email)!,
            PersonalInfoParams.password     : userDefault.string(forKey: PersonalInfoParams.password)!] as Dictionary<String, String>] as Dictionary<String, Any>
        
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.editProfile, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnSave_Click(_ sender: Any) {
        if txtFirstName.validate() && txtLastName.validate() && txtMobileNo.validate() {
            callUpdateProfileService()
        }
    }
    
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

//MARK: - RequestManager Delegate Methods

extension EditProfileViewController : RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.editProfile {
                    Utils.storeResponseToUserDefault(resultDict[MainResponseParams.data]!)
                    delegate?.didEditProfile()
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

//MARK: - TextField Delegate
extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtMobileNo {
            let length = Int(self.getLength(textField.text!))
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string == numberFiltered {
                if length == 10 {
                    if range.length == 0 {
                        return false
                    }
                }
                else if length == 3 {
                    let num = self.formatNumber(mobileNumber: textField.text!)
                    textField.text = "\(num)-"
                    if range.length > 0 {
                        textField.text = "\(num.substring(to: num.index(num.startIndex, offsetBy: 3)))"
                    }
                } else if length == 6 {
                    let num = self.formatNumber(mobileNumber: textField.text!)
                    textField.text = "\(num.substring(to: num.index(num.startIndex, offsetBy: 3)))-\(num.substring(from: num.index(num.startIndex, offsetBy: 3)))-"
                    if range.length > 0 {
                        textField.text = "\(num.substring(to: num.index(num.startIndex, offsetBy: 3)))-\(num.substring(from: num.index(num.startIndex, offsetBy: 3)))"
                    }
                }
                return true;
                
            } else {
                return string == numberFiltered
            }
        } else {
            return true
        }
    }
    
    //MARK: - Helper Methods for textfield phone number formating
    
    func formatNumber( mobileNumber: String) -> String {
        var mobileNumber = mobileNumber
        mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        print("\(mobileNumber)")
        let length = Int(mobileNumber.characters.count)
        if length > 10 {
            mobileNumber = mobileNumber.substring(from: mobileNumber.index(mobileNumber.startIndex, offsetBy: length - 10))
        }
        return mobileNumber
    }
    
    func getLength(_ mobileNumber: String) -> Int {
        var mobileNumber = mobileNumber
        
        mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        let length = Int(mobileNumber.characters.count)
        return length
    }
}
