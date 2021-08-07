//
//  SignUpViewController.swift
//  Passkeyp
//
//  Created by Silvana Borgo on 7/27/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    private let segueIdentifier = "logInSegue"
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        // check for fields filled
        guard let user = userField.text, let password = passwordField.text, let passwordRepeat = repeatPasswordField.text, user.count > 0, password.count > 0, passwordRepeat.count > 0 else {
            statusLabel.text = "Missing field(s)."
            statusLabel.isHidden = false
            return
        }
        
        // check for name
        guard nameField.text != "" else {
            statusLabel.text = "Please enter a name"
            statusLabel.isHidden = false
            return
        }
        
        // check for email format
        guard user.contains("@") && user.contains(".") else {
            statusLabel.text = "First field must be an email."
            statusLabel.isHidden = false
            return
        }
        
        // check for field length
        guard password.count >= 8 else {
            statusLabel.text = "Password has to contain at least 8 characters."
            statusLabel.isHidden = false
            return
        }
        
        // check for password match
        guard password == passwordRepeat else {
            statusLabel.text = "Passwords don't match."
            statusLabel.isHidden = false
            return
        }
        
        // save user name in modeSettings
        ModeSettingDataController.controller.setUserName(name: nameField.text!)
        
        // create user
        Auth.auth().createUser(withEmail: user, password: password) { [self] authResult, error in
            if error == nil {
                Auth.auth().signIn(withEmail: user, password: password) { [self]
                    user, error in if error == nil {
                        performSegue(withIdentifier: segueIdentifier, sender: nil)
                    }
                }
            } else {
                statusLabel.text = "Unable to create new user."
                statusLabel.isHidden = false
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    // code to enable tapping on the background to remove software keyboard
        
        func textFieldShouldReturn(textField:UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
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
