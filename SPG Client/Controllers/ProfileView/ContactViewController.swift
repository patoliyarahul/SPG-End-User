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
        
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSendMessage_Click(_ sender: Any) {
        
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
