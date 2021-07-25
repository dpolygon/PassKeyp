//
//  ViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var websiteCollectionView: UICollectionView!
    @IBOutlet weak var creationButton: UIButton!
    @IBOutlet weak var userPicture: UIImageView!
    
    var cellIdentifier = "websiteContentCell"
    var websiteCollection = WebsiteDataController.controller.retrieveWebsites()
    var originalLocation: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        websiteCollectionView.delegate = self
        websiteCollectionView.dataSource = self
        userPicture.layer.cornerRadius = 20
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(recognizeLongPressOnCreationButton(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.15
        creationButton.addGestureRecognizer(longPressRecognizer)
        WebsiteDataController.controller.createWebsite(websiteName: "FaceBook", username: "danny2k", password: "password")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return websiteCollection!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! websiteCollectionViewCell
        cell.layer.cornerRadius = 16
        let website = websiteCollection![indexPath.row] as! Website
        cell.imageView.setImage(string: website.websiteName, color: UIColor.systemBlue, circular: true, stroke: false)
        cell.titleLabel.text = website.websiteName
        cell.captionLabel.text = website.username
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
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
    
}

class websiteCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
}

