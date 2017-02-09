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
    
    var channels: [Channel] = [] // 3
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    private var channelRefHandle: FIRDatabaseHandle?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(myTableView)
        observeChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    //MARK: - Helper Methods
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
                self.channels.append(Channel(id: id, name: name))
                reloadTableViewWithAnimation(myTableView: self.myTableView)
            } else {
                print("Error! Could not decode channel data")
            }
        })
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
        
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = "\(userDefault.string(forKey: ClientsParams.firstName)!) \(userDefault.string(forKey: ClientsParams.lastName)!)"
            chatVc.channelRef = channelRef.child(channel.id)
            chatVc.channel = channel
        }
    }
}

//MARK: - UITableView Delegate & Datasource Methods

extension ChatListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatListCell
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: ChatSeuge.showChatSegue, sender: channel)
    }
}
