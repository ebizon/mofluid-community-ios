
//
//  AppDelegate.swift
//  Mofluid
//
//  Created by sudeep goyal on 08/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//Mofuid

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import CoreData
import Fabric
import Crashlytics
import Firebase
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift
import Stripe
var stateId = ""
var storeId : String? // ankur
var itemType = String() //ankur
var idForSelectedLangauge = "en"
var download_link_list = NSMutableDictionary()


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deviceToken:String? = nil
    var shoGroup: ShoppingGroup?
    var tabSelectedIndex: Int?
    var currentSelected: Int?
    var previousSelected: Int?
    internal func application(_ application: UIApplication,
                             didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Localize.setCurrentLanguage("en")
        let _ = LocaleManager.Instance //TODO : This initlize loacals, make it better
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_CmL6jnLZuHsp4i6DJg9yO4XJ"
        UserDefaults.standard.set(false, forKey: "isOpen")
        
        //if(UserDefaults.standard.string(forKey: Constants.AppBaseURL) != nil) {
            let tabView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController")
            window?.rootViewController = tabView
//        }
//        else{
//
//            let applogin = AppLoginVC(nibName:"AppLoginVC",bundle: nil)
//            window?.rootViewController = applogin
//        }
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!]
        UserDefaults.standard.set(false, forKey: "isTapped")
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "American Typewriter", size: 13)!], for: UIControl.State())
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:UIControl.State())
        
        self.initializeNotificationServices()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification(_:)), name:NSNotification.Name.MessagingRegistrationTokenRefreshed , object: nil)
        
        self.tabSelectedIndex = 0
        self.currentSelected = 0
        self.previousSelected = 0
        
        let payPalLiveId = Config.Instance.getPayPalLiveId()
        let payPalSandboxId = Config.Instance.getPayPalSandBoxId()
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: payPalLiveId, PayPalEnvironmentSandbox: payPalSandboxId])
        
        return true
    }
    
    func initializeNotificationServices() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    @objc func tokenRefreshNotification(_ notification:Notification) {
        let refreshedToken = InstanceID.instanceID().token()
        debugPrint("refreshedToken = \(String(describing: refreshedToken))")
        
    }
  

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //Even though the Facebook SDK can make this determinitaion on its own,
        //let's make sure that the facebook SDK only sees urls intended for it,
        //facebook has enough info already!
        let isFacebookURL = url.scheme != "" && url.scheme!.hasPrefix("fb\(String(describing: FBSDKSettings.appID()))") && url.host == "authorize"
        if isFacebookURL {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }else{
            
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        // ...register device token with our Time Entry API server via REST
        
        self.deviceToken = deviceTokenStr
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    fileprivate func convertDeviceTokenToString(_ deviceToken:Data) -> String {
        
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        
        var deviceTokenStr = deviceToken.description.replacingOccurrences(of: ">", with: "")
        
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: "<", with: "")
        
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: " ", with: "")
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercased()
        return deviceTokenStr
        
    }
    

    // Called when a notification is received and the app is in the
    // foreground (or if the app was in the background and the user clicks on the notification).
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let notification = userInfo["aps"] as? NSDictionary,
            
            let alert = notification["alert"] as? String {
          //  var alert1 = alert["body"] as? String ?? ""
            debugPrint(notification)
            if ( application.applicationState == .active )
            {
                let topWindow = UIWindow(frame: UIScreen.main.bounds)
                topWindow.rootViewController = UIViewController()
                topWindow.windowLevel = UIWindow.Level.alert + 1
                let alert = UIAlertController(title: "Mofluid", message: alert, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    topWindow.isHidden = true
                }))
                topWindow.makeKeyAndVisible()
                topWindow.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                
                _ = UIAlertController(title: "Mofluid", message: alert, preferredStyle: UIAlertController.Style.alert)
                
                application.applicationIconBadgeNumber = 0;
            }
            // Find the presented VC...
            var presentedVC = self.window?.rootViewController
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            //     presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
            
            completionHandler(UIBackgroundFetchResult.noData)
        }
        
    }

    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CartModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("PROJECTNAME.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

