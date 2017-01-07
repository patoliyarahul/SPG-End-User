//
//  LocalStylistsMapViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/10/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocalStylistsMapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapViewListSwitchButton: UIBarButtonItem!
    
    //MARK: - Variables
//    let dataSim : BusinessDataSim = BusinessDataSim()
    var imageArray : [UIImage]? = nil
    var bannerArray : [UIImage]? = nil
//    var posts = [BusinessDataModel]()
    let locationManager = CLLocationManager()
    var selectedIndex : Int = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "Gotham Book", size: 13)!
        mapViewListSwitchButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        
        
//        imageArray = dataSim.logoArray
//        bannerArray = dataSim.bannerArray
//        getDatabase()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

        let buttonItem : MKUserTrackingBarButtonItem  = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = buttonItem;
        
//        print("\nLate\n")
//        
//        for index in 0 ..< posts.count {
//            print("\nHello\n")
//            let location = CLLocationCoordinate2DMake(
//                Double(posts[index].latitude)!,Double(posts[index].longitude)!)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = posts[index].businessName
//            annotation.subtitle = posts[index].businessCategory
//            mapView.addAnnotation(annotation)
//            
//        }
//        print(posts.count)
//        print("\nGoodbye\n")
        
//        let location = CLLocationCoordinate2DMake(48.88182, 2.43952)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "Pizza Pistorante"
//        annotation.subtitle = "Luna Rossa"
//        let span = MKCoordinateSpanMake(0.002, 0.002)
//        let region = MKCoordinateRegion(center: location, span: span)
//        mapView.setRegion(region, animated: true)
//        mapView.addAnnotation(annotation)
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func mapSwitchButton_Click(_ sender: UIBarButtonItem) {
        if !mapView.isHidden {
            mapViewListSwitchButton.title = "Map"
            mapView.isHidden = true
            tableView.isHidden = false
        } else {
            mapViewListSwitchButton.title = "List"
            mapView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    //MARK: - Helper & Initialization Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "openStylistProfile", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationListingTableViewCell", for: indexPath) as! locationListingTableViewCell
//        cell.nameLabel.text = posts[indexPath.row].businessName
//        cell.addressLabel.text = posts[indexPath.row].businessAddress
//        cell.categoryLabel.text = posts[indexPath.row].businessCategory
        
        
        cell.stylistImage?.image = imageArray?[indexPath.row]
        return cell
    }
    
//    func getDatabase() {
//        let databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("stylists").queryOrderedByKey().observe(.childAdded, with: {
//            snapshot in
//            let businessName = (snapshot.value as? NSDictionary)?["businessName"] as! String
//            let businessCategory = (snapshot.value as? NSDictionary)?["businessCategory"] as! String
//            let businessAddress = (snapshot.value as? NSDictionary)?["businessAddress"] as! String
//            let businessWebAddress = (snapshot.value as? NSDictionary)?["businessWebAddress"] as! String
//            let latitude = (snapshot.value as? NSDictionary)?["latitude"] as! String
//            let longitude = (snapshot.value as? NSDictionary)?["longitude"] as! String
//            
//            let location = CLLocationCoordinate2DMake(
//                Double(latitude)!,Double(longitude)!)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = businessName
//            annotation.subtitle = businessCategory
//            self.mapView.addAnnotation(annotation)
//            
//            
//            let busModel = BusinessDataModel()
//            busModel.businessName =  businessName
//            busModel.businessCategory = businessCategory
//            busModel.businessAddress = businessAddress
//            busModel.businessWebAddress = businessWebAddress
//            busModel.latitude =  latitude
//            busModel.longitude =  longitude
//            self.posts.append(busModel)
//            self.tableView.reloadData()
//        })
//    }
    
    //MARK: - Location Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03125, longitudeDelta: 0.03125))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors:"+error.localizedDescription)
    }
    
    //MARK: - TableView Delegate Methods
    
    
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
        if segue.identifier == "openStylistProfile" {
//            let vc = segue.destination as! StylistProfileViewController
//            vc.stylistNameStr = posts[selectedIndex].businessName!
//            vc.stylistCategoryStr = posts[selectedIndex].businessCategory!
//            vc.stylistAddressStr = posts[selectedIndex].businessAddress!
//            vc.logoImage = imageArray![selectedIndex]
//            vc.bannerImage = bannerArray![selectedIndex]
//            vc.recentWorkArray = dataSim.recentWork[selectedIndex]
//            vc.services = dataSim.services
        }
    }
    
}
