//
//  SelfieViewController.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 10/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

class SelfieViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var takeSelfieView: UIView!
    @IBOutlet weak var retakeView: UIView!
    
    @IBOutlet weak var imgSelfieView: UIImageView!
    @IBOutlet weak var btnSkip: UIBarButtonItem!
    //MARK: - Variables
    
    var selectedImage = UIImage()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.layoutIfNeeded()
        
        imgSelfieView.layer.cornerRadius = imgSelfieView.frame.size.width / 2
    }
    
    //MARK: - Helper Methods

    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnLaunch_Click(_ sender: Any) {
        presentImagePicker(sourceType: .camera)
    }
    
    @IBAction func btnRetake_Click(_ sender: Any) {
        presentImagePicker(sourceType: .camera)
    }
    
    @IBAction func btnSkip_Click(_ sender: Any) {
        
        if btnSkip.title == "Done" {
            appDelegate.selfieImage = imgSelfieView.image!
        } else {
            appDelegate.selfieImage = #imageLiteral(resourceName: "userpic")
        }
        
        self.performSegue(withIdentifier: StylistSegue.additionalSegue, sender: self)
    }
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

//MARK: - UIImagePickerControllerDelegate

extension SelfieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            takeSelfieView.alpha = 0
            selectedImage = pickedImage
            imgSelfieView.image = selectedImage
            
            btnSkip.title = "Done"
        }
        dismiss(animated: true, completion: {
            
        })
    }
}
