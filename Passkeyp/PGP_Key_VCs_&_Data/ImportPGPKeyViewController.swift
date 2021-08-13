//
//  ImportPGPKeyViewController.swift
//  Passkeyp
//
//  Created by Ryan Travers on 8/12/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import ObjectivePGP

class ImportPGPKeyViewController: UIViewController, UIDocumentPickerDelegate {

    var picking: String = ""
    var pubKeyURL: URL?
    var secKeyURL: URL?
    let userSettings = ModeSettingDataController.controller
    
    @IBOutlet weak var publicKeyUrlLabel: UILabel!
    @IBOutlet weak var secretKeyUrlLabel: UILabel!
    @IBOutlet weak var passphraseTextField: UITextField!
    @IBOutlet weak var publicKeyButton: UIButton!
    @IBOutlet weak var secretKeyButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = userSettings.getUserAccentColor()
        publicKeyButton.tintColor = uIColor
        secretKeyButton.tintColor = uIColor
        saveButton.tintColor = uIColor
    }
    
    //Check if files are valid and passphrase is entered.
    @IBAction func saveButton(_ sender: Any) {
        if passphraseTextField.text == "" || pubKeyURL == nil || secKeyURL == nil {
            alertInvalid()
        } else {
            do {
                let pubKeyURLData = try Data(contentsOf: pubKeyURL!)
                let armoredPubKey = Armor.armored(pubKeyURLData, as: .publicKey)
                let pubKey = try ObjectivePGP.readKeys(from: Data(armoredPubKey.utf8))
                
                let secKeyURLData = try Data(contentsOf: secKeyURL!)
                let armoredSecKey = Armor.armored(secKeyURLData, as: .publicKey)
                let secKey = try ObjectivePGP.readKeys(from: Data(armoredSecKey.utf8))
                
                let kr = ObjectivePGP.defaultKeyring

                //Weird error reading keys in, with them being blank, Gonna just generate to move forward with testing :/
                if pubKey == [] || secKey == [] {
                    let keyGen = KeyGenerator().generate(for: userSettings.getUserName(), passphrase: passphraseTextField.text)
                    do {
                        let pubKey = try ObjectivePGP.readKeys(from: (try keyGen.export(keyType: .public)))
                        let secKey = try ObjectivePGP.readKeys(from: (try keyGen.export(keyType: .secret)))
                        kr.import(keys: pubKey)
                        kr.import(keys: secKey)
                    } catch {
                        print("invalid key generation")
                    }
                } else {
                    kr.import(keys: pubKey)
                    kr.import(keys: secKey)
                }
//                testEncrypt(passphrase: passphraseTextField.text!)
            } catch {
                print("Read Key Error")
            }
        }
    }
    
    func alertInvalid() {
        let controller = UIAlertController(
            title: "Invalid Input",
            message: "Public key, Secret key, and Passphrase must all me entered.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    func testEncrypt(passphrase: String) {
        //quick test encrypt and decrypt of the string "test"
        let key = ObjectivePGP.defaultKeyring.keys
        print(key)

        let toEncrypt:Data = Data("test".utf8)
        do {
            let encrypted = try ObjectivePGP.encrypt(toEncrypt, addSignature: true, using: key, passphraseForKey: {_ in return passphrase})
            do {
                let decrypted = try ObjectivePGP.decrypt(encrypted, andVerifySignature: true, using: key, passphraseForKey: {_ in return passphrase})
                print("decrypted: \(String(decoding: decrypted, as: UTF8.self))")
            } catch {
                print("failed decrypt")
            }
        } catch {
            print("failed encrypt")
        }
    }
    
    //Handle Selecting Files
    @IBAction func testImportFile(_ sender: Any) {
        picking = "public"
        selectFiles()
    }
    
    @IBAction func selectSecretButton(_ sender: Any) {
        picking = "secret"
        selectFiles()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("The Urls are : \(urls)")
        if picking == "public" {
            pubKeyURL = urls[0]
            publicKeyUrlLabel.text = pubKeyURL?.absoluteString
        } else if picking == "secret" {
            secKeyURL = urls[0]
            secretKeyUrlLabel.text = secKeyURL?.absoluteString
        }
    }
    
    func selectFiles() {
        let types = UTType.types(tag: "txt",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
}
