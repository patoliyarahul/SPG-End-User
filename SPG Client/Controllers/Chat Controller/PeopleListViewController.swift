//
//  PeopleListViewController.swift
//  SPG Stylist
//
//  Created by Dharmesh Vaghani on 20/02/17.
//  Copyright © 2017 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import Firebase


protocol PeopleListDelegate {
    func didSelectUser(user: User)
}

class PeopleListViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: - Variables
    
    private lazy var recentRef: FIRDatabaseReference = FIRDatabase.database().reference().child(FUserParams.FUSER_PATH)
    private var recentRefHandle: FIRDatabaseHandle?
    
    var sections = Array<Array<User>>()
    var users = Array<User>()
    
    var delegate : PeopleListDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(myTableView)
        loadUsers()
    }
    
    deinit {
        if let refHandle = recentRefHandle {
            recentRef.removeObserver(withHandle: refHandle)
        }
    }
    
    //MARK: - Helper Methods
    
    func loadUsers() {
        recentRefHandle = recentRef.queryOrdered(byChild: FUserParams.FUSER_TYPE).queryStarting(atValue: "stylist").queryEnding(atValue: "stylist").observe(.childAdded, with: { (snapshot) -> Void in // 1
            let userData = snapshot.value as! Dictionary<String, String> // 2
            if let email = userData[FUserParams.FUSER_EMAIL], email.characters.count > 0 { // 3
                self.users.append(User(dict: userData))
                self.refreshTableView()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    func refreshTableView() {
        setObject()
        myTableView.reloadData()
    }
    
    func setObject() {
        if sections.count != 0 { sections.removeAll() }
        
        let sectionTitleCount  = UILocalizedIndexedCollation.current().sectionTitles.count
        sections = Array<Array<User>>(repeating: Array<User>(), count: sectionTitleCount)
     
        for _ in 0..<sectionTitleCount {
            sections.append(Array<User>())
        }
        
        let selector : Selector = Selector(("fullname"))
        
        for user in users {
            let section = UILocalizedIndexedCollation.current().section(for: user, collationStringSelector: selector)
            sections[section].append(user)
        }
        
//        labelContacts.text = [NSString stringWithFormat:@"(%ld users)", (long) [dbusers count]];
        
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnCancel_Click(_ sender: Any) {
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

//MARK: - UITableView DataSource & Delegate
extension PeopleListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PeopleCell
        
        let user = sections[indexPath.section][indexPath.row]
        
        cell.lblFullName.text = user.fullname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section].count != 0 {
            return UILocalizedIndexedCollation.current().sectionTitles[section]
        }
        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles;
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = sections[indexPath.section][indexPath.row]
        delegate?.didSelectUser(user: user)
        
        self.dismiss(animated: true, completion: nil)
    }
}
