//
//  ContactViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 24/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var txtName: TextFieldValidator!
    @IBOutlet weak var txtEmail: TextFieldValidator!
    @IBOutlet weak var txtMessage: UITextView!
    
    //MARK: - Variables
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addValidationToTextField()
    }
    
    //MARK: - Helper Methods
    
    func addValidationToTextField() {
        txtName.updateLengthValidationMsg(MESSAGES.first_name_empty)
        txtEmail.updateLengthValidationMsg(MESSAGES.email_empty)
        
        txtEmail.addRegx(Regx.email, withMsg: MESSAGES.email_valid)
    }
    
    func callContactSupportService() {
        
        let innerJson = [Request.pass_data :["email": "\(txtEmail.text!)",
                                            "name"    : "\(txtName.text!)",
                                            "message" : "\(txtMessage.text!)",
                                            "subject"     : "From Enduser App"] as Dictionary<String, String>] as Dictionary<String, Any>
        
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.contactSupport, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSendMessage_Click(_ sender: Any) {
        if txtName.validate() && txtEmail.validate() {
            callContactSupportService()
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

extension ContactViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.contactSupport {
                    let alertController = UIAlertController(title: "Message Sent Successfully", message: "We will contact you soon.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                        self.txtEmail.text   = ""
                        self.txtName.text    = ""
                        self.txtMessage.text = ""
                    })
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
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
