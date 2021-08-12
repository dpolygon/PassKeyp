//
//  PGPKeyViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class PGPKeyViewController: UITableViewController {

    @IBOutlet weak var keyStatusLabel: UILabel!
    @IBOutlet weak var generateKeyImage: UIImageView!
    @IBOutlet weak var filesKeyImage: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    let userSettings = ModeSettingDataController.controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = userSettings.getUserAccentColor()
        generateKeyImage.tintColor = uIColor
        filesKeyImage.tintColor = uIColor
        removeButton.tintColor = uIColor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselecting row animation enabled
        tableView.deselectRow(at: indexPath, animated: true)
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
