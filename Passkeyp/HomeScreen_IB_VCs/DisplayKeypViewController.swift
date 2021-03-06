//
//  DisplayWebsiteViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import CoreData

class DisplayKeypViewController: UITableViewController {
    
    @IBOutlet var keypTableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var editSaveButton: UIButton!
    @IBOutlet weak var tagSection: UIView!
    @IBOutlet weak var tagDetail: UILabel!
    var delegate: UIViewController?
    var keypDataObject: NSManagedObject?
    let pasteboard = UIPasteboard.general
    let userSettings = ModeSettingDataController.controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uIColor = userSettings.getUserAccentColor()
        editSaveButton.backgroundColor = uIColor
        hideButton.tintColor = uIColor
        let keyp = keypDataObject as! Website
        websiteField.text = keyp.websiteName
        usernameField.text = keyp.username
        passwordField.text = keyp.password
        tagDetail.text = keyp.tag
        editSaveButton.layer.cornerRadius = 16
        deleteButton.layer.cornerRadius = 16
        
    }
    
    @IBAction func hideButtonPressed(_ sender: Any) {
        passwordField.isSecureTextEntry = passwordField.isSecureTextEntry == true ? false : true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let controller = UIAlertController(title: "Select A Tag", message: "Choose a tag that will help you remember this Keyp:", preferredStyle: .alert)
            for category in categoryLabels {
                controller.addAction(UIAlertAction(title: category,
                                                   style: .default,
                                                   // action that is called will update crust option
                                                   handler: { [self] _ in tagDetail.text = category}))
            }
            present(controller, animated: true, completion: nil)
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let url = URL(string: "https://www.google.com/search?q=\(String(describing: websiteField.text!))")
                UIApplication.shared.open(url!)
                break
            case 1:
                pasteboard.string = usernameField.text
                break
            case 2:
                pasteboard.string = passwordField.text
                break
            default:
                break
            }
        }
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let editable = websiteField.isUserInteractionEnabled == false ? true : false
        if editable == true {
            editSaveButton.setTitle("Save", for: .normal)
            passwordField.isSecureTextEntry = false
            hideButton.isUserInteractionEnabled = false
        } else {
            editSaveButton.setTitle("Edit", for: .normal)
            passwordField.isSecureTextEntry = true
            hideButton.isUserInteractionEnabled = true
            WebsiteDataController.controller.updateKeyp(website: keypDataObject, websiteName: websiteField.text!, username: usernameField.text!, password: passwordField.text!, tag: tagDetail.text!)
        }
        tagSection.isUserInteractionEnabled = editable
        websiteField.isUserInteractionEnabled = editable
        usernameField.isUserInteractionEnabled = editable
        passwordField.isUserInteractionEnabled = editable
    }
    
    @IBAction func deleteKeypPressed(_ sender: Any) {
        WebsiteDataController.controller.deleteWebsite(website: keypDataObject!)
        let otherVC = delegate as! HomeScreenViewController
        otherVC.deleteKeypAndUpdate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let myKeyp = "Keyp for \(websiteField.text!)\nuser: \(usernameField.text!)\npassword: \(passwordField.text!)"
        let shareSheetVC = UIActivityViewController(activityItems: [myKeyp], applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.traitCollection.userInterfaceStyle == .dark {
            keypTableView.backgroundColor = UIColor.black
        } else {
            keypTableView.backgroundColor = UIColor.white
        }
    }
}
