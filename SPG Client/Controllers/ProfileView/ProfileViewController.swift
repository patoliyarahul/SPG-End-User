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
    
    //MARK: - Variables
    
    var delegate: ProfileDelegate?
    
    let aboutMenuItems = ["Privacy Policy", "Terms of Use", "Contact Support"]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Methods
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSignOut_Click(_ sender: Any) {
        
        let confirmLogout = UIAlertController(title: "Confirmation", message: "Are you sure you want to Logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.dismiss(animated: false, completion: {
                self.delegate?.shouldLogout()
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in})
        
        confirmLogout.addAction(okAction)
        confirmLogout.addAction(cancelAction)
        
        self.present(confirmLogout, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteAccount_Click(_ sender: Any) {
        
    }
    
    @IBAction func btnClose_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: MyProfileSegue.privacyPolicySegue, sender: self)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: MyProfileSegue.contactSupportSegue, sender: self)
        }
    }
}


