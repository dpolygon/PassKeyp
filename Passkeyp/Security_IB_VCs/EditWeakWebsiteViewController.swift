//
//  EditWebsiteDataViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import CoreData

class EditWeakWebsiteViewController: UITableViewController {
    
    var thisKeyp: Website?
    let keypController = WebsiteDataController.controller
    @IBOutlet weak var saveButton: UIButton!
    let uIColor = ModeSettingDataController.controller.getUserAccentColor()
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.backgroundColor = uIColor
        userLabel.text = thisKeyp?.username
        passwordField.text = thisKeyp?.password
    }

    @IBAction func savePressed(_ sender: Any) {
        passwordField.isEnabled = false
        keypController.updateKeyp(website: thisKeyp, websiteName: (thisKeyp?.websiteName)!, username: (thisKeyp?.username)!, password: passwordField.text!, tag: (thisKeyp?.tag)!)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        keypController.deleteWebsite(website: thisKeyp! as NSManagedObject)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewPasswordPressed(_ sender: Any) {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
    }
    
    // edit password and generate random password clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                // make editable and visible
                passwordField.isEnabled = true
                passwordField.isSecureTextEntry = false
                passwordField.clearsOnBeginEditing = false
                // set cursor at end of field
                let newPosition = passwordField.endOfDocument
                passwordField.selectedTextRange = passwordField.textRange(from: newPosition, to: newPosition)
            } else if (indexPath.row == 1) {
                passwordField.isSecureTextEntry = false
                passwordField.text = PasswordGenerator.generate(charsAvailable: nil)
                keypController.updateKeyp(website: thisKeyp, websiteName: (thisKeyp?.websiteName)!, username: (thisKeyp?.username)!, password: passwordField.text!, tag: (thisKeyp?.tag)!)
            }
        }
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
