//
//  ForgotPasswordViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/8/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var txtEmail: TextFieldValidator!
    @IBOutlet weak var btnResetPass: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMethods()
        addVelidationToTextFiled()
    }
    
    //MARK: - Helper & Initialization Methods
    func initialMethods() {
        btnResetPass.layer.borderColor = UIColor.white.cgColor
    }
    
    func addVelidationToTextFiled() {
        txtEmail.updateLengthValidationMsg(MESSAGES.email_empty)
        txtEmail.addRegx(Regx.email, withMsg: MESSAGES.email_valid)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func closeButton_Click(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func submitButton_Click(_ sender: Any) {
        if txtEmail.validate() {
            callService()
        }
    }
    
    func callService() {
        let innerJson = ["pass_data" : ["email" : "\(txtEmail.text!)"] as Dictionary<String, String>] as Dictionary<String , Any>
        
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.forgotPassword, urlParamString: "", delegate: self)
    }
}

extension ForgotPasswordViewController : RequestManagerDelegate {
    
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String: AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                print("sent successfully!")
                _ = self.navigationController!.popToRootViewController(animated: true)
            }else {
                let dict = resultDict[MainResponseParams.message] as! Dictionary<String,String>
                Utils.showAlert("\(dict[MainResponseParams.msgTitle]!)", message: "\(dict[MainResponseParams.msgDesc]!)", controller: self)
                
                // RK check on wrong and right mail, output is diffrent on message dictionary
            }
        }
    }
    
    func onFault(_ error: Error!) {
        Utils.HideHud()
    }
}
