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
        let kr = ObjectivePGP.defaultKeyring
//        print(kr.keys.count)
        
//        let phrase = "passphrase"
        
        let keyGen = KeyGenerator().generate(for: "marcin@example.com", passphrase: "password")
        do {
            let pubKey = try keyGen.export(keyType: .public)
            let secKey = try keyGen.export(keyType: .secret)
                        
//            print(pubKey)
//            print(type(of: pubKey))
            
            let testPubKey = try ObjectivePGP.readKeys(from: pubKey)
            let testSecKey = try ObjectivePGP.readKeys(from: secKey)
//            print(testPubKey)
//            print(testSecKey)
            
            kr.import(keys: testPubKey)
            kr.import(keys: testSecKey)
        } catch {
            print("invalid key generation")
        }
                
        
//        print(kr.keys.count)
        let key = kr.keys
//        print(key)
//        print(type(of: key))
        
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
