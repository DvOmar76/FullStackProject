//
//  RegisterViewController.swift
//  FullStackProject
//
//  Created by DvOmar on 27/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore

class RegisterViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var fNAme: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var displayError: UILabel!
    @IBOutlet weak var email: UITextField!
    var rf = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // if all fields is not empty it will return nuill else it will return message
    func checkFileds()->String?{
      if  fNAme.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lName.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        email.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        password.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
          return "please fill in all fialds"
      }
        return nil
            
    }
    @IBAction func clicBtnRegester(_ sender: Any)
    {
        print("inside func clckbtnResgter")
        let check=checkFileds()
        //check filed is not empty
        if check != nil
        {
            // show error ,i will work on it later
            ShowError(fieldError: displayError, text: check!)
        }
        else
        {
            //take data from user
            let firstName=fNAme.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName=lName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email=email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password=password.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // create user
            createUser(firstName: firstName, lastName: lastName, email: email, password: password,fieldError: displayError)
        
        
        }
        
       
    }

    func createUser(firstName:String,lastName:String,email:String,password:String,fieldError:UILabel){
        
        Auth.auth().createUser(withEmail: email, password: password) { resulet, error in
            if error != nil
            {
                // show error
                ShowError(fieldError: fieldError, text: error!.localizedDescription)
            }
            else
            {
                let userDict:[String:Any]=[
                    k.user.firstName:firstName
                    ,k.user.lastName: lastName
                    ,k.user.email:email
                    ,k.user.conversaitions:""]
                //1 create rf
                self.rf.child("users").child(resulet!.user.uid).setValue(userDict)
                self.performSegue(withIdentifier: k.registerToChat, sender: self)

            }
        }
       
        
    }
}


func ShowError(fieldError:UILabel,text:String){
    fieldError.text=text
    fieldError.textColor=UIColor.red
}

   

