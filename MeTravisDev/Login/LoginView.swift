//
//  LoginView.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/12/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    static let loginKeychainKey = "login"
    
    // MARK: - View
    var body: some View {
        VStack() {
            Text("iOS App Templates")
                .font(.largeTitle).foregroundColor(Color.white)
                .padding([.top, .bottom], 40)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            Image("iosapptemplate")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.bottom, 25)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: self.$email)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    
                
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {
                self.Login()
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
            
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
            .onTapGesture {
                UIApplication.shared.endEditing()
        }
        
    }
    
    func Login() {
        Network.shared.apollo.perform(mutation: LoginMutation(login:LoginInput(email: email, password: password))){
            result in
            guard let data = try? result.get().data else {
                debugPrint("fail")
                return
            }
            let keychain = KeychainSwift()
            if keychain.set(data.login.token, forKey: LoginView.loginKeychainKey){
              // Keychain item is saved successfully
                debugPrint("keychain success")
                debugPrint(keychain.get(LoginView.loginKeychainKey) ?? "Nothing")
            } else {
              // Report error
                debugPrint("keychain fail")
                if keychain.lastResultCode != noErr {
                    debugPrint(keychain.lastResultCode)
                }
            }
            
            //debugPrint(data.login.token)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}
