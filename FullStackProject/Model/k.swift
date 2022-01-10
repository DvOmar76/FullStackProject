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
    static let cellUsersChatIdentifier="tableCellUsers"
    static let messagesID="MessagesID"
    
    // same tabelViewCell name
    static let CellNibName="MessageCell"
    
    static let UsersCellNibName="usersCell"
    
    struct Conversaition{
        static let collectionName="Conversations"
        static let idConversaition="idConversaition"
        static let senderUID="senderUID"
        static let RecipientUID="RecipientUID"
        static let contentMessage="contentMessage"
        static let date="data"
        static let isRead="isRead"
        static let imageUrl="imageUrl"
    }
    struct user{
        static let firstName="firstName"
        static let lastName="lastName"
        static let email="email"
        static let conversaitions="conversaitions"


    }
}
