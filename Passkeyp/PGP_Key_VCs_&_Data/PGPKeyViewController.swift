//
//  PGPKeyViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import ObjectivePGP
import Security

class PGPKeyViewController: UITableViewController {

    @IBOutlet weak var keyStatusLabel: UILabel!
    @IBOutlet weak var generateKeyImage: UIImageView!
    @IBOutlet weak var filesKeyImage: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    let userSettings = ModeSettingDataController.controller
    var keySaved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = userSettings.getUserAccentColor()
        generateKeyImage.tintColor = uIColor
        filesKeyImage.tintColor = uIColor
        removeButton.tintColor = uIColor
        refreshOptions()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselecting row animation enabled
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == [0, 0] {
            if keySaved {
                alertKeyAlreadySaved()
            } else {
                requestPassphrase()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "importPGPSegue",
            let importPGPVC = segue.destination as? ImportPGPKeyViewController {
            importPGPVC.delegate = self
            
        }
    }
    
    func alertKeyAlreadySaved() {
        let controller = UIAlertController(
            title: "Key Already Exists",
            message: "Delete the current key to add a new one.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    //Show and hide remove button and update status and change actionability of import options depending on key state
    func refreshOptions() {
        if keySaved {
            removeButton.isHidden = false
        } else {
            removeButton.isHidden = true
        }
        updateStatusLabel()
    }
    
    //updates the status label
    func updateStatusLabel() {
        let imageAttachment = NSTextAttachment()
        let textAfterIcon: NSAttributedString
        if keySaved {
            imageAttachment.image = UIImage.strokedCheckmark
            textAfterIcon = NSAttributedString(string: "Valid PGP Keypair Saved.")
        } else {
            imageAttachment.image = UIImage.remove
            textAfterIcon = NSAttributedString(string: "No PGP Keypair.")
        }
        
        let imageOffsetY: CGFloat = -4
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        completeText.append(textAfterIcon)
        
        keyStatusLabel.textAlignment = .center
        keyStatusLabel.attributedText = completeText
    }
    
    //Ask user for a passphrase in generation of a new keypair, then save the passphrase and generate the keypair (in handler)
    func requestPassphrase() {
        //Pop up alert for user to enter passphrase
        let controller = UIAlertController(
            title: "PGP Keypair Passphrase",
            message: "You must enter a passphrase to generate a keypair.",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        
        controller.addTextField(configurationHandler: {
            (textField:UITextField!) in textField.placeholder = "Enter something"
        })
        
        controller.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: {
                                    
                                    (paramAction:UIAlertAction!) in
                                    if let textFieldArray = controller.textFields {
                                        let textFields = textFieldArray as [UITextField]
                                        let enteredText = textFields[0].text
                                        print(enteredText!)
                                        self.generatePGPKeyPair(passphrase: enteredText!)
                                    }
                                    
                                }))
        present(controller, animated: true, completion: nil)
    }
    
    //Generate a new PGP KeyPair with a passphrase entered by the user.
    func generatePGPKeyPair(passphrase: String){
        //creates a keyring where ObjectivePGP stores PGP keys by default
        let kr = ObjectivePGP.defaultKeyring
                
        //Create generator object
        let keyGen = KeyGenerator().generate(for: userSettings.getUserName(), passphrase: passphrase)
        do {
            //generate keys and add to keyring
            let pubKey = try ObjectivePGP.readKeys(from: (try keyGen.export(keyType: .public)))
            let secKey = try ObjectivePGP.readKeys(from: (try keyGen.export(keyType: .secret)))
            kr.import(keys: pubKey)
            kr.import(keys: secKey)
        } catch {
            print("invalid key generation")
        }
        
        userSettings.setPassphrase(passphrase: passphrase)
//        print(userSettings.getPassphrase())
        keySaved = true
        refreshOptions()
    }
    
    //Removes key and passphrase and resets screen to allow new input
    @IBAction func RemoveKeysButton(_ sender: Any) {
        let kr = ObjectivePGP.defaultKeyring
        let key = kr.keys
        kr.delete(keys: key)
        
        userSettings.removePassphrase()
        
        keySaved = false
        refreshOptions()
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
