//
//  MessageVC.swift
//  FullStackProject
//
//  Created by DvOmar on 02/06/1443 AH.
//

import UIKit
import Firebase
import
class MessageVC: UIViewController  {
    var messages:[Message]=[]
    @IBOutlet weak var tableView: UITableView!
    let db=Firestore.firestore()
    
    @IBOutlet weak var fieldMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        navigationItem.hidesBackButton=true
        tableView.register(UINib(nibName: k.CellNibName, bundle: nil), forCellReuseIdentifier: k.cellIdentifier)
        loadMessages()
        // Do any additional setup after loading the view.
    }
    func loadMessages(){
    
        // addSnapshotListener if you add new messages it will update list
        db.collection(k.FireStore.collectionName).order(by: k.FireStore.dateField).addSnapshotListener { (querySnapshot, error) in
            if error != nil{
                print("error in retrieving data from Firesore.\(error.debugDescription)")
            }
            else
            {
                self.messages=[]
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                       if let messageSender=document[k.FireStore.sender] as? String
                            ,let messageBody=document[k.FireStore.bodyField] as? String{
                           self.messages.append(Message(sender: messageSender, body:messageBody ))
                           // after update messages  it will reload tabel vied
                           DispatchQueue.main.async {
                               self.tableView.reloadData()
                           }
                       }
                    }
                    
                }
            }
        }
    }
    func saveMessageInFiresbase(){
        let messageBody=fieldMessage.text
        if messageBody?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            if let messageSender=Auth.auth().currentUser?.displayName{
                db.collection(k.FireStore.collectionName).addDocument(
                    data:[
                    k.FireStore.sender:messageSender,
                    k.FireStore.bodyField:messageBody,
                    k.FireStore.dateField:Date().timeIntervalSince1970
                    ]
               ) { (error) in
                    if error != nil {
                        print("error send message \(error?.localizedDescription)")
                    }
                    else{
                        print("message save in fireStore")
                    }
                }
            }
        }
    }
    @IBAction func clickToSend(_ sender: Any) {
        saveMessageInFiresbase()
    }
}
extension MessageVC : UITableViewDataSource , UITableViewDelegate{
 

   

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k.cellIdentifier, for: indexPath) as! MessageCell
        cell.contentMessage?.text=messages[indexPath.row].body
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}
