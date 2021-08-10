//
//  EditWebsiteDataViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import CoreData

class EditWeakWebsiteViewController: UITableViewController {
    
    var keypDataObject: NSManagedObject?
    let keypController = WebsiteDataController.controller
    @IBOutlet weak var saveButton: UIButton!
    let uIColor = ModeSettingDataController.controller.getUserAccentColor()
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.backgroundColor = uIColor
    }

    @IBAction func savePressed(_ sender: Any) {
        passwordField.isEnabled = false
        //let websiteName = keypObject.
        //keypController.updateKeyp(website: keypObject, websiteName: keypObject, username: <#T##String#>, password: <#T##String#>, tag: <#T##String#>)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
    }
    
    @IBAction func viewPasswordPressed(_ sender: Any) {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                passwordField.isEnabled = true
            } else if (indexPath.row == 1) {
                
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
