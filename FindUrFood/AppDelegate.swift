//
//  AppDelegate.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var localPlistPath = ""
    var newRecipesJsonPath = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.preparePlistDatabase()
        self.prepareRecipesJson()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate {
    func preparePlistDatabase(){
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        localPlistPath = rootPath + "/Users.plist"
        if !FileManager.default.fileExists(atPath: localPlistPath){
            if let plistPathInBundle = Bundle.main.path(forResource: "Users", ofType: "plist") as String? {
                do {
                    try FileManager.default.copyItem(atPath: plistPathInBundle, toPath: localPlistPath)
                }catch{
                   // print("Error occurred while copying file to document \(error)")
                }
            }
        }
    }
    
    func prepareRecipesJson(){
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        newRecipesJsonPath = rootPath + "/NewRecipes.json"
        if !FileManager.default.fileExists(atPath: newRecipesJsonPath){
            let created = FileManager.default.createFile(atPath: newRecipesJsonPath, contents: nil, attributes: nil)
            if created {
                  // print("File created ")
               } else {
                   //print("Couldn't create file for some reason")
               }
        }else{
           // print("File already exists")
        }
    }
}

