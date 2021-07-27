//
//  DataManagementViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class DataManagementViewController: UIViewController {

    @IBOutlet weak var eraseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eraseButton.backgroundColor = accentColor
    }
        
    @IBAction func eraseDataPressed(_ sender: Any) {
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
