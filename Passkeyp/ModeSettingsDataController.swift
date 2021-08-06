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
    
    var entityName = "modeSetting"
    var appDelegate: AppDelegate
    var context: NSManagedObjectContext
    var userSettings: NSManagedObject!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        var fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if fetchResult[0] == nil {
            userSettings = createUserSettings()
        } else {
            userSettings = fetchResult[0]
        }
    }
    
    // Stores website data to core Data
    private func createUserSettings() -> NSManagedObject? {
        let userSettings = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        userSettings.setValue(UIColor.systemBlue, forKey: "accentColor")
        userSettings.setValue(false, forKey: "darkMode")
        userSettings.setValue(true, forKey: "matchSystem")
        userSettings.setValue(nil, forKey: "userName")
        userSettings.setValue(nil, forKey: "userPFP")
        userSettings.setValue("", forKey: "userUID")
        appDelegate.saveContext()
        return userSettings
    }
    
    func setUserAccentColor(accentColor: UIColor) {
        userSettings.setValue(accentColor, forKey: "accentColor")
        appDelegate.saveContext()
    }
    
    func getUserAccentColor() -> UIColor {
        let capturedSetting = userSettings as! ModeSetting
        return capturedSetting.accentColor as! UIColor
    }
    
    func setUserDarkMode() {
        
    }
    
    func getUserDarkMode() {
        
    }
    
    func setMatchSystem() {
        
    }
    
    func getMatchSystem() {
        
    }
    
    func setUserNmae() {
        
    }
    
    func getUserName() {
        
    }
    
    func setUserPFP() {
        
    }
    
    func getUserPFP() {
        
    }
    
    func setUserUID() {
        
    }
}
