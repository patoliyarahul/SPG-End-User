//
//  MyLookBooksViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/8/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import CoreData

class MyLookBooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - IBOutlet
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    let lookBooksTitles = ["My NewLookbook", "Sarah's Fav", "Summer Heat", "Winter Wonderland", "Fall into Fall"]
    let lookBooksDescriptions = ["0 IMAGES", "261 IMAGES", "150 IMAGES", "50 IMAGES", "142 IMAGES"]
    let imageArray = [UIImage(named:"lookbook_default_thumbnail"), UIImage(named:"Sarah's Fav_pic"), UIImage(named:"Summer Heat_pic"), UIImage(named:"Winter Wonderland_pic"), UIImage(named: "Fall into Fall_pic")]
    var selectedTitle : String = ""
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "Gotham Book", size: 13)!
        cancelButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        layout.itemSize = CGSize(width: screenWidth/2, height: 225)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    //MARK: - Helper & Initialization Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lookBooksTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lookbooksCollectionViewCell", for: indexPath) as! myLookBooksCollectionViewCell
        cell.titleLabel.text = lookBooksTitles[indexPath.row]
        cell.descriptionLabel.text = lookBooksDescriptions[indexPath.row]
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTitle = lookBooksTitles[indexPath.row]
        performSegue(withIdentifier: "displayLookbook", sender: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func cancelButton_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton_Click(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Lookbook", message: "Use this to hold all of your ideas and favorite styles.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {
            (textField) -> Void in
        })
        alert.textFields?[0].placeholder = "My New Lookbook"
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            (action) -> Void in
            let textF = (alert.textFields?[0])! as UITextField
            print(textF.text!)
            
            //CHECK IF THE TEXT FIELD IS NOT EMPTY
            if (textF.text?.isEmpty)!{
                
            } else {
//                //CHECK IF THE TEXT FIELD DOESN'T ALREADY MATCH AN ENTRY
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let context = appDelegate.persistentContainer.viewContext
//                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DriverInfo")
//                request.returnsObjectsAsFaults = false
//                
//                do{
//                    let results = try context.fetch(request)
//                    if results.count > 0 {
//                        self.drivers.removeAll()
//                        for result in results as! [NSManagedObject] {
//                            if let driverName = result.value(forKey: "driverName") as? String {
//                                print("Driver:"+driverName)
//                                self.drivers.append(driverName)
//                            }
//                        }
//                    }
//                } catch {
//                    //PROCESS ERROR HERE
//                }
//                var itsaNewDriver : Bool = true
//                for driver in 0 ..< self.drivers.count {
//                    if self.drivers[driver] == textF.text {
//                        //DRIVER NAME ALREADY EXISTS
//                        itsaNewDriver = false
//                        break
//                    }
//                }
//                if itsaNewDriver {
//                    //ADD DRIVER NAME TO DATABASE AND PERFORM SEGUE WITH NEW DRIVER NAME
//                    let newDriver = NSEntityDescription.insertNewObject(forEntityName: "DriverInfo", into: context)
//                    newDriver.setValue(textF.text, forKey: "driverName")
//                    self.selectedDriverName = textF.text!
//                    self.performSegue(withIdentifier: "showDriverInfo", sender: self)
//                } else {
//                    //LET THE USER KNOW THE DRIVER THEY'RE TRYING TO ENTER ALREADY EXISTS
//                    print("This driver already exists")
//                }

            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) -> Void in
//            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayLookbook" {
            let vc = segue.destination as! LookbookDisplayViewController
            vc.lookbookTitle = selectedTitle
        }
    }
    
    

}
