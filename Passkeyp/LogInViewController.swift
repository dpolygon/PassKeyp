//
//  LogInViewController.swift
//  Passkeyp
//
//  Created by Silvana Borgo on 7/27/21.
//

import UIKit
import LocalAuthentication
import Firebase
import CoreData

var context = LAContext()

enum AuthenticationState {
    case loggedin, loggedout
}

var testUser : String! = nil

class LogInViewController: UIViewController {
    
    private let entityName = "ModeSettings"
    private let segueIdentifier = "homeScreenSegue"
    @IBOutlet weak var faceIDButton: UIButton!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    var state : AuthenticationState? {
        didSet {
            // do stuff if changed to .loggedIn
            if state == .loggedin {
                // segue to home screen
                // obtain user core data
                if let settings = retrieveSettings() {
                    // settings already defined for this user
                    printSettings(settings: settings)
                    initSettings(settings: settings)
                } else {
                    // create core data for new user with defaults
                    storeSettingsData(user: testUser, matchSystem: true, darkMode: false, accent: UIColor.blue)
                }
                performSegue(withIdentifier: segueIdentifier, sender: nil)
            } else if (state == .loggedout && testUser != nil) {
                // user logged out
                // save changes to settings
                guard let oldSettings = retrieveSettings() else {
                    print("Settings should already exist. This shouldn't happen.")
                    return
                }
                changeSettings(settings: oldSettings, matchSystem: currMatchSystem, darkMode: currDarkMode, accent: accentColor)
                print("LOGGED OUT WITH VALUES")
                printSettings(settings: retrieveSettings()!)
                testUser = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // check for ability to use face ID
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        Auth.auth().addStateDidChangeListener() {
          auth, user in
          
          if user != nil {
            testUser = Auth.auth().currentUser?.uid
            self.state = .loggedin
          }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // user isn't logged in
        state = .loggedout
        faceIDButton.isHidden = faceIDHidden
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        // check for correct credentials and change state
        guard let email = userField.text, let password = passwordField.text , email.count > 0, password.count > 0 else {
            statusLabel.text = "Missing field(s)."
            statusLabel.isHidden = false
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                self.statusLabel.text = "Authentication unsuccessful."
                self.statusLabel.isHidden = false
            }
        }
    }
    
    @IBAction func faceIDPressed(_ sender: Any) {
        // create new context
        context = LAContext()
        
        
        // check for hardware support
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in

                if success {

                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [unowned self] in
                        self.state = .loggedin
                    }

                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")

                    // Fall back to a asking for username and password.
                    DispatchQueue.main.async {
                        self.statusLabel.text = "Authentication unsuccessful."
                        self.statusLabel.isHidden = false
                    }
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")

            // Fall back to a asking for username and password.
            DispatchQueue.main.async {
                self.statusLabel.text = "No biometry available on device."
                self.statusLabel.isHidden = false
            }
        }
    }
    
    // functions to retrieve and store user settings from core data when logged in
    func storeSettingsData(user: String, matchSystem: Bool, darkMode: Bool, accent: UIColor) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let settings = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        
        settings.setValue(user, forKey: "userUID")
        settings.setValue(matchSystem, forKey: "matchSystem")
        settings.setValue(darkMode, forKey: "darkMode")
        settings.setValue(accent, forKey: "accentColor")
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }
    
    func retrieveSettings() -> NSManagedObject? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let predicate = NSPredicate(format: "userUID == %@", testUser)
        request.predicate = predicate
        
        do {
            let fetchedResult = try context.fetch(request)
            if fetchedResult.count == 0 {
                return nil
            } else {
                return fetchedResult[0] as? NSManagedObject
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func printSettings(settings: NSManagedObject) {
        let user = settings.value(forKey: "userUID")
        let matchSystem = settings.value(forKey: "matchSystem")
        let darkMode = settings.value(forKey: "darkMode")
        let color = settings.value(forKey: "accentColor")
        print("Settings for user \(user!): \(matchSystem!), \(darkMode!), \(color!)")
    }
    
    func initSettings(settings: NSManagedObject) {
        guard let matchSystem = settings.value(forKey: "matchSystem"), let darkMode = settings.value(forKey: "darkMode"), let color = settings.value(forKey: "accentColor") else {
            return
        }
    
        currMatchSystem = matchSystem as! Bool
        currDarkMode = darkMode as! Bool
        changeToMode(matchBool: currMatchSystem, darkBool: currDarkMode)
        
        accentColor = color as! UIColor
    }
    
    func changeSettings(settings: NSManagedObject, matchSystem: Bool, darkMode: Bool, accent: UIColor){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        settings.setValue(matchSystem, forKey: "matchSystem")
        settings.setValue(darkMode, forKey: "darkMode")
        settings.setValue(accent, forKey: "accentColor")
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func changeToMode(matchBool: Bool, darkBool: Bool){
        var style : UIUserInterfaceStyle!
        if matchBool {
            style = UITraitCollection.current.userInterfaceStyle
        } else if darkBool {
            style = UIUserInterfaceStyle.dark
        } else {
            style = UIUserInterfaceStyle.light
        }
        view.window?.overrideUserInterfaceStyle = style
        overrideUserInterfaceStyle = style
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
