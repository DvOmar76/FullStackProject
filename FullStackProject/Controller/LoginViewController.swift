//
//  LoginViewController.swift
//  FullStackProject
//
//  Created by DvOmar on 27/05/1443 AH.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase
class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var displayError: UILabel!
    var rf = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let conver:[String:Any]=[
//            k.Conversaition.senderUID:"k@k.com",
//            k.Conversaition.RecipientUID:"t@t.com",
//
//            "contentConv":[
//                [
//                    k.Conversaition.senderUID:"RkpFDXb5Qpf3yGNns5rBgfprekO2",
//                    k.Conversaition.contentMessage:"hello",
//                    k.Conversaition.date:Date().timeIntervalSince1970
//                ],
//                [
//                    k.Conversaition.senderUID:"wwIpKeKgRyY5RedDHqxsjtoynHG3",
//                    k.Conversaition.contentMessage:"hi omar",
//                    k.Conversaition.date:Date().timeIntervalSince1970
//                ],
//                [
//                    k.Conversaition.RecipientUID:"RkpFDXb5Qpf3yGNns5rBgfprekO2",
//                    k.Conversaition.contentMessage:"how are you",
//                    k.Conversaition.date:Date().timeIntervalSince1970
//                ],
//               
//            ]
//        ]
//        let id=UUID().uuidString
//        rf.child("conv").child("\(id)").setValue(conver)

        // Do any additional setup after loading the view.
    }
    @IBAction func SignUp(_ sender: Any) {
         performSegue(withIdentifier: k.toRegester, sender: self)
    }
   
    @IBAction func ClickOnLogIn(_ sender: Any) {
        let check=checkFileds()
        if  check == nil{
            let email=email.text
            let password=password.text
            sigin(email: email!, password: password!)
        }
        else
        {
            ShowError(fieldError: displayError, text: check!)
        }
    }
    @IBAction func continueWithGoogle(_ sender: Any) {
        login()
        
    }
    func login (){
        //google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self]user, error in
            if let error = error {
                //show errors to the user
                displayError.text=error.localizedDescription
                return
              }

              guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            //Firebase Auth
            Auth.auth().signIn(with: credential){result,error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                  }
                //displaying User Name
                guard let user = result?.user else{
                    return
                }
                performSegue(withIdentifier: k.loginToChat, sender: self)

                print(user.displayName ?? "Succes!")
            }
        }
    }
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }

    func sigin(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
          
            if error != nil
            {
                ShowError(fieldError: self.displayError! , text: error!.localizedDescription)
               
            }
            else
            {
                self.performSegue(withIdentifier: k.loginToChat, sender: self)

            }
        }
        
    }

    func checkFileds()->String?{
      if email.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        password.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
          return "please fill in all fialds"
      }
        return nil
}

}
