//
//  ServicesListVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 06/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class ServicesListVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var lblStylistName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: - Variables
    
    var serviceArray            =   [Dictionary<String, String>]()
    
    var profession          =   ""
    var stylistName         =   ""
    var logoUrl             =   ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setText()
        configureTableView(myTableView)
    }
    
    //MARK: - Helper Methods
    
    func setText() {
        lblStylistName.text =   stylistName
        lblProfession.text  =   profession
        Utils.downloadImage(logoUrl, imageView: imgLogo)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnChooseDate_Click(_ sender: Any) {
        self.performSegue(withIdentifier: StylistSegue.chooseDateSegue, sender: self)
    }
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StylistSegue.chooseDateSegue {
            let dv = segue.destination as! SelectDateVC
            dv.stylistName          =   lblStylistName.text!
            dv.profession           =   lblProfession.text!
            dv.logoUrl              =   logoUrl
        }
    }
}

//MARK: - UITableVeiw Delegate & Datasource Methods

extension ServicesListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if serviceArray.count > 3 {
            return 3
        } else if serviceArray.count > 0 {
            return serviceArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if serviceArray.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceSelectionCell
            
            let dict = serviceArray[indexPath.item]
            
            cell.lblServiceName.text    =   "\(dict[ServicesParams.serviceName]!)"
            cell.lblPrice.text          =   "$\(dict[ServicesParams.price]!)"
            
            cell.btnSelect.addTarget(self, action: #selector(StylistProfileVC.btnSelect_Click(_:)), for: .touchUpInside)
            
            var image = UIImage(named: "btnSelect")
            
            if checkWeatherDictIsInArray(sourceDictArray: appDelegate.serviceListArray, dict: dict, key: ServicesParams.serviceId).0 {
                image = UIImage(named: "btnSelect_active")
            }
            
            cell.btnSelect.setImage(image, for: .normal)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoServiceCell", for: indexPath)
            return cell
        }
    }
    
    func btnSelect_Click(_ sender: AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: myTableView)
        let indexPath = myTableView.indexPathForRow(at: buttonPosition)
        
        let dict = serviceArray[(indexPath?.row)!]
        
        let result = checkWeatherDictIsInArray(sourceDictArray: appDelegate.serviceListArray, dict: dict, key: ServicesParams.serviceId)
        
        if result.0 {
            appDelegate.serviceListArray.remove(at: result.1)
        } else {
            appDelegate.serviceListArray.append(dict)
        }
        
        myTableView.reloadRows(at: [indexPath!], with: .automatic)
    }
    
}
