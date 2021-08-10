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
    static var repeatedPasswords : [NSManagedObject] = []
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    // Stores website data to core Data
    func createWebsite(websiteName: String, username: String, password: String, tag: String) -> NSManagedObject? {
        let website = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        website.setValue(tag, forKey: "tag")
        website.setValue(websiteName, forKey: "websiteName")
        website.setValue(username, forKey: "username")
        website.setValue(password, forKey: "password")
        appDelegate.saveContext()
        return website
    }
    
    // Updates the same current Website data that is being created to new user specifications in Core Data
    func updateKeyp(website: NSManagedObject?, websiteName: String, username: String, password: String, tag: String) {
        if let website = website {
            website.setValue(websiteName, forKey: "websiteName")
            website.setValue(username, forKey: "username")
            website.setValue(password, forKey: "password")
            website.setValue(tag, forKey: "tag")
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
    
    // search for Keyp using website name
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
    
    // search for Keyp using keyp tag
    func searchKeyps(tag: String) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let pred = NSPredicate(format: "tag CONTAINS[c] '\(tag)'")
        request.predicate = pred
        var fetchedResults: [NSManagedObject]? = nil
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            runErrorMessage(error: error, message: "an error has occurred when attempting to retrieve websites")
        }
        return fetchedResults
    }
    
    // search for Keyp using keyp tag
    func searchPassword(password: String) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let pred = NSPredicate(format: "password CONTAINS[c] '\(password)'")
        request.predicate = pred
        var fetchedResults: [NSManagedObject]? = nil
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            runErrorMessage(error: error, message: "an error has occurred when attempting to retrieve websites")
        }
        return fetchedResults
    }
    
    // get Websites with repeated passwords
    func searchRepeated() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let passwordExpr = NSExpression(forKeyPath: "password")
        
        let countExpr = NSExpressionDescription()
        let countVariableExpr = NSExpression(forVariable: "count")

        countExpr.name = "count"
        countExpr.expression = NSExpression(forFunction: "count:", arguments: [ passwordExpr ])
        countExpr.expressionResultType = .integer64AttributeType

        request.resultType = .dictionaryResultType
        request.sortDescriptors = [ NSSortDescriptor(key: "password", ascending: false) ]
        request.propertiesToGroupBy = [ Website.entity().propertiesByName["password"]! ]
        request.propertiesToFetch = [ Website.entity().propertiesByName["password"]!, countExpr]

        request.havingPredicate = NSPredicate(format: "%@ > 1", countVariableExpr)
       
        var websites : [NSManagedObject] = []
        var results : NSArray?
        do {
            results = try context.fetch(request) as NSArray
        } catch {
            runErrorMessage(error: error, message: "an error has occurred when attempting to retrieve websites")
        }
        
        for dict in results! {
            let website = dict as! NSDictionary
            let password = website.value(forKey: "password")
            let moreKeyps = searchPassword(password: password as! String)
            websites.append(contentsOf: moreKeyps!)
        }
        return websites
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
