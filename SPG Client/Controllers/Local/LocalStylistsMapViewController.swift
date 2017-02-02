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

class LocalStylistsMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnSwitch: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var arrStylist = [Dictionary<String,String>]()
    var selectedIndexPath = IndexPath (row: 0, section: 0)
    var detailInfo = Dictionary<String, Any>()
    let locationManager = CLLocationManager()
    var isInitialized = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(tableView)
        tableView.alpha = 0
        mapView.isHidden = true
        tableView.isHidden = true
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: - Helper Methods
    
    func callService(lat: Double, long: Double) {
        let innerJson = [Request.pass_data : [Map.latitude: String(lat), Map.longitude: String(long), Map.radius: "100000000", Map.offset: "0"] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getLocalStylistList, urlParamString: "", delegate: self)
    }
    
    func callServiceForProfileDetail() {
        
        var dict = Dictionary<String, String>()
        dict = arrStylist[selectedIndexPath.row]
        
        let innerJson = [Request.pass_data : [StylistListParams.stylistId : dict[StylistListParams.stylistId]!] as Dictionary<String, String>] as Dictionary<String, Any>
        innerJson.printJson()
        Utils.callServicePost(innerJson.json, action: Api.getStylistProfile, urlParamString: "", delegate: self)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnSwitchClicked(_ sender: Any) {
        if mapView.isHidden {
            tableView.isHidden = true
            mapView.isHidden = false
            btnSwitch.image = UIImage(named: "map")
        } else {
            tableView.isHidden = false
            mapView.isHidden = true
            btnSwitch.image = UIImage(named: "list")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StylistSegue.stylistDetailSegue {
            let dv = segue.destination as! StylistProfileVC
            dv.detailsDict = detailInfo
        }
    }

}

//MARK: - UITableViewDelegate And Datasource Methods

extension LocalStylistsMapViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StylistTableViewCell
        
        var dict = Dictionary<String, String>()
        
        dict = arrStylist[indexPath.row] as Dictionary<String, String>
        
        if dict[BusinessInfoParams.businessName]!.characters.count > 0 {
            cell.lblStylistname.text = dict[BusinessInfoParams.businessName]!
        }else {
            cell.lblStylistname.text = " "
        }
        
        if dict[BusinessInfoParams.profession]!.characters.count > 0 {
            cell.lblService.text = dict[BusinessInfoParams.profession]!
        }else {
            cell.lblService.text = " "
        }
        
        let f : Float? = Float(dict[BusinessInfoParams.distance]!)
        cell.lblDistance.text = String(format: "%0.2f miles away", f!)
        
        if dict[BusinessInfoParams.logoImage]! != "" && dict[BusinessInfoParams.logoImage]! != "not define" {
            let url = ImageDirectory.logoDir + "\(dict[BusinessInfoParams.logoImage]!)"
            Utils.downloadImage(url, imageView: cell.imgProfile)
        }
        
        let address = "\(dict[BusinessInfoParams.businessStreet]!), \(dict[BusinessInfoParams.businessSuit]!), \(dict[BusinessInfoParams.businessCity]!), \(dict[BusinessInfoParams.businessState]!), \(dict[BusinessInfoParams.businessZipcode]!)"
        
        
        if getAttributedTextWithSpacing(text: address).length > 0 {
            cell.lblAddress.attributedText = getAttributedTextWithSpacing(text: address)
        }else {
            cell.lblAddress.attributedText = getAttributedTextWithSpacing(text: "")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        callServiceForProfileDetail()
    }
}

//MARK: - RequestManager Delegate Methods

extension LocalStylistsMapViewController: RequestManagerDelegate {
    func onResult(_ result: Any!, action: String!, isTrue: Bool) {
        Utils.HideHud()
        
        if let resultDict:[String: AnyObject] = result as? [String : AnyObject] {
            if resultDict[MainResponseParams.success] as! NSNumber == NSNumber(value: 1) {
                
                if action == Api.getLocalStylistList {
                    arrStylist   = resultDict["data"] as! [Dictionary<String, String>]
                    
                    if arrStylist.count > 0 {
                        tableView.alpha = 1;
                        tableView.isHidden = false
                        reloadTableViewWithAnimation(myTableView: tableView)
                        
                        var i: Int = 0
                        for dict:Dictionary<String, String> in arrStylist {
                            let annotation = MKPointAnnotation()
                            annotation.title = dict[BusinessInfoParams.businessName]
                            let lat : Double = Double(dict[BusinessInfoParams.businessLat]!)!
                            let long : Double = Double(dict[BusinessInfoParams.businessLong]!)!
                            annotation.subtitle = "\(i)"
                            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            mapView.addAnnotation(annotation)
                            
                            if i == 0 {
                                let latDelta: CLLocationDegrees = 0.5
                                let lonDelta: CLLocationDegrees = 0.5
                                let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                                let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                                mapView.setRegion(region, animated: true)
                                mapView.showsUserLocation = false
                            }
                            i += 1
                        }
                        
                    }
                } else if action == Api.getStylistProfile {
                    if let details : Dictionary<String, Any> = resultDict[MainResponseParams.data] as? Dictionary<String, Any> {
                        detailInfo = details
                        self.performSegue(withIdentifier: StylistSegue.stylistDetailSegue, sender: self)
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

extension LocalStylistsMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isInitialized {
            // Here is called only once
            isInitialized = true
            
            let userLoction: CLLocation = locations[0]
            let latitude = userLoction.coordinate.latitude
            let longitude = userLoction.coordinate.longitude
            //            let latDelta: CLLocationDegrees = 0.05
            //            let lonDelta: CLLocationDegrees = 0.05
            //            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            //            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            //            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            //            mapView.setRegion(region, animated: true)
            //            mapView.showsUserLocation = false
            
            print("lat",latitude)
            print("long",longitude)
            callService(lat: latitude, long: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:"+error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print(view.annotation?.subtitle?! ?? 0)
        let i : Int? = Int(((view.annotation?.subtitle)!)!)
        print(i!)
        print(arrStylist[i!])
        
        selectedIndexPath = IndexPath(row: i!, section: 0)
        callServiceForProfileDetail()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
}

