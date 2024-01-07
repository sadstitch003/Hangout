//
//  LoginView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 67/255, green: 147/255, blue: 267/255)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("hangoutputih")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        NavigationLink(destination: LoginFormView()) {
                            Text("LOG IN")
                                .padding(10)
                                .frame(width: 150)
                                .background(Color.white)
                                .foregroundStyle(Color.black)
                                .clipShape(Capsule())
                                .bold()
                        }
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("SIGN UP")
                                .padding(10)
                                .frame(width: 150)
                                .background(Color(red: 254/255, green: 253/255, blue: 84/255))
                                .foregroundStyle(Color.black)
                                .clipShape(Capsule())
                                .bold()
                        }
                    }
                }
                .frame(height: 700)
            }
        }
    }
}



#Preview {
    LoginView()
}
