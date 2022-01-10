//
//  MessageVC.swift
//  FullStackProject
//
//  Created by DvOmar on 02/06/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
class MessageVC: UIViewController  {
    var messages:[[String:Any]]=[]
    
    
    
    @IBOutlet weak var tableView: UITableView!
    let rf = Database.database().reference()

    @IBOutlet weak var fieldMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        navigationItem.hidesBackButton=true
        // to add table cell to table view
        print("!!!!!\(Auth.auth().currentUser?.uid)!!!!!" )
        tableView.register(UINib(nibName: k.CellNibName, bundle: nil), forCellReuseIdentifier: k.cellIdentifier)
        print("\(messages)")
        loadMessages()
    }
    func loadMessages(){

        self.messages=[]
        rf.child("conv").observeSingleEvent(of: .value) { DataSnapshot in
            guard let conv=DataSnapshot.value as? [String:[String:Any]]
                            else{return}
//                self.display.text="\(conv[id]![k.Conversaition.RecipientUID]!)"
//                self.display.text="\(DataSnapshot.value)"
               self.messages=conv["E3221996-1CCA-460B-914E-2A3F1330C7DB"]!["contentConv"]! as! [[String : Any]]
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                    let indexPath=IndexPath(row: self.messages.count-1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)

            }
            print("\(self.messages)")
        }
    }
    func saveMessageInFiresbase(){
        let messageBody=fieldMessage.text
        //check field it's not empty
        if messageBody?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            if let senderEmail=Auth.auth().currentUser?.email{
                let message=newMessage(message: messageBody!,senderEmail:"\(senderEmail)")
                rf.child(k.Conversaition.collectionName).setValue(message)
                 
                }
            }
        }
    }
//    @IBAction func clickToSend(_ sender: Any) {
//        saveMessageInFiresbase()
//    }
//}

func newMessage(message:String ,senderEmail:String)->[String : Any]{
    
    let date=Date().timeIntervalSince1970
    let idConversaition=UUID().uuidString
    let newMessage=[
        k.Conversaition.idConversaition:idConversaition,
        k.Conversaition.senderUID:senderEmail,
        k.Conversaition.RecipientUID:"t@t.com",
        k.Conversaition.contentMessage:message,
        k.Conversaition.date:date,
        k.Conversaition.isRead:"false"
    ] as [String : Any]
    return newMessage
}

extension MessageVC : UITableViewDataSource , UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("00")
         let message=messages[indexPath.row]
         print("______\(message)______")
         let cell = tableView.dequeueReusableCell(withIdentifier: k.cellIdentifier, for: indexPath) as! MessageCell
         cell.contentMessage?.text=message[k.Conversaition.contentMessage] as? String
         // if the message from current user it will be on the right side
         if message[k.Conversaition.senderUID] as? String  == "RkpFDXb5Qpf3yGNns5rBgfprekO2"{
             cell.spaceLeft.isHidden=false
             cell.spaseRight?.isHidden=true
             cell.contentMessage.textAlignment = .right
             cell.view?.backgroundColor=UIColor.green.withAlphaComponent(0.95)
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

