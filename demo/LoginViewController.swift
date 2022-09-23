//
//  ViewController.swift
//  demo
//
//  Created by Byungwoo Jang on 12/8/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 0.05 * loginButton.bounds.size.width
        signupButton.layer.cornerRadius = 0.05 * loginButton.bounds.size.width
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "loginDashboard", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.userDefault.set(true, forKey: "usersignedin")
                    self.userDefault.synchronize()
                    self.performSegue(withIdentifier: "loginDashboard", sender: self)
                }
                
            }
        }
    }
    
}

