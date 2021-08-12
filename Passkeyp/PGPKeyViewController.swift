//
//  PGPKeyViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import ObjectivePGP

class PGPKeyViewController: UITableViewController {

    @IBOutlet weak var keyStatusLabel: UILabel!
    @IBOutlet weak var generateKeyImage: UIImageView!
    @IBOutlet weak var filesKeyImage: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    let userSettings = ModeSettingDataController.controller
    let kr = Keyring()
    
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
        if indexPath == [0, 0] {
            generatePGPKeyPair()
        }
    }
    
    //Function to Generate a new PGP KeyPair with a passphrase entered by the user.
    func generatePGPKeyPair(){
        //creates a keyring where ObjectivePGP stores PGP keys by default
        let kr = ObjectivePGP.defaultKeyring
        
        //Pop up alert for user to enter passphrase
        
        //Create generator object **Ask Daniel or Silvana where to get the users email
        let keyGen = KeyGenerator().generate(for: "marcin@example.com", passphrase: "password")
        do {
            //generate keys and add to keyring
            let pubKey = try ObjectivePGP.readKeys(from: (try keyGen.export(keyType: .public)))
            let secKey = try ObjectivePGP.readKeys(from: (try keyGen.export(keyType: .secret)))
            
            kr.import(keys: pubKey)
            kr.import(keys: secKey)
        } catch {
            print("invalid key generation")
        }
        
        //quick test encrypt and decrypt of the string "test"
        let key = kr.keys

        let toEncrypt:Data = Data("test".utf8)
        do {
            let encrypted = try ObjectivePGP.encrypt(toEncrypt, addSignature: true, using: key, passphraseForKey: {_ in return "password"})
            print(encrypted)
            do {
                let decrypted = try ObjectivePGP.decrypt(encrypted, andVerifySignature: true, using: key, passphraseForKey: {_ in return "password"})
                print("decrypted: \(String(decoding: decrypted, as: UTF8.self))")
            } catch {
                print("failed decrypt")
            }
            
        } catch {
            print("failed encrypt")
        }
    }
    
    
    @IBAction func RemoveKeysButton(_ sender: Any) {
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
