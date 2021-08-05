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
    var delegate: UIViewController?
    var keypDataObject: NSManagedObject?
    let pasteboard = UIPasteboard.general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editSaveButton.backgroundColor = accentColor
        hideButton.tintColor = accentColor
        let keyp = keypDataObject as! Website
        websiteField.text = keyp.websiteName
        usernameField.text = keyp.username
        passwordField.text = keyp.password
        editSaveButton.layer.cornerRadius = 16
        deleteButton.layer.cornerRadius = 16
        
    }
    
    @IBAction func hideButtonPressed(_ sender: Any) {
        passwordField.isSecureTextEntry = passwordField.isSecureTextEntry == true ? false : true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            WebsiteDataController.controller.updateKeyp(website: keypDataObject, websiteName: websiteField.text!, username: usernameField.text!, password: passwordField.text!)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        if self.traitCollection.userInterfaceStyle == .dark {
            keypTableView.backgroundColor = UIColor.black
                } else {
                    keypTableView.backgroundColor = UIColor.white
                }
    }
}
