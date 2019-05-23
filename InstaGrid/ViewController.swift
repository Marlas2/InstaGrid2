//
//  ViewController.swift
//  InstaGrid
//
//  Created by Quentin Marlas on 02/05/2019.
//  Copyright © 2019 Quentin Marlas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var swipeUpLabel: UILabel!
    
    @IBOutlet weak var swipeUpToShare: UIImageView!
    
    @IBOutlet var insertImages: [UIImageView]!
    @IBOutlet var crossButtons: [UIButton]!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var centralView: UIView!
    
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var downLeftView: UIView!
    @IBOutlet weak var downRightView: UIView!
    
    let screenWidth = UIScreen.main.bounds.width
    var tag : Int?
    let pickerController = UIImagePickerController()
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(share))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else { return }
        centralView.addGestureRecognizer(swipeGestureRecognizer)
        setUpSwipeDirection()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func share(){
        let activityController = UIActivityViewController(activityItems: [insertImages!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    func transformView() {
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if swipeGestureRecognizer?.direction == .left || swipeGestureRecognizer?.direction == .up {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            UIView.animate(withDuration: 1.0, animations: {
                self.centralView.transform = translationTransform
            }, completion: nil)
        } else {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        }
    }
    
    
    @objc func setUpSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecognizer?.direction = .left
          //  transformView()
            share()
        } else {
            swipeGestureRecognizer?.direction = .up
          //  transformView()
            share()
        }
    }
    
    func importPhotoFromLibrary() {
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func layoutButtonImages(_ sender: UIButton) {
        tag = sender.tag
        importPhotoFromLibrary()
    }
    
    
    @IBAction func layoutButtonTaped(_ sender: UIButton) {
        layoutButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        switch sender.tag {
        case 0:
            topLeftView.isHidden  = true
            downLeftView.isHidden = false
        case 1:
            topLeftView.isHidden  = false
            downLeftView.isHidden = true
        case 2:
            topLeftView.isHidden  = false
            downLeftView.isHidden = false
        default:
            break
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        tag = sender.view?.tag
        importPhotoFromLibrary()
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let selectedPhoto = info[.originalImage] as? UIImage else { return }
        guard let tag = tag else { return }
        
        
        insertImages[tag].image = selectedPhoto
        insertImages[tag].contentMode = .scaleAspectFill
        insertImages[tag].clipsToBounds = true
        crossButtons[tag].isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        insertImages[tag].addGestureRecognizer(tapGestureRecognizer)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
