//
//  AddPlaceVC.swift
//  MetroTest
//
//  Created by Mustafa Kaan ARIN on 6.03.2024.
//

import UIKit



class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosphereText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
        

    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        
        
        
        if (placeNameText.text != "" && placeTypeText.text != ""  && placeAtmosphereText.text != ""){
            
            if let chosenImage = placeImageView.image{
                let placeModel = PlaceModal.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeImage = chosenImage
                placeModel.placeAtmosphere = placeAtmosphereText.text!
            }
            
            
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else{
            makeAlert(titleInput: "Error", messageInput: "Tüm alanları eksiksiz doldurunuz.")
        }
        
        
    }

    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }

}
