//
//  ServiceCall.swift
//  SmartGroceryHub
//
//  Migrated to Firebase by AI Assistant.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    // MARK: - Auth
    
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    func signUp(email: String, password: String, username: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = result.user
        
        // Save additional user data to Firestore
        try await db.collection("users").document(user.uid).setData([
            "username": username,
            "name": username,
            "email": email,
            "mobile": "",
            "mobile_code": "",
            "created_at": FieldValue.serverTimestamp()
        ])
        
        // Update display name
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = username
        try await changeRequest.commitChanges()
        
        return user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Firestore: Home Data
    
    func fetchOfferProducts() async throws -> [ProductModel] {
        let snapshot = try await db.collection("products")
            .whereField("is_offer", isEqualTo: true)
            .getDocuments()
        
        return snapshot.documents.map { doc in
            ProductModel(id: doc.documentID, data: doc.data())
        }
    }
    
    func fetchBestSellProducts() async throws -> [ProductModel] {
        let snapshot = try await db.collection("products")
            .whereField("is_best_sell", isEqualTo: true)
            .getDocuments()
        
        return snapshot.documents.map { doc in
            ProductModel(id: doc.documentID, data: doc.data())
        }
    }
    
    func fetchAllProducts() async throws -> [ProductModel] {
        let snapshot = try await db.collection("products")
            .getDocuments()
        
        return snapshot.documents.map { doc in
            ProductModel(id: doc.documentID, data: doc.data())
        }
    }
    
    func fetchTypes() async throws -> [TypeModel] {
        let snapshot = try await db.collection("types")
            .getDocuments()
        
        return snapshot.documents.map { doc in
            TypeModel(id: doc.documentID, data: doc.data())
        }
    }
    
    func fetchUserData(uid: String) async throws -> [String: Any]? {
        let doc = try await db.collection("users").document(uid).getDocument()
        return doc.data()
    }
}
