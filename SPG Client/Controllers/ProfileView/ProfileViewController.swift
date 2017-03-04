//
//  ProfileViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 24/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol ProfileDelegate {
    func shouldLogout()
}

class ProfileViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    
    //MARK: - Variables
    
    let privacyPolicy   =   "Privacy Policy"
    let termsOfUse      =   "Terms Of Use"
    let contactSupport  =   "Contact Support"
    
    var delegate: ProfileDelegate?
    
    var aboutMenuItems = [String]()
    
    var selectedImage = UIImage()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutMenuItems = [privacyPolicy, termsOfUse, contactSupport]
        setPersonalInfoText()
    }
    
    func setPersonalInfoText() {
        lblFirstName.text = userDefault.value(forKey: EndUserParams.firstName) as? String
        lblLastName.text = userDefault.value(forKey: EndUserParams.lastName) as? String
        lblEmail.text = userDefault.value(forKey: EndUserParams.email) as? String
        lblPhoneNo.text = userDefault.value(forKey: EndUserParams.phone) as? String
        
        let c:Int = ((userDefault.value(forKey: EndUserParams.password) as? String)?.characters.count)!
        
        var final: String = ""
        for _ in 1...c {
            final = final+"*"
        }
        lblPassword.text = final
    }
    
    //MARK: - Helper Methods
    
    func callLogoutService() {
        let jsonString = ["pass_data": ["user_type" :   "2",
                                        "user_id"   :   userDefault.string(forKey: EndUserParams.endUserID)!,
                                        "device_uuid" : userDefault.string(forKey: Device.udid)!]
            as Dictionary<String, String>] as Dictionary<String,Any>
        Utils.callServicePost(jsonString.json, action: Api.logOutService, urlParamString: "", delegate: self)
    }
    
    func callDeleteAccountService() {
        let jsonString = ["pass_data": ["user_type" :   "1",
                                        "user_id"   :   userDefault.string(forKey: EndUserParams.endUserID)!] as Dictionary<String, String>] as Dictionary<String,Any>
        Utils.callServicePost(jsonString.json, action: Api.deleteAccount, urlParamString: "", delegate: self)
    }
    
    func callUploadProfilePicService() {
        let innerJson = [EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!] as NSMutableDictionary
        
        let data = UIImageJPEGRepresentation(selectedImage, 1.0)
        
        Utils.callPhotoUpload(dict: innerJson, action: Api.uploadProfilePic, data: data!, delegate: self, photoKey: "photo")
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSignOut_Click(_ sender: Any) {
        
        let confirmLogout = UIAlertController(title: "Confirmation", message: "Are you sure you want to Logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.callLogoutService()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in})
        
        confirmLogout.addAction(okAction)
        confirmLogout.addAction(cancelAction)
        
        self.present(confirmLogout, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteAccount_Click(_ sender: Any) {
        
        let confirmLogout = UIAlertController(title: "Confirmation", message: "Are you sure you want to Delete Account?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.callDeleteAccountService()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in})
        
        confirmLogout.addAction(okAction)
        confirmLogout.addAction(cancelAction)
        
        self.present(confirmLogout, animated: true, completion: nil)
        
        callDeleteAccountService()
    }
    
    @IBAction func btnClose_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnProfile_Click(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Add Profile Pic", message: "", preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let uploadPhotoAction = UIAlertAction(title: "Upload Photo", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(uploadPhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - MemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MyProfileSegue.editProfileSegue {
            let dv = segue.destination as! EditProfileViewController
            dv.delegate = self
        }
    }
}

//MARK: - UITableView Delegate & Datasource Methods

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = aboutMenuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if aboutMenuItems[indexPath.row] == privacyPolicy {
            self.performSegue(withIdentifier: MyProfileSegue.privacyPolicySegue, sender: self)
        } else if aboutMenuItems[indexPath.row] == termsOfUse {
            
        } else if aboutMenuItems[indexPath.row] == contactSupport {
            self.performSegue(withIdentifier: MyProfileSegue.contactSupportSegue, sender: self)
        }
    }
}

//MARK: - RequestManagerDelegate

extension ProfileViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                if action == Api.logOutService || action == Api.deleteAccount {
                    delegate?.shouldLogout()
                    self.dismiss(animated: false, completion: nil)
                } else if action == Api.uploadProfilePic {
                    imgProfile.image = selectedImage
                    //TODO : - Update profile pic in chat firebase db.
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

//MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = pickedImage
            self.callUploadProfilePicService()
        } else {
            print("Something went wrong.")
        }
        dismiss(animated: true, completion: {})
    }
}

//MARK : - EditProfileDelegate 

extension ProfileViewController : EditProfileDelegate {
    func didEditProfile() {
        setPersonalInfoText()
    }
}


