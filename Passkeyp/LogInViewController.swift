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
