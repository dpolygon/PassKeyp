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
    var userSettings: NSManagedObject!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var fetchedResult: [NSManagedObject]? = nil
        do {
            try fetchedResult = context.fetch(request) as? [NSManagedObject]
            userSettings = fetchedResult![0]
        } catch {
            userSettings = createUserSettings()
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
        let capturedSetting = userSettings as! ModeSettings
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
