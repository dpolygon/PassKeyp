//
//  SignInPreferencesViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import Firebase

class SignInPreferencesViewController: UITableViewController {

    @IBOutlet weak var faceIDCell: UITableViewCell!
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
        passwordSwitch.isOn = ModeSettingDataController.controller.getRequireLogin()
        faceIDSwitch.isOn = ModeSettingDataController.controller.getUseFaceID()
    }
    
    @IBAction func requirePasswordChanged(_ sender: Any) {
        let control = ModeSettingDataController.controller
        control.setRequireLogin(requireLogin: !control.getRequireLogin())
        if passwordSwitch.isOn {
            faceIDCell.isHidden = false
        } else {
            faceIDCell.isHidden = true
            control.setUseFaceID(useFaceID: false)

        }
        faceIDSwitch.isOn = control.getUseFaceID()
    }
    
    @IBAction func faceIDChanged(_ sender: Any) {
        let control = ModeSettingDataController.controller
        control.setUseFaceID(useFaceID: !control.getUseFaceID())
    }
    
    func logout(){
        do
        {
            try Auth.auth().signOut()            
            let storyboard = UIStoryboard(name: "LogInStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
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
