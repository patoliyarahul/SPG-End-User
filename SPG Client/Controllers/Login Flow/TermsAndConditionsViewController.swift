//
//  Terms&ConditionsViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/7/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController : UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var cancelButton: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Helper & Initialization Methods
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func cancelButton_Click(_ sender: Any) {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
        }else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
