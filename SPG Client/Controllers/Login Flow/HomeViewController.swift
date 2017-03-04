//
//  HomeViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 04/10/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var btnTermsAndConditions: UIButton!
    
    @IBOutlet weak var splashView: UIView!
    
    //MARK: - Variables
    
    var isLoggedIn = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.borderColor = UIColor.white.cgColor
        btnSignUP.layer.borderColor = UIColor.white.cgColor
        
        splashView.alpha = 1;
        self.view.bringSubview(toFront: splashView)
        
        if userDefault.bool(forKey: Constant.userIsLogedIn) {
            isLoggedIn = true
            didLogedIn()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !userDefault.bool(forKey: Constant.userIsLogedIn) {
            
            splashView.alpha = 0;
            
            self.imageView.alpha = 1.0
            self.logoImageView.alpha = 0.0
            self.btnLogin.alpha = 0.0
            self.btnSignUP.alpha = 0.0
            self.btnTermsAndConditions.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0.5, animations: {
            self.imageView.alpha = 1
            self.logoImageView.alpha = 1.0
            self.btnLogin.alpha = 1.0
            self.btnSignUP.alpha = 1.0
            self.btnTermsAndConditions.alpha = 1.0
        })
    }
    
    //MARK: - UINavigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        splashView.alpha = 0
        isLoggedIn = false
        
        if segue.identifier == InitialSegue.loginSegue {
            let nv = segue.destination as! UINavigationController
            let dv = nv.viewControllers[0] as! LoginViewController
            dv.delegte = self
            
        } else if segue.identifier == InitialSegue.signupSegue {
            let nv = segue.destination as! UINavigationController
            let dv = nv.viewControllers[0] as! SignUpViewController
            dv.delegate = self
        }
    }
}

//MARK: - Login SignupDeligate
extension HomeViewController: LoginDelegate {
    func didLogedIn() {
        
        // Login To Firebase for chat functioanlity
        
        FIRAuth.auth()?.signIn(withEmail: userDefault.string(forKey: ClientsParams.email)!, password: "123456") { (user, error) in
            if let err = error { // 3
                print(err.localizedDescription)
                if err.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self.signUpToFirebase()
                } else {
                    return
                }
            } else {
                userDefault.set(true, forKey: Constant.userIsLogedIn)
                
                Chat_Utils.updateFUserPersonalDetails()
                
                let segueName = self.isLoggedIn ? InitialSegue.homeToDeshboardWithoutAnimation : InitialSegue.homeToDashboardSegue
                self.performSegue(withIdentifier: segueName, sender: self)
            }
        }
    }
    
    func signUpToFirebase() {
        FIRAuth.auth()?.createUser(withEmail: userDefault.string(forKey: ClientsParams.email)!, password: "123456") { (user, error) in
            if let err = error { // 3
                print(err.localizedDescription)
                return
            }
            userDefault.set(true, forKey: Constant.userIsLogedIn)
            
            Chat_Utils.updateFUserPersonalDetails()
            
            let segueName = self.isLoggedIn ? InitialSegue.homeToDeshboardWithoutAnimation : InitialSegue.homeToDashboardSegue
            self.performSegue(withIdentifier: segueName, sender: self)
        }
    }
}

extension HomeViewController: SignupDelegate {
    
    func didSignup() {
        signUpToFirebase()
    }
}
