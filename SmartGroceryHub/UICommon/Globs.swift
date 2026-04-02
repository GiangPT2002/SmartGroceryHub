//
//  Globs.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 12/2/25.
//

import SwiftUI

struct Globs {
    static let AppName = "Smart Grocery Hub"
    
    // UserDefaults keys
    static let userPayload = "user_payload"
    static let userLogin = "user_login"
    
    // Firestore collection names
    static let productsCollection = "products"
    static let typesCollection = "types"
    static let usersCollection = "users"
}

class Utils {
    class func UDSET(data: Any, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func UDValue( key: String) -> Any {
       return UserDefaults.standard.value(forKey: key) as Any
    }
    
    class func UDValueBool( key: String) -> Bool {
       return UserDefaults.standard.value(forKey: key) as? Bool ?? false
    }
    
    class func UDValueTrueBool( key: String) -> Bool {
       return UserDefaults.standard.value(forKey: key) as? Bool ?? true
    }
    
    class func UDRemove( key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
