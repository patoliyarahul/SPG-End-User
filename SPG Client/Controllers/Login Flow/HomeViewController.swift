//
//  HomeViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 04/10/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var btnTermsAndConditions: UIButton!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.borderColor = UIColor.white.cgColor
        btnSignUP.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefault.bool(forKey: Constant.userIsLogedIn) {
            self.performSegue(withIdentifier: InitialSegue.homeToDashboardSegue, sender: self)
        } else {
            imageView.alpha = 1.0
            logoImageView.alpha = 0.0
            btnLogin.alpha = 0.0
            btnSignUP.alpha = 0.0
            btnTermsAndConditions.alpha = 0.0
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
        if segue.identifier == InitialSegue.loginSegue {
            let nv = segue.destination as! UINavigationController
            let dv = nv.viewControllers[0] as! LoginViewController
            dv.delegte = self
            
        }else if segue.identifier == InitialSegue.signupSegue {
            let nv = segue.destination as! UINavigationController
            let dv = nv.viewControllers[0] as! SignUpViewController
            dv.delegate = self
        }
    }
}

//MARK: - Login SignupDeligate
extension HomeViewController: LoginDelegate {
    func didLogedIn() {
        self.performSegue(withIdentifier: InitialSegue.homeToDashboardSegue, sender: self)
    }
}

extension HomeViewController: SignupDelegate {
    
    func didSignup() {
        self.performSegue(withIdentifier: InitialSegue.homeToDashboardSegue, sender: self)
    }
}
