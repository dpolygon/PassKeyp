//
//  modeSettingsDataController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 8/6/21.
//

import UIKit
import Foundation
import CoreData

// Handles all website data storage/retrieval in Core Data
class ModeSettingDataController {
    
    // Controller allows you to interact with Core Data functions
    static let controller = ModeSettingDataController()
    
    var entityName = "ModeSettings"
    var appDelegate: AppDelegate
    var context: NSManagedObjectContext
    var userSettingsObject: NSManagedObject!
    var userSettings: ModeSettings!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // use if want to retrieve specific user settings
//        let predicate = NSPredicate(format: "userUID == %@", "mainUser")
//        request.predicate = predicate
        
        var fetchedResult: [NSManagedObject]? = nil
        do {
            try fetchedResult = context.fetch(request) as? [NSManagedObject]
            if fetchedResult!.count != 0 {
                userSettingsObject = fetchedResult![0]
            } else {
                userSettingsObject = createUserSettings()
            }
        } catch {
            print("failed to retrieve user settings profile, generating default settings")
            userSettingsObject = createUserSettings()
        }
        userSettings = (userSettingsObject as! ModeSettings)
    }
    
    // Stores website data to core Data
    private func createUserSettings() -> NSManagedObject? {
        let userSettings = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        userSettings.setValue(UIColor.systemBlue, forKey: "accentColor")
        userSettings.setValue(false, forKey: "darkMode")
        userSettings.setValue(true, forKey: "matchSystem")
        userSettings.setValue("defaultName", forKey: "userName")
        userSettings.setValue(nil, forKey: "userPFP")
        userSettings.setValue("mainUser", forKey: "userUID")
        appDelegate.saveContext()
        return userSettings
    }
    
    func resetUserSettings() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("something has gone when reseting user settings")
        }
        print("setting up defaults")
        userSettingsObject = createUserSettings()
        userSettings = (userSettingsObject as! ModeSettings)
    }
    
    func setUserAccentColor(accentColor: UIColor) {
        userSettings.setValue(accentColor, forKey: "accentColor")
        appDelegate.saveContext()
    }
    
    func getUserAccentColor() -> UIColor {
        return userSettings.accentColor as! UIColor
    }
    
    func setUserDarkMode(darkMode: Bool) {
        userSettings.setValue(darkMode, forKey: "darkMode")
        appDelegate.saveContext()
    }
    
    func getUserDarkMode() -> Bool {
        return userSettings.darkMode
    }
    
    func setMatchSystem(matchSystem: Bool) {
        userSettings.setValue(matchSystem, forKey: "matchSystem")
        appDelegate.saveContext()
    }
    
    func getMatchSystem() -> Bool {
        return userSettings.matchSystem
    }
    
    func setUserName(name: String) {
        print("name was set")
        userSettingsObject.setValue(name, forKey: "userName")
        appDelegate.saveContext()
    }
    
    func getUserName() -> String {
        if userSettings.userName == nil {
            return "nameMissing"
        }
        return userSettings.userName!
    }
    
    func setUserPFP() {
        
    }
    
    func getUserPFP() {
        
    }
    
    func setUserUID() {
        
    }
    
    func getUserUID() {
        
    }
    
    func usePreviousSettingProfile(oldSettings: NSManagedObject){
        userSettingsObject = oldSettings
        appDelegate.saveContext()
    }
    
    func printSettings() {
        let user = userSettings.userUID
        let matchSystem = userSettings.matchSystem
        let darkMode = userSettings.darkMode
        let color = userSettings.accentColor
        print("Settings for user \(user!): \(matchSystem), \(darkMode), \(color!)")
    }
}
