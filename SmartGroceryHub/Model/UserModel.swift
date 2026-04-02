//
//  UserModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 18/2/25.
//

import SwiftUI
import FirebaseAuth

struct UserModel: Identifiable, Equatable {
    
    var id: String = ""
    var username: String = ""
    var name: String = ""
    var email: String = ""
    var mobile: String = ""
    var mobileCode: String = ""
    
    // Init from Firebase Auth User
    init(firebaseUser: User, userData: [String: Any]? = nil) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.name = firebaseUser.displayName ?? ""
        self.username = userData?["username"] as? String ?? firebaseUser.displayName ?? ""
        self.mobile = userData?["mobile"] as? String ?? ""
        self.mobileCode = userData?["mobile_code"] as? String ?? ""
    }
    
    // Default empty init
    init() {
        self.id = ""
        self.username = ""
        self.name = ""
        self.email = ""
        self.mobile = ""
        self.mobileCode = ""
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}
