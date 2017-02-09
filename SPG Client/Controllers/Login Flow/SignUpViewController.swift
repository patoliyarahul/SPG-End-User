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
        
        let innerJson = [Request.pass_data: [PersonalInfoParams.email: "\(txtEmail.text!)", PersonalInfoParams.password: "\(txtPassword.text!)",Device.device_id : userDefault.value(forKey: Device.device_id) as! String , Device.device_type : Device.device_type_ios, "user_signup_type": Device.user_login_type_normal, PersonalInfoParams.firstName: "\(txtFirstName.text!)", PersonalInfoParams.lastName: "\(txtLastName.text!)", PersonalInfoParams.phone: "\(txtPhoneNo.text!)"] as Dictionary<String, String>] as Dictionary<String, Any>
        
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
