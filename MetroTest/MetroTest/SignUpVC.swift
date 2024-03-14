//
//  ViewController.swift
//  MetroTest
//
//  Created by Mustafa Kaan Arın on 4.03.2024.
//

import UIKit
import ParseCore
import ParseUI

class SignUpVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != nil {
            showLoadingPopup()
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { succes, error in
                if error != nil{
                    
                    self.hideLoadingPopup()
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                }
                
                else {
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        
        else{
            self.makeAlert(titleInput: "Error", messageInput: "Username veya Password kısmını boş bırakmayınız.")
        }
    }
    
    @IBAction func singInClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            showLoadingPopup()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                    self.hideLoadingPopup()
                    
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    }
                }
            } }else {
                makeAlert(titleInput: "Error", messageInput: "Kullanıcı adı ve şifre giriniz.")
            }
        
        }
        
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
        func showLoadingPopup() {
            let containerView = UIView(frame: UIScreen.main.bounds)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            containerView.tag = 100
            
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = containerView.center
            loadingIndicator.startAnimating()
            
            containerView.addSubview(loadingIndicator)
            
            UIApplication.shared.keyWindow?.addSubview(containerView)
        }
    
        
        func hideLoadingPopup() {
            if let containerView = UIApplication.shared.keyWindow?.viewWithTag(100) {
                   // containerView'i kaldır
                   containerView.removeFromSuperview()
               }
        }
}

