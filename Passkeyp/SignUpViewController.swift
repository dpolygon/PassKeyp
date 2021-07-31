//
//  SignUpViewController.swift
//  Passkeyp
//
//  Created by Silvana Borgo on 7/27/21.
//

import UIKit

class SignUpViewController: UIViewController {

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
        
        // check for no previous user with same username
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
