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
    let userSettings = ModeSettingDataController.controller
    
    
    @IBOutlet weak var statusLabel: UILabel!
    var state : AuthenticationState? {
        didSet {
            // do stuff if changed to .loggedIn
            if state == .loggedin {
                // set UIStyle
                changeToMode(matchBool: userSettings.getMatchSystem(), darkBool: userSettings.getUserDarkMode())
                // segue to home screen
                performSegue(withIdentifier: segueIdentifier, sender: nil)
            } else if (state == .loggedout && testUser != nil) {
                // user logged out
                userSettings.printSettings()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() {
          auth, user in
          
          if user != nil {
            testUser = Auth.auth().currentUser?.uid
            self.state = .loggedin
          }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.darkGray
        state = .loggedout
        faceIDButton.isHidden = !ModeSettingDataController.controller.getUseFaceID()
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        // check for correct credentials and change state
        guard let email = userField.text, let password = passwordField.text , email.count > 0, password.count > 0 else {
            statusLabel.text = "Missing field(s)."
            statusLabel.isHidden = false
            
            return
        }
        do {
            // update or create credentials
            let credentials = try KeychainController.keychainController.readKeychainCredentials(view: self, setUser: email, setPassword: password, segue: segueIdentifier)
            // sign in
            Auth.auth().signIn(withEmail: credentials.account, password: credentials.password) { user, error in
                if let error = error, user == nil {
                    self.statusLabel.text = "Authentication unsuccessful."
                    self.statusLabel.isHidden = false
                }
            }
        } catch {
            if let error = error as? KeychainError {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func faceIDPressed(_ sender: Any) {
        do {
            // read credentials
            let credentials = try KeychainController.keychainController.readKeychainCredentials(view: nil, setUser: nil, setPassword: nil, segue: nil)
            print("face id: \(credentials.account)")
            print("face id: \(credentials.password)")
            // sign in
            Auth.auth().signIn(withEmail: credentials.account, password: credentials.password) { user, error in
                if let error = error, user == nil {
                    self.statusLabel.text = "Authentication unsuccessful."
                    self.statusLabel.isHidden = false
                }
            }
        } catch {
            if let error = error as? KeychainError {
                print(error.localizedDescription)
            }
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
