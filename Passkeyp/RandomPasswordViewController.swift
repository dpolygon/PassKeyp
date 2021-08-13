//
//  RandomPasswordViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class RandomPasswordViewController: UITableViewController {

    private var charsEnabled : [String] = []
    @IBOutlet weak var passwordText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        passwordText.text = ""
    }

    @IBAction func generatePressed(_ sender: Any) {
        let password = PasswordGenerator.generate(charsAvailable: charsEnabled)
        passwordText.text = password
    }
    
    @IBAction func copyPasswordPressed(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = passwordText.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // selection of password options
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) {
                // check for accessory
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    let index = charsEnabled.firstIndex(of: PasswordGenerator.allChars[indexPath.row])!
                    charsEnabled.remove(at: index)
                } else {
                    cell.accessoryType = .checkmark
                    charsEnabled.append(PasswordGenerator.allChars[indexPath.row])
                }
            }
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

class PasswordGenerator {
    static let allChars = ["ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz", "1234567890", "!@#$%^&*()_+[]{}|=-~"]
    static func generate(charsAvailable: [String]?) -> String {
        var selectSet : [String]!
        if let charsEnabled = charsAvailable {
            if charsEnabled.count == 0 {
                // none available
                return ""
            }
            selectSet = charsEnabled
        } else {
            selectSet = allChars
        }
        let passwordLenght = 20
        let password = String((0..<passwordLenght).map{_ in
            let index = Int.random(in: 0..<selectSet.count)
            return selectSet[index].randomElement()!
        })
        return password
    }
}
