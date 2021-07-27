//
//  SignInPreferencesViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class SignInPreferencesViewController: UITableViewController {

    @IBOutlet weak var faceIDSwitch: UISwitch!
    @IBOutlet weak var passwordSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        faceIDSwitch.onTintColor = accentColor
        passwordSwitch.onTintColor = accentColor
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
