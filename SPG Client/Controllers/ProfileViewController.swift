//
//  ProfileViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 12/7/16.
//  Copyright © 2016 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol ProfileDelegate {
    func shouldLogout()
}

class ProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - IBOutlet
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    //MARK: - Variables
    let settingsMenuItems = ["Personal Information", "Settings", "Support", "Log Out"]
    
    var delegate: ProfileDelegate?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "Gotham Book", size: 13)!
        cancelButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
    }
    
    //MARK: - Helper Functions
    
    @IBAction func btnCancel_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK : - UITableview Delegate & Datasource Methods

extension ProfileViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMenuItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) //as! bookingsTableViewCell
        cell.textLabel?.text = settingsMenuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingsMenuItems[indexPath.row] == "Log Out" {
            dismiss(animated: false, completion: {
                self.delegate?.shouldLogout()
            })
        }
    }
}
