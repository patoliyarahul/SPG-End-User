//
//  AppDelegate.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 04/10/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    //Variables for book appointment
    
    var serviceListArray    =   [Dictionary<String, String>]()
    var desiredLookArray    =   [Dictionary<String, String>]()
    
    var serviceListId       =   ""
    
    var appointmentDate     =   ""  // SelectDateVC
    var appointmentTime     =   ""  // SelectDateVC
    var stylistId           =   ""  // StylistProfileVC
    var stylistName         =   ""  // StylistProfileVC
    var stylistLogo         =   ""  // StylistProfileVC
    var stylistAddress      =   ""  // StylistProfileVC
    var appointmentNotes    =   ""
    var selfieImage         =   UIImage()
    
    var totalLength         =   0
    var totalPrice          =   0.0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // ----------------- * Push notification Start*-----------------
        registerForPushNotifications(application: application)
        
        
        //        //        var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        //
        //        //        var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        //
        //        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        //        UIApplication.shared.registerUserNotificationSettings(settings)
        //
        ////        DispatchQueue.main.async {
        ////            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        ////            UIApplication.shared.registerUserNotificationSettings(settings)
        ////        }
        // ----------------- * Push notification End *-----------------
        
        
        IQKeyboardManager.sharedManager().enable = true
        _ = ReachabilityManager.sharedInstance.isReachability
        
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Gotham Book", size: 19)!]
        
        if Platform.isSimulator {
            userDefault.set("12345678912345689", forKey:Device.device_id)
        }
        
        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted){
                    UIApplication.shared.registerForRemoteNotifications()
                }else {
                    //Do stuff if unsuccessful...
                    print("push notification registrastion unsuccessful.")
                }
            })
        }else { //If user is not on iOS 10 use the old methods we've been using
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
        print("willPresent")
        print("notification---->",notification)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        print("didReceive")
        print("response------>",response)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        print("Token :",token)
        userDefault.set(token, forKey:Device.device_id)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //For simulator
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
}

