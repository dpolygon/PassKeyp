//
//  KeychainController.swift
//  Passkeyp
//
//  Created by Silvana Borgo on 8/9/21.
//

import Foundation
import LocalAuthentication
import UIKit
import FirebaseAuth

struct KeychainError: Error {
    var status: OSStatus

    var localizedDescription: String {
        return SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error."
    }
}

class KeychainController {
    static let keychainController = KeychainController()
    
    // adds user and password to keychain
    func addKeychainCredentials(user: String, password: String) throws {
        let access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .userPresence,
                                                     nil) // Ignore any error.

        // Allow a device unlock in the last 10 seconds to be used to get at keychain items.
        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = 10
        
        // build query
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: user,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecUseAuthenticationContext as String: context,
                                    kSecValueData as String: password.data(using: String.Encoding.utf8)!]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }
    
    // tries to fetch from keychain, upon failure creates
    // if fetched values don't correspond to the input ones, update
    func readKeychainCredentials(view: UIViewController?, setUser: String?, setPassword: String?, segue: String?) throws -> (account: String, password: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { // item does not exist
            guard  let mView = view, let mUser = setUser, let mPassword = setPassword, let mSegue = segue else {
                // no input to create keychain item with
                return ("", "")
            }
            // create keychain item
            KeychainController.keychainController.createAlert(view: mView, user: mUser, password: mPassword, segue: mSegue)
                return (mUser, mPassword) }

        // there is an existing item
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
            guard  let mView = view, let mUser = setUser, let mPassword = setPassword, let mSegue = segue else {
                // no input to create keychain item with
                return ("", "")
            }
            // create keychain item
            do {
                try KeychainController.keychainController.updateKeychain()
                KeychainController.keychainController.createAlert(view: mView, user: mUser, password: mPassword, segue: mSegue)
            } catch {
                if let error = error as? KeychainError {
                    print(error.localizedDescription)
                }
            }
            return (mUser, mPassword)
        }
    
        if let user = setUser, account != user {
            // the existing item is different from the current input
            // update existing keychain item
            do {
                try KeychainController.keychainController.updateKeychain()
                KeychainController.keychainController.createAlert(view: view!, user: user, password: setPassword!, segue: segue!)
                return (user, setPassword!)
            } catch {
                if let error = error as? KeychainError {
                    print(error.localizedDescription)
                }
            }
        }
        return (account, password)
    }
    
    // creates alert with prompt to add to keychain, saves and performs segue
    func createAlert(view: UIViewController, user: String, password: String, segue: String) {
        let alert = UIAlertController(title: "Keychain action", message: "Save credentials to keychain?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            do {
                try KeychainController.keychainController.addKeychainCredentials(user: user, password: password)
                Auth.auth().signIn(withEmail: user, password: password) {
                    user, error in if error == nil {
                        view.performSegue(withIdentifier: segue, sender: nil)
                    }
                }
            } catch {
                if let error = error as? KeychainError {
                    print(error.localizedDescription)
                }
            }
        })

        view.present(alert, animated: true)
    }
    
    // delete keychain item in order to create again
    func updateKeychain() throws{
        let query : [String : Any] = [kSecClass as String: kSecClassGenericPassword]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError(status: status) }
    }
}
