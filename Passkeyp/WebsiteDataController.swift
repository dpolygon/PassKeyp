//
//  WebsiteDataController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/22/21.
//

import UIKit
import CoreData

// Handles all website data storage/retrieval in Core Data
class WebsiteDataController {
    
    // Controller allows you to interact with Core Data functions
    static let controller = WebsiteDataController()
    
    var entityName = "Website"
    var appDelegate: AppDelegate
    var context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    // Stores website data to core Data
    func createWebsite(websiteName: String, username: String, password: String) -> NSManagedObject? {
        let website = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        website.setValue(websiteName, forKey: "websiteName")
        website.setValue(username, forKey: "username")
        website.setValue(password, forKey: "password")
        appDelegate.saveContext()
        return website
    }
    
    // Updates the same current Website data that is being created to new user specifications in Core Data
    func updateKeyp(website: NSManagedObject?, websiteName: String, username: String, password: String) {
        if let website = website {
            website.setValue(websiteName, forKey: "websiteName")
            website.setValue(username, forKey: "username")
            website.setValue(password, forKey: "password")
            appDelegate.saveContext()
        }
        appDelegate.saveContext()
    }
    
    // Fetch all websites stored in Core Data, return websites in an array
    func retrieveWebsites() -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var fetchedResults: [NSManagedObject]? = nil
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            runErrorMessage(error: error, message: "an error has occurred when attempting to retrieve websites")
        }
        return fetchedResults
    }
    
    func searchKeyps(contains: String) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let pred = NSPredicate(format: "websiteName CONTAINS[c] '\(contains)'")
        request.predicate = pred
        var fetchedResults: [NSManagedObject]? = nil
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            runErrorMessage(error: error, message: "an error has occurred when attempting to retrieve websites")
        }
        return fetchedResults
    }
    
    // Deletes a specified 'website' from Core Data
    func deleteWebsite(website: NSManagedObject) {
        context.delete(website)
        appDelegate.saveContext()
    }
    
    // Remove all websites from Core Data
    func deleteAllKeypData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            runErrorMessage(error: error, message: "request to delete all entities pretaining to \(entityName) has failed")
        }
        appDelegate.saveContext()
    }
    
    // Any failure to retrieve data from Core Data or
    // failure to save the context will call on this func
    // error information will be printed to console
    func runErrorMessage(error: Error, message: String) {
        print(message)
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
}
