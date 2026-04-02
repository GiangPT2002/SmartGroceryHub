//
//  LoginView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 11/2/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var loginVM = MainViewModel.shared;
    
    var body: some View {
        ZStack{
            Image("bottom_bg")
            .resizable()
            .scaledToFill()
            .frame(width: .screenWidth, height: .screenHeight)
            
            VStack{
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.bottom, .screenWidth * 0.0)
                
                Text("Đăng nhập")
                    .font(.customfont(.bold, fontSize: 40))
                    .foregroundColor(.primaryText)
                    .bold()
                    .padding(.bottom, 4)
                Text("Nhập Email và mật khẩu của bạn")
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(.secondaryText)
                    .padding(.bottom, .screenWidth * 0.1)
                
                LineTextField( title: "Email", placholder: "Nhập email của bạn", txt: $loginVM.txtEmail, keyboardType: .emailAddress)
                    .font(.customfont(.medium, fontSize: 16))
                    .padding(.bottom, .screenWidth * 0.07)
                
                LineSecureField( title: "Mật khẩu", placholder: "Nhập mật khẩu của bạn", txt: $loginVM.txtPassword, isShowPassword: $loginVM.isShowPassword)
                    .font(.customfont(.medium, fontSize: 16))
                    .padding(.bottom, .screenWidth * 0.02)
                
                Button{
                    
                } label: {
                    Text("Bạn quên mật khẩu?")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(.primaryText)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, .screenWidth * 0.03)
                
                RoundButton(title: "Đăng nhập") {
                    loginVM.serviceCallLogin()
                }
                .font(.customfont(.medium, fontSize: 16))
                .padding(.bottom, .screenWidth * 0.05)
                
                NavigationLink {
                    SignUpView()
                } label: {
                    HStack{
                        Text("Bạn chưa có tài khoản?")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.primaryText)
                        
                        Text("Đăng ký")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.primaryApp)
                    }
                }
                
                Spacer()
                
            }
            .padding(.top, .topInsets + 64)
            .padding(.horizontal, 20)
            .padding(.bottom, .bottomInsets)
            
            VStack{
                
                HStack{
                    
                    Button{
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, 20)
            
        }
        .alert(isPresented: $loginVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text( loginVM.errorMessage ), dismissButton: .default(Text("OK")))
        }
        .background(Color.white)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationView{
        LoginView()
    }
}
