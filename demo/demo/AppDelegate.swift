//
//  AppDelegate.swift
//  demo
//
//  Created by mac on 03/07/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var getDataBase : String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppDelegate.getDataBase = AppDelegate.getDataBasePath()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    static func getDataBasePath() -> String {
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true ).first else {return ""}
        
        // MARK:  for database file get
        var dataBasePath : NSString = documentDirectory as NSString
        dataBasePath = dataBasePath.appendingPathComponent("ProductDB.db") as NSString
        print("Database Path :- \(dataBasePath)")
        
        // MARK: databse file get from bundle
        let getBundlePath = Bundle.main.path(forResource: "ProductDB", ofType: "db")
        
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: dataBasePath  as String) {
            do {
                try fileManager.copyItem(at: URL(fileURLWithPath: getBundlePath ?? ""), to: URL(fileURLWithPath: dataBasePath as String))
                print("File Copied")
                return dataBasePath as String
            }
            catch {
                print(error.localizedDescription)
                return ""
            }
        } else {
            print("File already exist")
            return dataBasePath as String
        }
    }
    
}

