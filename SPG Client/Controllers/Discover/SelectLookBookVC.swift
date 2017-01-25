//
//  SelectLookBookVC.swift
//  SPG Client
//
//  Created by Dharmik Ghelani on 15/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

protocol SelectLokBookDelegate {
    func didSelectLookBook(lookBookId: String)
}

class SelectLookBookVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var noLookBookView: UIView!
    
    //MARK: - Variables
    var arrLookBook =   [Dictionary<String, String>]()
    var delegate: SelectLokBookDelegate?
    
    var selectedLookBookId : String = "0"
    
    var previousSelectedIndex: IndexPath?
    
    let selectedBgColor = UIColor(red: 241.0/255, green: 243.0/255, blue: 249.0/255, alpha: 1)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView(myTableView)
        callService()
    }
    
    //MARK: - Helper Methods
    
    func callService() {
        let innerJson = ["pass_data" : [ EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getAllLookBook, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnAdd_Click(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a Lookbook", message: "Use this to hold all of your ideas and favorite styles.", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {(textField: UITextField) -> Void in
            textField.placeholder = "My new Lookbook"
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        let saveAction  =  UIAlertAction(title: "SAVE", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            if (textField.text?.characters.count)! > 0 {
                let innerJson = ["pass_data" : [EndUserParams.endUserID : userDefault.string(forKey: EndUserParams.endUserID)!, "lookbook_name" : textField.text!] as Dictionary<String, String>] as Dictionary<String, Any>
                innerJson.printJson()
                
                Utils.callServicePost(innerJson.json, action: Api.addLookBook, urlParamString: "", delegate: self)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Extra Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - UITableView Delegate Methods

extension SelectLookBookVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLookBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectLookBookCell
        
        let dict = arrLookBook[indexPath.row]
        
        cell.lblLookbookName.text   =   "\(dict[LookBookParams.lookBookName]!)"
        cell.lblNoofPhotos.text     =   "\(dict[LookBookParams.lookBookTotalImg]!) IMAGES"
        
        cell.bgView.backgroundColor = UIColor.clear
        
        if selectedLookBookId == "\(dict[LookBookParams.lookBookId]!)" {
            cell.bgView.backgroundColor = selectedBgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if previousSelectedIndex != indexPath {
            
            let dict = arrLookBook[indexPath.row]
            selectedLookBookId = dict[LookBookParams.lookBookId]!
            if let prevIndexpath = previousSelectedIndex {
                myTableView.reloadRows(at: [prevIndexpath ,indexPath], with: .automatic)
            } else {
                myTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            delegate?.didSelectLookBook(lookBookId: selectedLookBookId)
            
            previousSelectedIndex = indexPath
        }
    }
}

//MARK: - Request Manager Methods
extension SelectLookBookVC: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                if (action == Api.getAllLookBook) || (action == Api.addLookBook) {
                    arrLookBook = resultDict[MainResponseParams.data] as! [Dictionary<String, String>]
                    
                    if arrLookBook.count > 0 {
                        reloadTableViewWithAnimation(myTableView: myTableView)
                    } else {
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.noLookBookView.alpha = 1
                        })
                    }
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
