//
//  k.swift
//  FullStackProject
//
//  Created by DvOmar on 02/06/1443 AH.
//

import Foundation
struct k{
    static let loginToChat = "LogInToChat"
    static let toRegester = "LoginToRegister"
    static let registerToChat = "RegisterToChat"
    static let cellIdentifier="tableCell"
    // same tabelViewCell name
    static let CellNibName="MessageCell"
    
    struct FireStore{
        static let collectionName="Messages"
        static let sender="sender"
        static let bodyField="body"
        static let dateField="data"
    }
}
