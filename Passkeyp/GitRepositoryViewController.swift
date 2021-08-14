//
//  GitRepositoryViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import OctoKit

let config = OAuthConfiguration(token: "304f1c26f9e6d32dd8af", secret: "671743ab4b82e89dede653639122e7758aeaf9ec", scopes: ["repo", "read:org"])

class GitRepositoryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var githubButton: UIImageView!
    @IBOutlet weak var signInStatus: UILabel!
    @IBOutlet weak var cloneButton: UIButton!
    @IBOutlet weak var repoLocationLabel: UILabel!
    @IBOutlet weak var repoLocationField: UITextField!
    let userSettings = ModeSettingDataController.controller
    var userAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repoLocationField.delegate = self
        cloneButton.layer.cornerRadius = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let token = userSettings.getToken()
        if token == "noToken" {
            githubButton.isHidden = false
            signInStatus.text = "Sign in with Github for seamless synchronization of passwords across your devices"
        } else {
            print("here")
            print("\(token)")
            let newConfig = TokenConfiguration(token)
            Octokit(newConfig).user(name: userSettings.getGithubUser()) { [self] response in
              switch response {
              case .success(let user):
                DispatchQueue.main.sync {
                    githubButton.isHidden = true
                    signInStatus.text = "Logged into Github as: \(user.login!)"
                    repoLocationLabel.text = "https://github.com/\(user.login!)/"
                    userAddress = "https://github.com/\(user.login!)/"
                }
              case .failure(let error):
                  print("Error: \(error)")
              }
            }
            
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.async { [self] in
            repoLocationLabel.text = userAddress! +  "\(repoLocationField.text!)"
        }
    }
    
    @IBAction func removeAccountTapped(_ sender: Any) {
        userSettings.setToken(token: "noToken")
    }
    
    @IBAction func signInWithGithubTapped(_ sender: Any) {
        let url = config.authenticate()
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func clonePressed(_ sender: Any) {
        let (owner, name) = ("dpolygon", "changeColorandText") // replace with actual owner and name
        Octokit().repository(owner: owner, name: name) { response in
          switch response {
            case .success(let repository):
                print(repository.repositoryDescription)
                break
          case .failure(let error):
            break
              // handle any errors
          }
        }
    }
    
}
