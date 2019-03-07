//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Kurtis Hoang on 3/6/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var messages = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.chatTableView.estimatedRowHeight = 200
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMessages()
    }
    
    func loadMessages()
    {
        let query = PFQuery(className: "Message")
        
        query.includeKey("user")
        
        query.limit = 10
        
        //get db
        query.findObjectsInBackground { (msgs, error) in
            if msgs != nil {
                //set post to local post
                self.messages = msgs!
                //reload tableview
                self.chatTableView.reloadData()
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        
        //?? "" is the default string so it is never nil
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = PFUser.current()!
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                //print("Message is saved")
                //empty the text field
                self.messageField.text = ""
                //reload messages
                self.loadMessages()
            }
            else
            {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        
        let msg = messages[indexPath.row]
        
        let user = msg["user"] as! PFUser
        cell.userName.text = user.username
        cell.chatMessage.text = msg["text"] as! String
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
