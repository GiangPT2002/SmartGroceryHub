//
//  ProfileEditView.swift
//  SmartGroceryHub
//
//  Created by AI Assistant.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var mainVM = MainViewModel.shared
    
    @State private var editName: String = ""
    @State private var editEmail: String = ""
    @State private var showSaved: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Thông tin cá nhân")
                        .font(.customfont(.bold, fontSize: 22))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 25, height: 25)
                }
                .padding(.top, .topInsets + 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // Avatar
                        VStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.primaryApp)
                            
                            Text(mainVM.userObj.username.isEmpty ? "Người dùng" : mainVM.userObj.username)
                                .font(.customfont(.bold, fontSize: 22))
                                .foregroundColor(.primaryText)
                        }
                        .padding(.top, 30)
                        
                        // Fields
                        VStack(spacing: 20) {
                            ProfileField(title: "Họ và tên", value: $editName, icon: "person")
                            ProfileField(title: "Email", value: $editEmail, icon: "envelope")
                        }
                        .padding(.horizontal, 20)
                        
                        // Save button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showSaved = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSaved = false
                            }
                        } label: {
                            HStack {
                                if showSaved {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Đã lưu!")
                                } else {
                                    Text("Lưu thay đổi")
                                }
                            }
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(showSaved ? Color(hex: "27AE60") : Color.primaryApp)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            editName = mainVM.userObj.username
            editEmail = mainVM.userObj.email
        }
    }
}

struct ProfileField: View {
    var title: String
    @Binding var value: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.customfont(.semibold, fontSize: 15))
                .foregroundColor(.secondaryText)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primaryApp)
                    .frame(width: 24)
                
                TextField(title, text: $value)
                    .font(.customfont(.medium, fontSize: 17))
                    .foregroundColor(.primaryText)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    ProfileEditView()
}
