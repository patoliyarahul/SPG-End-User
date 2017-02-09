//
//  LoginViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 04/10/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol LoginDelegate {
    func didLogedIn()
}

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet weak var txtEmail: TextFieldValidator!
    @IBOutlet weak var txtPassword: TextFieldValidator!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet var emailLine: UIView!
    @IBOutlet var passwordLine: UIView!
    
    //MARK: - Variables
    var delegte: LoginDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMethod()
        addVelidationToTextFiled()
    }
    
    //MARK: - Helper & Initialization Methods
    func initialMethod() {
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.white.cgColor
        emailLine.alpha = 0.2
        passwordLine.alpha = 0.2
    }
    
    func addVelidationToTextFiled() {
        txtEmail.updateLengthValidationMsg(MESSAGES.email_empty)
        txtPassword.updateLengthValidationMsg(MESSAGES.pass_empty)
        
        txtEmail.addRegx(Regx.email, withMsg: MESSAGES.email_valid)
        txtPassword.addRegx(Regx.pass, withMsg: MESSAGES.pass_valid)
    }
    
    func callService() {
        let innerJson = [Request.pass_data: [PersonalInfoParams.email: "\(txtEmail.text!)", PersonalInfoParams.password: "\(txtPassword.text!)",Device.device_id : userDefault.value(forKey: Device.device_id) as! String , Device.device_type : Device.device_type_ios, Device.user_login_type: Device.user_login_type_normal] as Dictionary<String, String>] as Dictionary<String, Any>
        
        // 2 for normal and 1 for FB
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.login, urlParamString: "", delegate: self)
    }
    
    //MARK: - Facebook Login & LogOut Helpers
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully Logged In with Facebook!")
    }
    
    @IBAction func facebookLogin (sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
                
                let message = (facebookError?.localizedDescription)!
                
                let alertController = UIAlertController(title: "Facebook Login Error", message: message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else if (facebookResult?.isCancelled)! { print("Facebook login was cancelled.")
            } else {
                
                let fbloginresult : FBSDKLoginManagerLoginResult = facebookResult!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    //                    self.returnUserData()
                    
                    if((FBSDKAccessToken.current()) != nil){
                        self.showUserData()
                    }
                }
                print("Facebook Login Successful")
                UserDefaults.standard.set(true, forKey: "loggedIn")
                self.performSegue(withIdentifier: "userLoggedIn", sender: self)
            }
        });
    }
    
    func showUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, first_name, last_name, locale, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            }else {
            }
        })
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnClose_Click(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLogin_Click(_ sender: AnyObject) {
        if txtEmail.validate() && txtPassword.validate() {
            callService()
        }
    }
}

extension LoginViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                print("login successfully")
                Utils.storeResponseToUserDefault(resultDict[MainResponseParams.data]!)
                delegte?.didLogedIn()
                dismiss(animated: false, completion: nil)
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
