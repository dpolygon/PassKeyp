//
//  SignInPreferencesViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

var faceIDHidden = false

class SignInPreferencesViewController: UITableViewController {

    @IBOutlet weak var faceIDSwitch: UISwitch!
    @IBOutlet weak var passwordSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = ModeSettingDataController.controller.getUserAccentColor()
        faceIDSwitch.onTintColor = uIColor
        passwordSwitch.onTintColor = uIColor
    }
    
    @IBAction func requirePasswordChanged(_ sender: Any) {
        faceIDHidden = passwordSwitch.isOn
    }
    
    @IBAction func faceIDChanged(_ sender: Any) {
        faceIDHidden = passwordSwitch.isOn || faceIDSwitch.isOn == false
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
