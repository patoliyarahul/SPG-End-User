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

class LocalStylistsMapViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnSwitch: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stylistDetailView: UIView!
    @IBOutlet weak var lblStylistname: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var stylistDetailBottom: NSLayoutConstraint!
    @IBOutlet weak var btnStylistDetails: UIButton!
    
    //MARK: - Variables
    
    var arrStylist = [Dictionary<String,String>]()
    var selectedIndexPath = IndexPath (row: 0, section: 0)
    var detailInfo = Dictionary<String, Any>()
    let locationManager = CLLocationManager()
    var isInitialized = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        stylistDetailBottom.constant = -stylistDetailView.frame.size.height
        
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
        
        stylistDetailBottom.constant = -stylistDetailView.frame.size.height
        
        if mapView.isHidden {
            resetAnnotationImage()
            tableView.isHidden = true
            mapView.isHidden = false
            btnSwitch.image = UIImage(named: "list")
        } else {
            tableView.isHidden = false
            mapView.isHidden = true
            btnSwitch.image = UIImage(named: "map")
        }
        
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func btnShowStylistDetails_Click(_ sender: Any) {
        
        let tag = (sender as! UIButton).tag
        
        selectedIndexPath = IndexPath(row: tag, section: 0)
        callServiceForProfileDetail()
    }
    
    
    //MARK: - UINavigation Methods
    
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

//MARK: - MKMapDelegate Methods

extension LocalStylistsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.image = #imageLiteral(resourceName: "mapDefaultPin")
            anView?.canShowCallout = false
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView?.annotation = annotation
        }
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        resetAnnotationImage()
        
        let i : Int = Int(((view.annotation?.subtitle)!)!)!
        
        view.image = #imageLiteral(resourceName: "mapSelectedPin")
        
        let dict = arrStylist[i]
        setAttributesToMapStylistDetails(dict: dict)
        btnStylistDetails.tag = i
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        resetAnnotationImage()
        showHideStylistDetailsView(show: false)
    }
    
    func setAttributesToMapStylistDetails(dict : Dictionary<String, String>) {
        
        lblStylistname.text = dict[BusinessInfoParams.businessName]!
        lblService.text = dict[BusinessInfoParams.profession]!
        
        if dict[BusinessInfoParams.logoImage]! != "" && dict[BusinessInfoParams.logoImage]! != "not define" {
            let url = ImageDirectory.logoDir + "\(dict[BusinessInfoParams.logoImage]!)"
            Utils.downloadImage(url, imageView: imgProfile)
        }
        
        let address = "\(dict[BusinessInfoParams.businessStreet]!), \(dict[BusinessInfoParams.businessSuit]!), \(dict[BusinessInfoParams.businessCity]!), \(dict[BusinessInfoParams.businessState]!), \(dict[BusinessInfoParams.businessZipcode]!)"
        
        lblAddress.attributedText = getAttributedTextWithSpacing(text: address)
        
        showHideStylistDetailsView(show: true)
    }
    
    func showHideStylistDetailsView(show: Bool) {
        stylistDetailView.layoutIfNeeded()
        if show {
            stylistDetailBottom.constant = 0
        } else {
            stylistDetailBottom.constant = -stylistDetailView.frame.size.height
        }
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAnnotationImage() {
        for annotation in mapView.annotations {
            let viewI = mapView.view(for: annotation)
            
            if !(viewI?.annotation is MKUserLocation){
                viewI?.image = #imageLiteral(resourceName: "mapDefaultPin")
            }
        }
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
}

