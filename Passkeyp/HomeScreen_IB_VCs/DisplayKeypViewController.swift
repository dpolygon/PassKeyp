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
        passwordField.textColor = passwordField.isSecureTextEntry == true ? UIColor.systemGray3 : UIColor.black
        passwordField.isSecureTextEntry = passwordField.isSecureTextEntry == true ? false : true
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
        }
        websiteField.isUserInteractionEnabled = editable
        usernameField.isUserInteractionEnabled = editable
        passwordField.isUserInteractionEnabled = editable
    }
    
    @IBAction func deleteKeypPressed(_ sender: Any) {
        WebsiteDataController.controller.deleteWebsite(website: keypDataObject!)
        let otherVC = delegate as! HomeScreenViewController
        otherVC.deleteKeypAndUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.traitCollection.userInterfaceStyle == .dark {
            keypTableView.backgroundColor = UIColor.black
                } else {
                    keypTableView.backgroundColor = UIColor.white
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
