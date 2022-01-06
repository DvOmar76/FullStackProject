//
//  ProfileViewController.swift
//  FullStackProject
//
//  Created by DvOmar on 27/05/1443 AH.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton=true
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        logout()
    }
    
    func logout(){
       
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    
}
