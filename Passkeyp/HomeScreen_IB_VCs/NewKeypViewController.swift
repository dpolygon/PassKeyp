//
//  DataCreationViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class NewKeypViewController: UIViewController {

    @IBOutlet var newKeypCard: UIView!
    @IBOutlet weak var closeCardButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var delegate: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newKeypCard.layer.cornerRadius = 14
        saveButton.layer.cornerRadius = 14
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let newKeyp = WebsiteDataController.controller.createWebsite(websiteName: websiteField.text ?? " ", username: usernameField.text ?? " ", password: passwordField.text ?? " ")
        let otherVC = delegate as! HomeScreenViewController
        otherVC.updateCollectionWithNewKeyp(keyp: newKeyp!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.backgroundColor = accentColor
        closeCardButton.tintColor = accentColor
    }
    
    // code to enable tapping on the background to remove software keyboard
        
        func textFieldShouldReturn(textField:UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}
