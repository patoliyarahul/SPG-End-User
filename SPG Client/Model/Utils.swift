//
//  Utils.swift
//  Allo Boulangerie
//
//  Created by Dharmesh Vaghani on 04/04/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

class Utils: NSObject {
    
    class func Show(_ message:String = "Please wait"){
        var load : MBProgressHUD = MBProgressHUD()
        
        load = MBProgressHUD.showAdded(to: UIApplication.shared.windows[0], animated: true)
        load.mode = MBProgressHUDMode.indeterminate
        load.labelText = message;
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.windows[0].addSubview(load)
    }
    
    class func HideHud(){
        MBProgressHUD.hide(for: UIApplication.shared.windows[0], animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    class func showAlert(_ title: String, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showToastMessage(_ message: String) {
        var toast: MBProgressHUD = MBProgressHUD()
        toast = MBProgressHUD.showAdded(to: UIApplication.shared.windows[0], animated: true)
        toast.labelText = message
        toast.mode = .text
        toast.yOffset = (Float(UIApplication.shared.windows[0].frame.size.height) / 2) - 50
        
        toast.removeFromSuperViewOnHide = true
        toast.hide(true, afterDelay: 1.5)
    }
    
    class func callServicePost(_ json: String, action: String, urlParamString: String, delegate: Any) {
        
        if ReachabilityManager.sharedInstance.isReachability {
            Utils.Show()
            
            var finalUrl = "\(Constant.URL_PREFIX)/\(action)"
            if !urlParamString.isEmpty {
                finalUrl = "\(finalUrl)?key=\(urlParamString)"
            }
            
            let requestManager: RequestManager = RequestManager()
            requestManager.commandName = action
            requestManager.delegate = delegate as! RequestManagerDelegate
            requestManager.callPostURL(finalUrl, parameters: json)
        } else {
            let alert = UIAlertController(title: "No Internet", message: "Please check your Internet connection.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Retry", style: .default) { (alert) in
                //                self.callServicePost(json, action: action, urlParamString: urlParamString, delegate: delegate)
            }
            
            let vc = delegate as! UIViewController
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func callPhotoUpload(dict: NSMutableDictionary, action: String, data: Data, delegate: Any, photoKey: String) {
        if ReachabilityManager.sharedInstance.isReachability {
            Utils.Show()
            
            let finalUrl = "\(Constant.URL_PREFIX)/\(action)"
            
            let requestManager: RequestManager = RequestManager()
            requestManager.commandName = action
            requestManager.delegate = delegate as! RequestManagerDelegate
            requestManager.callPhotoUpload(finalUrl, parameters: dict, imageData: data , photoKey: photoKey)
        } else {
            let alert = UIAlertController(title: "No Internet", message: "Please check your Internet connection.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Retry", style: .default) { (alert) in
            }
            
            let vc = delegate as! UIViewController
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func callServiceGet(_ action: String, urlParamString: String, delegate: Any) {
        
        if ReachabilityManager.sharedInstance.isReachability {
            Utils.Show()
            
            var finalUrl = "\(Constant.URL_PREFIX)/\(action)"
            if !urlParamString.isEmpty {
                finalUrl = "\(finalUrl)?key=\(urlParamString)"
            }
            
            let requestManager : RequestManager = RequestManager()
            requestManager.commandName = action
            requestManager.delegate = delegate as! RequestManagerDelegate
            requestManager.callGetURL(finalUrl, parameters: nil)
        } else {
            let alert = UIAlertController(title: "No Internet", message: "Please check your Internet connection.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Retry", style: .default) { (alert) in
            }
            
            let vc = delegate as! UIViewController
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func postingString(_ params: Dictionary<String, String>?) -> String {
        guard let dictParams = params else {
            return ""
        }
        
        var postString = ""
        
        for (key, value) in dictParams {
            
            if value.characters.count != 0 {
                postString += "&" + key + "=" + value
            }
        }
        
        return postString
    }
    
    class func downloadImage(_ url: String, imageView: UIImageView) {
        
        let finalUrl = "\(Constant.URL_PREFIX)/\(url)"
        
        if let encodedString = finalUrl.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlFragmentAllowed),
            let url = URL(string: encodedString) {
            
            imageView.af_setImage(withURL: url)
        }
    }
    
    class func storeResponseToUserDefault(_ resultObject: AnyObject) {
        userDefault.set(true, forKey: Constant.userIsLogedIn)
        
        for key in resultObject.allKeys {
            
            if resultObject.object(forKey: key) is NSNull {
                userDefault.set("", forKey: key as! String)
            } else {
                
                if (resultObject.object(forKey: key)! as AnyObject).isKind(of: NSDictionary.self) {
                    storeResponseToUserDefault(resultObject.object(forKey: key) as! NSDictionary)
                } else {
                    userDefault.set(resultObject.object(forKey: key), forKey: key as! String)
                }
            }
        }
        
        UserDefaults().synchronize()
    }
}


func getTimeStampToTime(_ timeStamp: String) -> String {
    //TimeStamp
    let timeInterval  = 1415639000.67457
    print("time interval is \(timeInterval)")
    
    //Convert to Date
    let date = Date(timeIntervalSince1970: timeInterval)
    
    //Date formatting
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd, MMM yyyy"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let dateString = dateFormatter.string(from: date)
    print("formatted date is =  \(dateString)")
    return dateString
}

func currentTimeMillis() -> Int64{
    let nowDouble = Date().timeIntervalSince1970
    return Int64(nowDouble*1000)
}

func configureTableView(_ myTableView: UITableView) {
    myTableView.tableFooterView = UIView()
    myTableView.rowHeight = UITableViewAutomaticDimension
    myTableView.estimatedRowHeight = 87.0
}

func setValueFromUserDefaultToTextField(textField: UITextField, key: String) {
    if let str = userDefault.string(forKey: key) {
        textField.text = str
    }
}

func reloadTableViewWithAnimation(myTableView: UITableView) {
    let range = NSMakeRange(0, myTableView.numberOfSections)
    let sections = NSIndexSet(indexesIn: range)
    myTableView.reloadSections(sections as IndexSet, with: .automatic)
}

func getAttributedTextWithSpacing(text: String) -> NSMutableAttributedString {
    let attributedAddress = NSMutableAttributedString(string: text)
    let mutableParagraphStyle = NSMutableParagraphStyle()
    mutableParagraphStyle.lineSpacing = 5
    
    attributedAddress.addAttribute(NSParagraphStyleAttributeName, value: mutableParagraphStyle, range: NSMakeRange(0, text.characters.count))
    
    return attributedAddress
}

func checkWeatherDictIsInArray(sourceDictArray: [Dictionary<String, String>], dict: Dictionary<String, String>, key: String) -> (Bool, Int) {
    var index = 0
    for tempDict in sourceDictArray {
        if tempDict[key] == dict[key] {
            return (true, index)
        }
        index += 1
    }
    return (false, index)
}


struct Time {
    
    let start: TimeInterval
    let end: TimeInterval
    let interval: TimeInterval
    
    init(start: TimeInterval, interval: TimeInterval, end: TimeInterval) {
        self.start = start
        self.interval = interval
        self.end = end
    }
    
    init(startHour: TimeInterval, intervalMinutes: TimeInterval, endHour: TimeInterval) {
        self.start = startHour * 60 * 60
        self.end = endHour * 60 * 60
        self.interval = intervalMinutes * 60
    }
    
    var timeRepresentations: [String] {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .positional
        dateComponentFormatter.allowedUnits = [.minute, .hour]
        
        let dateComponent = NSDateComponents()
        return timeIntervals.map { timeInterval in
            dateComponent.second = Int(timeInterval)
            return dateComponentFormatter.string(from: dateComponent as DateComponents)!
        }
    }
    
    var timeIntervals: [TimeInterval] {
        return Array(stride(from: start, to: end, by: interval))
    }
}

extension Date {
    func stringDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func dateFromString(format: String, dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)!
    }
    
}


