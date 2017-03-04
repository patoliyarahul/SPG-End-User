//
//  SignUpViewController.swift
//  SPG Client
//
//  Created by Ahmed Elhosseiny on 11/2/16.
//  Copyright © 2016 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol SignupDelegate {
    func didSignup()
}

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var txtEmail: TextFieldValidator!
    @IBOutlet weak var txtPassword: TextFieldValidator!
    @IBOutlet weak var txtConformPassword: TextFieldValidator!
    
    @IBOutlet weak var txtFirstName: TextFieldValidator!
    @IBOutlet weak var txtLastName: TextFieldValidator!
    @IBOutlet weak var txtPhoneNo: TextFieldValidator!
    
    //MARK: - Variables
    var delegate: SignupDelegate?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMethod()
        addVelidationToTextFiled()
    }
    
    //MARK: - Helper & Initialization Methods
    func initialMethod() {
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor.white.cgColor
    }
    
    func addVelidationToTextFiled() {
        
        txtPhoneNo.delegate = self
        
        txtEmail.updateLengthValidationMsg(MESSAGES.email_empty)
        txtPassword.updateLengthValidationMsg(MESSAGES.pass_empty)
        txtConformPassword.updateLengthValidationMsg(MESSAGES.conform_pass_empty)
        
        txtFirstName.updateLengthValidationMsg(MESSAGES.first_name_empty)
        txtLastName.updateLengthValidationMsg(MESSAGES.last_name_empty)
        txtPhoneNo.updateLengthValidationMsg(MESSAGES.mobile_number_empty)
        
        txtEmail.addRegx(Regx.email, withMsg: MESSAGES.email_valid)
        txtConformPassword.addConfirmValidation(to: txtPassword, withMsg: MESSAGES.conform_pass_no_match)
        txtPhoneNo.addRegx(Regx.phone, withMsg: MESSAGES.phone_valid)
    }
    
    func callService() {
        
        let innerJson = [Request.pass_data  : [PersonalInfoParams.email: "\(txtEmail.text!)",
            PersonalInfoParams.password     : "\(txtPassword.text!)",
            Device.device_id                : userDefault.value(forKey: Device.device_id) as! String,
            Device.device_type              : Device.device_type_ios,
            "user_signup_type"              : Device.user_login_type_normal,
            PersonalInfoParams.firstName    : "\(txtFirstName.text!)",
            PersonalInfoParams.lastName     : "\(txtLastName.text!)",
            Device.udid                     : userDefault.string(forKey: Device.udid)!,
            PersonalInfoParams.phone        : "\(txtPhoneNo.text!)"] as Dictionary<String, String>] as Dictionary<String, Any>
        
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.signUp, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnFacebook_Click(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnClose_Click(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSignUp_Click(_ sender: AnyObject) {
        if txtEmail.validate() && txtPassword.validate() && txtConformPassword.validate() && txtFirstName.validate() && txtLastName.validate() && txtPhoneNo.validate() {
            callService()
        }
    }
}

//MARK: - RequestManager Delegate Methods

extension SignUpViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                print("login successfully")
                Utils.storeResponseToUserDefault(resultDict[MainResponseParams.data]!)
                delegate?.didSignup()
                self.dismiss(animated: true, completion: nil)
                
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
extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPhoneNo {
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
