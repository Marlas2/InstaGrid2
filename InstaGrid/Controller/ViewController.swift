//
//  ViewController.swift
//  InstaGrid
//
//  Created by Quentin Marlas on 02/05/2019.
//  Copyright © 2019 Quentin Marlas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var swipeUpLabel: UILabel!
    @IBOutlet private weak var swipeUpToShare: UIImageView!
    @IBOutlet private var insertImages: [UIImageView]!
    @IBOutlet private var crossButtons: [UIButton]!
    @IBOutlet private var layoutButtons: [UIButton]!
    @IBOutlet private weak var centralView: UIView!
    @IBOutlet private weak var topLeftView: UIView!
    @IBOutlet private weak var topRightView: UIView!
    @IBOutlet private weak var downLeftView: UIView!
    @IBOutlet private weak var downRightView: UIView!
    
    //MARK: - Vars
    private var tag : Int?
    private let pickerController = UIImagePickerController()
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(share))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else { return }
        centralView.addGestureRecognizer(swipeGestureRecognizer)
        setUpSwipeDirection()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //Display the pop up to share
    private func displaySharePopUp(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.centralView.transform = .identity
            })
        }
    }
    
    //Share when swipe up
    @objc private func share() {
        if swipeGestureRecognizer?.direction == .up {
            centralViewTranslationAnimation(x: 0, y: -view.frame.height)
            
        } else {
            centralViewTranslationAnimation(x: -view.frame.width, y: 0)
        }
    }
    
    //Animation of the central view
    private func centralViewTranslationAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.centralView.transform = CGAffineTransform(translationX: x, y: y)
            guard let image = self.centralView.convertToImage() else { return }
            self.displaySharePopUp(image: image)
        }
    }
    
    //Swipe left or up in fonction of the orientation of the device
    @objc private func setUpSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecognizer?.direction = .left
        } else {
            swipeGestureRecognizer?.direction = .up
        }
    }
    
    //Import a photo that source type is a photo library
    private func importPhotoFromLibrary() {
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction private func layoutButtonImages(_ sender: UIButton) {
        tag = sender.tag
        importPhotoFromLibrary()
    }
    
    //Choose the pattern of the central View
    @IBAction private func layoutButtonTaped(_ sender: UIButton) {
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
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        tag = sender.view?.tag
        importPhotoFromLibrary()
    }
}

//Extension
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

