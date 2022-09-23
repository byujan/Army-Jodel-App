//
//  DashboardController.swift
//  demo
//
//  Created by Byungwoo Jang on 12/9/20.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    let db = Firestore.firestore()
//    var messages: [Message] = [
//        Message(sender: "me", body: "hello", likes: 0)
//    ]
    var messages: [Message] = []
    let colorArr = [UIColor.systemYellow, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemOrange]
    var colorInd = 0
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                                        #selector(DashboardViewController.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.red
            
            return refreshControl
        }()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
//        if (tableView.contentSize.height < tableView.frame.size.height) {
//           tableView.isScrollEnabled = false;
//         }
//        else {
//           tableView.isScrollEnabled = true;
//         }
        title = "Confessions"
        
        tableView.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        loadMessages()
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    
    @IBAction func sendPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "sendController", sender: self)
    }
    
    
    func loadMessages() {
        db.collection("Dashboard")
            .order(by: "date")
            .addSnapshotListener{(querySnapshot, error) in
            self.messages = []
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments.reversed() {
                        let data = doc.data()
                        //print(data)
                        if let messageSender = data["sender"] as? String, let messageBody = data["message"] as? String, let messageLikes = data["likes"] as? Int {
                            
                            let newMessage = Message(sender: messageSender, body: messageBody, likes: messageLikes)
                            //print(newMessage)
                            self.messages.append(newMessage)
                           
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                if self.colorInd > 0 {
                                    self.colorInd = self.colorInd - 1
                                }
                                //let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.userDefault.set(false, forKey: "usersignedin")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension DashboardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        print(message.body)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.textField.backgroundColor = colorArr[colorInd]
        cell.textField.text = message.body
        colorInd += 1
        colorInd = colorInd % 4
        cell.likesField.text = String(messages[indexPath.row].likes) + " likes"
        return cell
    }
    

}
