//
//  HomeScreenViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/7/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

class DashboardViewController : UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: - Variables
    let arrImage = [UIImage(named:"featured_stylists"), UIImage(named:"featured_hair"), UIImage(named:"featured_gents")]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_header"))
        configureTableView()
    }
    
    //MARK: - UINavigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let nv = segue.destination as! UINavigationController
            let dv = nv.viewControllers[0] as! ProfileViewController
            dv.delegate = self
        }
    }
    
    func configureTableView() {
        
        let nibHeader = UINib(nibName: "DashboardImageBoardView", bundle: nil)
        myTableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "DashboardImageBoardView")
        
        myTableView.tableFooterView = UIView()
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 159.0
    }
}

//MARK: - UITableview Delegate & Datasource

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DashboardTableViewCell
        
        cell.imgView.image = arrImage[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DashboardImageBoardView")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (Constant.screenSize.height * 35.23)/100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - Profile Delegate 

extension DashboardViewController : ProfileDelegate {
    
    func shouldLogout() {
        userDefault.set(false, forKey: Constant.userIsLogedIn)
        _ = self.tabBarController?.navigationController?.popToRootViewController(animated: true)
    }
}


