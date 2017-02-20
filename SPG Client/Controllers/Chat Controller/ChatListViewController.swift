//
//  ChatListViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 08/02/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

import Firebase

class ChatListViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: - Variables
    
    var recents: [Recent] = [] // 3
    
    private lazy var recentRef: FIRDatabaseReference = FIRDatabase.database().reference().child(FRecentParams.FRECENT_PATH)
    private var recentRefHandleNew: FIRDatabaseHandle?
    private var recentRefHandleChange: FIRDatabaseHandle?
    
    let dateFormatter = DateFormatter()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        configureTableView(myTableView)
        observeChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        if let selection = myTableView.indexPathForSelectedRow {
            myTableView.deselectRow(at: selection, animated: true)
        }
    }
    
    deinit {
        if let refHandle = recentRefHandleNew {
            recentRef.removeObserver(withHandle: refHandle)
        }
        
        if let refHandle = recentRefHandleChange {
            recentRef.removeObserver(withHandle: refHandle)
        }
    }
    
    //MARK: - Helper Methods
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        
        let userId = FIRAuth.auth()?.currentUser?.uid
        
        recentRefHandleNew = recentRef.queryOrdered(byChild: FRecentParams.FRECENT_USERID).queryStarting(atValue: userId).queryEnding(atValue: userId).observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            if let name = channelData[FRecentParams.FRECENT_USERID] as! String!, name.characters.count > 0 { // 3
                self.recents.append(Recent(dict: channelData))
                self.sortRecentArray()
                reloadTableViewWithAnimation(myTableView: self.myTableView)
            } else {
                print("Error! Could not decode channel data")
            }
        })
        
        recentRefHandleChange = recentRef.queryOrdered(byChild: FRecentParams.FRECENT_USERID).queryStarting(atValue: userId).queryEnding(atValue: userId).observe(.childChanged, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            if let name = channelData[FRecentParams.FRECENT_USERID] as! String!, name.characters.count > 0 { // 3
                
                if let index = self.recents.index(where: { $0.userId == "\(channelData[FRecentParams.FRECENT_USERID]!)" }) {
                    self.recents[index] = Recent(dict: channelData)
                }
                
                self.sortRecentArray()
                reloadTableViewWithAnimation(myTableView: self.myTableView)
                
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    func sortRecentArray() {
        recents.sort {
            
            let date1 = Date(timeIntervalSince1970: Double("\($0.lastMessageDate)")!)
            let date2 = Date(timeIntervalSince1970: Double("\($1.lastMessageDate)")!)
            
            return date1 > date2
        }
    }
    
    //MARK: - UIButton Action Methods
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "peopleSegue" {
            let navController = segue.destination as! UINavigationController
            
            let dv = navController.viewControllers[0] as! PeopleListViewController
            dv.delegate = self
        }
        
        if let recent = sender as? Recent {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.recentDict = [FRecentParams.FRECENT_GROUPID : recent.groupId, FRecentParams.FRECENT_MEMBERS : "", FRecentParams.FRECENT_DESCRIPTION : recent.description,FRecentParams.FRECENT_TYPE : "private"]
        }
        
    }
}

//MARK: - UITableView Delegate & Datasource Methods

extension ChatListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatListCell
        
        let recent = recents[indexPath.row]
        
        let date = Date(timeIntervalSince1970: Double("\(recent.lastMessageDate)")!)
        
        cell.lblName.text = recent.description
        cell.lblLastMessage.text = recent.lastMessage
        cell.lblDate.text = dateFormatter.string(from: date)
        
        cell.profilePic.image = #imageLiteral(resourceName: "userpic")
        
        if recent.picture.characters.count > 0 {
            let logoUrl = ImageDirectory.logoDir + "\(recent.picture)"
            Utils.downloadImage(logoUrl, imageView: cell.profilePic)
        }
        
        cell.lblCount.alpha = 0
        cell.lblCount.text = ""
        
        if Int(recent.counter)! > 0 {
            cell.lblCount.alpha = 1
            cell.lblCount.text = "\(recent.counter) new"
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recent = recents[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: ChatSeuge.showChatSegue, sender: recent)
    }
}

//MARK: - PeopleList Delegate Method

extension ChatListViewController: PeopleListDelegate {
    func didSelectUser(user: User) {
        Chat_Utils.startPrivateChat(email: "\(user.email)", completionHandler: { (dict: Dictionary<String, Any>) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            
            chatViewController.recentDict = dict
            
            self.show(chatViewController, sender: self)
        })
    }
}
