//
//  SignupViewController.swift
//  demo
//
//  Created by Byungwoo Jang on 12/9/20.
//

import UIKit
import Firebase


class SignupViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.cornerRadius = 0.05 * signupButton.bounds.size.width
    }
    

    @IBAction func signupButton(_ sender: Any) {
        if let password1 = passwordField.text, let password2 = passwordField1.text {
            if (password1 != password2) {
                let alert = UIAlertController(title: "Error", message: "Passwords Do Not Match", preferredStyle: .alert)
                //alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "signupDashboard", sender: self)
                }
                
            }
        }
    }
}
