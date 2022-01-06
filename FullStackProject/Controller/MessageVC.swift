//
//  MessageVC.swift
//  FullStackProject
//
//  Created by DvOmar on 02/06/1443 AH.
//

import UIKit
import Firebase
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
                               let indexPath=IndexPath(row: self.messages.count-1, section: 0)
                               self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)

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
            if let messageSender=Auth.auth().currentUser?.email{
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
                        
                        //DispatchQueue.main.async that mean this work in main thred
                        DispatchQueue.main.async {
                            self.fieldMessage.text=""
                        }
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
        
        let message=messages[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: k.cellIdentifier, for: indexPath) as! MessageCell
         cell.contentMessage?.text=messages[indexPath.row].body
         // if the message from current user it will be on the right side
         if message.sender == Auth.auth().currentUser?.email{
             cell.spaceLeft.isHidden=false
             cell.spaseRight?.isHidden=true
             cell.contentMessage.textAlignment = .right
             cell.view?.backgroundColor=UIColor.blue.withAlphaComponent(0.95)
         }
         else
         {
             cell.spaceLeft.isHidden=true
             cell.spaseRight?.isHidden=false
             cell.contentMessage.textAlignment = .left
             cell.view?.backgroundColor=UIColor.gray.withAlphaComponent(0.60)
         }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}
