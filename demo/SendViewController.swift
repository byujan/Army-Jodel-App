//
//  SendViewController.swift
//  demo
//
//  Created by Byungwoo Jang on 12/9/20.
//

import UIKit
import Firebase

class SendViewController: UIViewController {
    

    @IBOutlet weak var textField: UITextView!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        //textField.setContentOffset(CGPoint.zero, animated: false)
        textField.becomeFirstResponder()

    }

    @IBAction func sendPressed(_ sender: Any) {
//        db.collection("Dashboard").document("LA").setData(
//            data: ["message" : messageBody,
//                   "sender" : messageSender,
//                   "date" : Date().timeIntervalSince1970,
//                   "likes" : 0
//            ]) {
        if let messageBody = textField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("Dashboard").addDocument(
                data: ["message" : messageBody,
                       "sender" : messageSender,
                       "date" : Date().timeIntervalSince1970,
                       "likes" : 0
                ]) {
                (error) in
                if let e = error {
                    print("There was an error in saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data")
                    self.textField.text = ""
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}
