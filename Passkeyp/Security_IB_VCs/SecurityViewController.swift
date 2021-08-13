//
//  SecurityViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class SecurityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let controller = WebsiteDataController.controller
    let cellIdentifier = "passwordCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var repeatedCountLabel: UILabel!
    @IBOutlet weak var passwordStrengthLabel: UILabel!
    fileprivate let segueIdentifier = "editSegue"
    var keyps : [Website] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // TODO: set source and delegate correctly
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // TODO: implement protocol methods with correct data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyps.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyps = controller.searchRepeated() as! [Website]
        tableView.reloadData()
        repeatedCountLabel.text = String(keyps.count)
        passwordStrengthLabel.text = determineStrength() ?? "undefined"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let keyp = keyps[indexPath.row]
        cell.textLabel?.text = keyp.websiteName
        cell.detailTextLabel?.text = keyp.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
    }
    
    func calculateEntropy(passwords: [Website]) -> Double{
        var totalEntropy = 0.0
        let validChars = 94 // alphanumeric, upercase and symbols
        
        for password in passwords {
            let passwordEntropy = log2(pow(Double(validChars), Double(password.password!.count)))
            totalEntropy += passwordEntropy
        }
        return totalEntropy
    }
    
    func determineStrength() -> String? {
        let result = controller.retrieveWebsites()
        var averageEntropy = 0.0
        if let result = result {
            let allPasswords = result as! [Website]
            averageEntropy = calculateEntropy(passwords: allPasswords) / Double(allPasswords.count)
        }
        var strength : String?
        switch averageEntropy {
        case 0..<28:
            strength = "Very weak"
            break
        case 28..<35:
            strength = "Weak"
            break
        case 35..<59:
            strength = "Regular"
            break
        case 59..<127:
            strength = "Strong"
            break
        case 127..<Double.greatestFiniteMagnitude:
            strength = "Very Strong"
            break
        default:
            print("This shouldn't happen.")
        }
        return strength
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueIdentifier {
            let nextVC = segue.destination as! EditWeakWebsiteViewController
            let index = tableView.indexPathForSelectedRow?.row
            nextVC.thisKeyp = keyps[index!]
        }
    }
}
