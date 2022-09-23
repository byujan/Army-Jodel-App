//
//  MessageCell.swift
//  demo
//
//  Created by Byungwoo Jang on 12/9/20.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    let db = Firestore.firestore()
    


    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var likesField: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = UIColor.black
        likesField.textColor = UIColor.black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likePressed(_ sender: Any) {
        
        if let fieldText = textField.text {
            
            db.collection("Dashboard")
                .whereField("message", isEqualTo: fieldText)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print(err)
                    } else if querySnapshot!.documents.count != 1 {
                        // Perhaps this is an error for you?
                    } else {
                        let document = querySnapshot!.documents.first
                        let prevlike = document?.get("likes") as! Int
                        print(prevlike)
                        document?.reference.updateData([
                            "likes": prevlike + 1
                        ])
                        self.likeButton.isEnabled = false
                    }
                }
        }
    }
}
