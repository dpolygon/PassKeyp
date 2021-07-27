//
//  EditWebsiteDataViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class EditWeakWebsiteViewController: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var separatorLine1: UIView!
    @IBOutlet weak var separatorLine2: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        deleteButton.backgroundColor = accentColor
        separatorLine2.backgroundColor = accentColor
        separatorLine1.backgroundColor = accentColor
        saveButton.backgroundColor = accentColor
    }
    
    @IBAction func savePressed(_ sender: Any) {
    }
    
    @IBAction func generatePasswordPressed(_ sender: Any) {
    }
    
    @IBAction func deletePasswordPressed(_ sender: Any) {
    }
    
    @IBAction func editPressed(_ sender: Any) {
    }
    
    @IBAction func showPasswordPressed(_ sender: Any) {
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
