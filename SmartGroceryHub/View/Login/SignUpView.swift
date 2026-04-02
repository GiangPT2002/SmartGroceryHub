//
//  SignUpView.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 18/2/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var mainVM = MainViewModel.shared;
    
    var body: some View {
        
        ZStack{
            
            Image("bottom_bg")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight)
            
            ScrollView{
                VStack{
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding(.bottom, .screenWidth * 0.0)
                    
                    Text("Đăng ký")
                        .font(.customfont(.bold, fontSize: 40))
                        .foregroundColor(.primaryText)
                        .padding(.bottom, 4)
                    Text("Nhập thông tin cá nhân của bạn")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(.secondaryText)
                        .padding(.bottom, .screenWidth * 0.1)
                    
                    LineTextField( title: "Họ và tên", placholder: "Nhập họ và tên của bạn", txt: $mainVM.txtUsername)
                        .font(.customfont(.medium, fontSize: 16))
                        .padding(.bottom, .screenWidth * 0.07)
                    
                    LineTextField( title: "Email", placholder: "Nhập email của bạn", txt: $mainVM.txtEmail, keyboardType: .emailAddress)
                        .font(.customfont(.medium, fontSize: 16))
                        .padding(.bottom, .screenWidth * 0.07)
                    
                    LineSecureField( title: "Mật khẩu", placholder: "Nhập mật khẩu của bạn", txt: $mainVM.txtPassword, isShowPassword: $mainVM.isShowPassword)
                        .font(.customfont(.medium, fontSize: 16))
                        .padding(.bottom, .screenWidth * 0.02)
                    
                    VStack {
                        Text("Để tiếp tục, bạn đồng ý với")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.secondaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            
                            Text("Điều khoản dịch vụ")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(.primaryApp)
                                
                            
                            Text("và")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(.secondaryText)
                                
                            
                            Text("Chính sách bảo mật của chúng tôi.")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(.primaryApp)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                        }
                        .padding(.bottom, .screenWidth * 0.02)
                    }
                    
                    RoundButton(title: "Đăng ký") {
                        mainVM.serviceCallSignUp()
                    }
                    .font(.customfont(.medium, fontSize: 16))
                    .padding(.bottom, .screenWidth * 0.05)
                    
                    NavigationLink {
                        LoginView()
                    } label: {
                        HStack{
                            Text("Bạn đã có tài khoản?")
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(.primaryText)
                            
                            Text("Đăng nhập")
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(.primaryApp)
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, .topInsets + 64)
                .padding(.horizontal, 20)
                .padding(.bottom, .bottomInsets)
            }
            
            
            VStack{
                
                HStack{
                    Button{
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, 20)
            
        }
        .alert(isPresented: $mainVM.showError, content: {
            Alert(title: Text(Globs.AppName), message: Text(mainVM.errorMessage) , dismissButton: .default(Text("Ok")))
        })
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    SignUpView()
}
