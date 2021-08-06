//
//  ViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import CoreData

var icons = ["vaultIcon", "websiteIcon", "entertainmentIcon", "workIcon", "schoolIcon", "boxIcon"]
var categoryLabels = ["All", "Website", "Entertainment", "Work", "School", "Other"]

protocol updateDataRemotely {
    func updateCollectionWithNewKeyp(keyp: NSManagedObject)
    func deleteKeypAndUpdate()
}

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, updateDataRemotely {

    @IBOutlet weak var searchKeypBar: UISearchBar!
    @IBOutlet weak var websiteCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var creationButton: UIButton!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    let picker = UIImagePickerController()
    
    var categoryCellIdentifier = "keypCategoryCell"
    var cellIdentifier = "keypContentCell"
    var websiteCollection = WebsiteDataController.controller.retrieveWebsites()
    var originalLocation: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        websiteCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        websiteCollectionView.dataSource = self
        searchKeypBar.delegate = self
        picker.delegate = self
        userPicture.layer.cornerRadius = 20
        setUpGestures()
    }
    
    @IBAction func userPFPTapped(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.editedImage] as! UIImage
        
        userPicture.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("User cancelled")
    }
    
    func setUpGestures() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(recognizeLongPressOnCreationButton(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.15
        creationButton.addGestureRecognizer(longPressRecognizer)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        websiteCollection = WebsiteDataController.controller.searchKeyps(contains: searchText)
        websiteCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        websiteCollection = WebsiteDataController.controller.retrieveWebsites()
        websiteCollectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return categoryLabels.count
        } else {
            return websiteCollection!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath as IndexPath) as! categoryCollectionViewCell
            cell.categoryIcon.image = UIImage(named: icons[indexPath.row])
            cell.categoryLabel.text = categoryLabels[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! websiteCollectionViewCell
            cell.layer.cornerRadius = 16
            let website = websiteCollection![indexPath.row] as! Website
            cell.imageView.setImage(string: website.websiteName?.lowercased(), color: ModeSettingDataController.controller.getUserAccentColor(), circular: false, stroke: false)
            cell.imageView.layer.cornerRadius = 16
            cell.titleLabel.text = website.websiteName
            cell.captionLabel.text = website.username
            cell.blurredView.backgroundColor = ModeSettingDataController.controller.getUserAccentColor()
            return cell
        }
    }
    
    @IBAction func recognizeLongPressOnCreationButton(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case UILongPressGestureRecognizer.State.began:
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            [self] in
                            creationButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                           },
                           completion: nil)
        case UILongPressGestureRecognizer.State.ended:
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            [self] in
                            creationButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                           },
                           completion: nil)
        default:
            break
        }
    }
    
    @IBAction func recognizePanGesture(recognizer: UIPanGestureRecognizer) {
        let translate = recognizer.translation(in: self.view)
        switch recognizer.state {
        case UIGestureRecognizer.State.began:
            originalLocation = recognizer.view!.center
            break
        case UIGestureRecognizer.State.changed:
            recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translate.x,
                                              y:recognizer.view!.center.y + translate.y)
            break
        case UIGestureRecognizer.State.ended:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            [self] in
                            recognizer.view!.center = originalLocation!
                           },
                           completion: nil)
            break
        default:
            break
        }
        recognizer.setTranslation(.zero, in: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        creationButton.tintColor = ModeSettingDataController.controller.getUserAccentColor()
        websiteCollectionView.reloadData()
        userName.text = ModeSettingDataController.controller.getUserName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewKeyp" {
            let nextVC = segue.destination as! NewKeypViewController
            nextVC.delegate = self
        } else {
            let nextVC = segue.destination as! DisplayKeypViewController
            nextVC.delegate = self
            let index = websiteCollectionView.indexPathsForSelectedItems?.last?.row
            nextVC.keypDataObject = websiteCollection![index!]
        }
    }
    
    func updateCollectionWithNewKeyp(keyp: NSManagedObject) {
        websiteCollection?.append(keyp)
        websiteCollectionView.reloadData()
    }
    
    func deleteKeypAndUpdate() {
        let index = websiteCollectionView.indexPathsForSelectedItems?.last?.row
        websiteCollection?.remove(at: index!)
    }
    
}

class websiteCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    
}

class categoryCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
}

