//
//  DataCreationViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class NewKeypViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var newKeypCard: UIView!
    @IBOutlet weak var closeCardButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var tagPicker: UIPickerView!
    
    var tagSelected: String? = nil
    
    var delegate: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagPicker.delegate = self
        tagPicker.dataSource = self
        newKeypCard.layer.cornerRadius = 30
        saveButton.layer.cornerRadius = 14
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryLabels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryLabels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        tagSelected = categoryLabels[row]
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard websiteField.text != "" else {
            websiteField.placeholder = "Please add a website"
            return
        }
        
        guard usernameField.text != "" else {
            usernameField.placeholder = "Please add a username"
            return
        }
        
        guard passwordField.text != "" else {
            passwordField.placeholder = "Please add a password"
            return
        }
    
        let newKeyp = WebsiteDataController.controller.createWebsite(websiteName: websiteField.text ?? " ", username: usernameField.text ?? " ", password: passwordField.text ?? " ", tag: tagSelected ?? "Collection")
        
        let otherVC = delegate as! HomeScreenViewController
        otherVC.updateCollectionWithNewKeyp(keyp: newKeyp!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = ModeSettingDataController.controller.getUserAccentColor()
        saveButton.backgroundColor = uIColor
        closeCardButton.tintColor = uIColor
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
