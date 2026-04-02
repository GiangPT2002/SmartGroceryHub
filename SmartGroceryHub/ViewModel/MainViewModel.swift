//
//  MainViewModel.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 11/2/25.
//

import SwiftUI
import FirebaseAuth

class MainViewModel: ObservableObject {
    static var shared: MainViewModel = MainViewModel()
    
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false

    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var isUserLogin: Bool = false
    @Published var userObj: UserModel = UserModel()
    
    var firebaseService: FirebaseServiceProvider = FirebaseService.shared
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        // Listen for Firebase Auth state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.userObj = UserModel(firebaseUser: user)
                    self?.isUserLogin = true
                } else {
                    self?.userObj = UserModel()
                    self?.isUserLogin = false
                }
            }
        }
        
        #if DEBUG
        txtUsername = "Phạm Trường Giang"
        txtEmail = "giangdeptrai2k2@gmail.com"
        txtPassword = "123456"
        #endif
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Firebase Auth: Login
    
    func serviceCallLogin() {
        
        if(!txtEmail.isValidEmail) {
            self.errorMessage = "vui lòng nhập địa chỉ email hợp lệ"
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "vui lòng nhập mật khẩu hợp lệ"
            self.showError = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let user = try await self.firebaseService.signIn(
                    email: txtEmail,
                    password: txtPassword
                )
                
                // Fetch additional user data from Firestore
                let userData = try await self.firebaseService.fetchUserData(uid: user.uid)
                
                await MainActor.run {
                    self.userObj = UserModel(firebaseUser: user, userData: userData)
                    self.isUserLogin = true
                    self.isLoading = false
                    self.clearInputFields()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.firebaseErrorMessage(error)
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Firebase Auth: Sign Up
    
    func serviceCallSignUp() {
        
        if(txtUsername.isEmpty) {
            self.errorMessage = "vui lòng nhập tên hợp lệ"
            self.showError = true
            return
        }
        
        if(!txtEmail.isValidEmail) {
            self.errorMessage = "vui lòng nhập địa chỉ email hợp lệ"
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "vui lòng nhập mật khẩu hợp lệ"
            self.showError = true
            return
        }
        
        if(txtPassword.count < 6) {
            self.errorMessage = "mật khẩu phải có ít nhất 6 ký tự"
            self.showError = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let user = try await self.firebaseService.signUp(
                    email: txtEmail,
                    password: txtPassword,
                    username: txtUsername
                )
                
                await MainActor.run {
                    self.userObj = UserModel(firebaseUser: user)
                    self.isUserLogin = true
                    self.isLoading = false
                    self.clearInputFields()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.firebaseErrorMessage(error)
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try self.firebaseService.signOut()
            self.userObj = UserModel()
            self.isUserLogin = false
        } catch {
            self.errorMessage = "Không thể đăng xuất. Vui lòng thử lại."
            self.showError = true
        }
    }
    
    // MARK: - Helpers
    
    private func clearInputFields() {
        self.txtUsername = ""
        self.txtEmail = ""
        self.txtPassword = ""
        self.isShowPassword = false
    }
    
    private func firebaseErrorMessage(_ error: Error) -> String {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Mật khẩu không đúng. Vui lòng thử lại."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Địa chỉ email không hợp lệ."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email này đã được sử dụng. Vui lòng đăng nhập."
        case AuthErrorCode.weakPassword.rawValue:
            return "Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn."
        case AuthErrorCode.userNotFound.rawValue:
            return "Không tìm thấy tài khoản với email này."
        case AuthErrorCode.networkError.rawValue:
            return "Lỗi kết nối mạng. Vui lòng kiểm tra internet."
        case AuthErrorCode.tooManyRequests.rawValue:
            return "Quá nhiều yêu cầu. Vui lòng thử lại sau."
        default:
            return error.localizedDescription
        }
    }
}
