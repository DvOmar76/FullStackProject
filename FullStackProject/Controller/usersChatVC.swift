//
//  usersChatVC.swift
//  FullStackProject
//
//  Created by DvOmar on 04/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseDatabase
class usersChatVC: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var table: UITableView!
    var rf : DatabaseReference! = Database.database().reference()
    var users:[[String:Any]]=[]
    var ListUIDs:[String]=[]
    var listMessages:[[String:Any]]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
        navigationItem.hidesBackButton=true
        // to add table cell to table view
        table.allowsSelection = true
        let nib = UINib(nibName: k.UsersCellNibName, bundle: nil)
        table.register(nib, forCellReuseIdentifier: k.cellUsersChatIdentifier)
        //1- get ids of conversaitions from firebase (users)
        //2- get userID of another user from firebase (conv) and save it in ListUIDs + save messages to listMessage
        //3- show of another user info in chats page
        //4- if select user cell it will pass listMessage  and go to page message
        loadUsers()
    }
    func checkFiled()->String?{
      if field.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
          return "please fill in all fialds"
      }
        return nil
            
    }
    @IBAction func search(_ sender: Any) {
//        if  checkFiled() == nil {
//            for user in users {
//                if field.text == user.key {
//                    print(user.value)
//                }
//            }
//        }
    }
    // MARK: 1- get ids of conversaitions from firebase (users)
    func loadUsers(){
                                           // user id
            rf.child("users").child("RkpFDXb5Qpf3yGNns5rBgfprekO2").observeSingleEvent(of: .value) { DataSnapshot in
                if let user = DataSnapshot.value as? [String:Any] {
                    self.getUIDs(idOfConversaition:user[k.user.conversaitions]! as! String )
                }
        }
    }
    // MARK: 3- show of another user info in chats page
    func loadUserInfo(uIDUser:String){
            users=[]
            rf.child("users").child(uIDUser).observeSingleEvent(of: .value) { DataSnapshot in
                self.users.append(DataSnapshot.value as! [String : Any])
//                print("from load user info \(self.users[0])____________")
//                print(self.users.count)
                DispatchQueue.main.async {
                    self.table.reloadData()
//                    let indexPath=IndexPath(row: self.messages.count-1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)

                }
            }
        }

    // MARK:  2- get userID of another user from firebase (conv) and save it in ListUIDs + save messages to listMessage
        func getUIDs(idOfConversaition:String){
            self.listMessages=[]
            rf.child("conv").observeSingleEvent(of: .value) { DataSnapshot in
                guard let conv=DataSnapshot.value as? [String:[String:Any]]
                                else{return}
//                self.display.text="\(conv[id]![k.Conversaition.RecipientUID]!)"
//                self.display.text="\(DataSnapshot.value)"
                let senderUID=conv[idOfConversaition]![k.Conversaition.senderUID]!

                let recipientUID=conv[idOfConversaition]![k.Conversaition.RecipientUID]!
                if "\(senderUID)" != "RkpFDXb5Qpf3yGNns5rBgfprekO2" {
                    self.ListUIDs.append("\(senderUID)")
//                    print("!@# \(conv[idOfConversaition]!["contentConv"]!) !@#")
                    print("++++\(senderUID)++++")
                    self.listMessages=conv[idOfConversaition]!["contentConv"]! as! [[String : Any]]
                    print("!@# \(self.listMessages) !@#")

                }
                 else{
                     self.ListUIDs.append("\(recipientUID)")
                     print("--- \(recipientUID)")
//                     print("!@# \(conv[idOfConversaition]!["contentConv"]!) !@#")
                     self.listMessages=conv[idOfConversaition]!["contentConv"]! as! [[String : Any]]
                     print("!@# \(self.listMessages) !@#")

                }
//                self.display.text="\(senderUID) |  \(recipientUID)"
                self.loadUserInfo(uIDUser: self.ListUIDs[0])
            }
        }
    
}


extension usersChatVC : UITableViewDataSource , UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k.cellUsersChatIdentifier, for: indexPath) as! usersCell
        if users.count != 0{
            cell.displayName.text="\(users[0][k.user.firstName]!) \(users[0][k.user.lastName]!)"
            cell.lastMessage.text="hello omar ar you ok , i will come to you in night"
            print("\(self.users) =====")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("++++++++++++++++\(indexPath.row)+++++++++++++++++++")
        let toChat=storyboard?.instantiateViewController(withIdentifier: k.messagesID) as! MessageVC
        toChat.messages=listMessages
        navigationController?.pushViewController(toChat, animated: true)
    
    }
    

}
